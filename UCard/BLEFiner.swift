//
//  BLEFiner.swift
//  UCard
//
//  Created by YunSang Lee on 2017. 5. 21..
//  Copyright © 2017년 CITeam44. All rights reserved.
//

import UIKit

import CoreBluetooth

protocol BLEFinderDelegate {
    func BLEFinderFoundClosest(key: String)
    func BLEFinderVerifiedCurrentCentral()
    func BLEFinderHasReceivedCard(name: String, titleName: String, companyName: String, phone: String, email: String, addressOne: String, addressTwo: String, design: String)
}

class BLEFinder: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    var centralManager: CBCentralManager?
    private var targetPeripheral: CBPeripheral?
    private var data: NSMutableData
    var delegate: BLEFinderDelegate?
    var uniqueID = ""
    
    let acceptableRange = -50
    
    override init() {
        data = NSMutableData()
        super.init()
        // Start up the CBCentralManager in separate queue
        let centralQueue = DispatchQueue(label: "com.citeam44.UCard.BLEFinder") // this is serial queue
        centralManager = CBCentralManager(delegate: self, queue: centralQueue)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            centralManager?.scanForPeripherals(withServices: [uuid],
                                               options: [CBCentralManagerScanOptionAllowDuplicatesKey: false])
        }
    }
    
    func centralManager(_ central: CBCentralManager,
                        didDiscover peripheral: CBPeripheral,
                        advertisementData: [String : Any],
                        rssi RSSI: NSNumber) {
        print("Discovered \(String(describing: peripheral.name)) \(peripheral.identifier) at \(RSSI)")
        if(acceptableRange <= RSSI.intValue) {
            // the device is under acceptable range
            // stop scanning
            centralManager?.stopScan()
            
            // try to connect
            targetPeripheral = peripheral; // save a copy to prevent the variable getting garbage collected
            centralManager?.connect(peripheral, options: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager,
                        didFailToConnect peripheral: CBPeripheral,
                        error: Error?) {
        // failed to connect
        cleanUp()
    }
    
    func centralManager(_ central: CBCentralManager,
                        didConnect peripheral: CBPeripheral) {
        
        // Make sure the discovery callback comes back
        peripheral.delegate = self
        
        peripheral.discoverServices([uuid])
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if((error) != nil) {
            // error handling
        }
        for service in peripheral.services ?? [CBService]() {
            peripheral.discoverCharacteristics([uuid],
                                               for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if((error) != nil) {
            // error handling
        }
        for characteristic in service.characteristics! {
            if(characteristic.uuid == uuid) {
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if((error) != nil) {
            // error handling
        }
        let stringData = String.init(data: characteristic.value!, encoding: .utf8)
        if(stringData == "EOM") {
            print("recieved message: " + String.init(data: self.data as! Data, encoding: .utf8)!)
            
            // security related codes are comented for now
            /*
            let fields = String.init(data: self.data as! Data, encoding: .utf8)?.components(separatedBy: "^&^")
            
            if(fields?[0] == "ID") {
                if(fields?[2] == uniqueID) { // see if the ohter end have our key
                    delegate!.BLEFinderVerifiedCurrentCentral()
                } else {
                    delegate!.BLEFinderFoundClosest(key: fields![1])
                }
            } else if(fields?[0] == "Card") {
 */
            let fields = dataParser(str: String.init(data: self.data as Data, encoding: .utf8)!)
            DispatchQueue.main.async {
                self.delegate!.BLEFinderHasReceivedCard(name: fields[1], titleName: fields[2], companyName: fields[3], phone: fields[4], email: fields[5], addressOne: fields[6], addressTwo: fields[7], design: fields[8])
                
            }
            //}
        } else {
            data.append(characteristic.value!)
            print("recieved : " + stringData!)
        }
    }
    
    func cleanUp() {
        // this function is only needed when the connection is still there
        if !(targetPeripheral?.state == .connected) {
            return
        }
        
        for service in self.targetPeripheral!.services! {
            if (service.characteristics != nil) {
                for characteristic in service.characteristics! {
                    if (characteristic.uuid == uuid) {
                        if (characteristic.isNotifying) {
                            // It is notifying, so unsubscribe
                            self.targetPeripheral?.setNotifyValue(false, for: characteristic)
                            return;
                        }
                    }
                }
            }
        }
    }
    
    func proveTargetPeripheral(withID: String) {
    }
    
    func dataParser(str: String) -> [String] {
        var result = ["","","","","","","","",""]
        var chunkCounter = 0
        var startIndex = str.startIndex
        var checker = 0
        var i = 0
        for character in str.characters {
            if(character == "^" && checker != 1) {
                checker += 1
            } else if(character == "&" && checker == 1) {
                checker += 1
            } else if(checker == 3) {
                result[chunkCounter] = str.substring(with: startIndex..<str.index(startIndex, offsetBy: i - 3))
                startIndex = str.index(startIndex, offsetBy: i)
                chunkCounter += 1
                checker = 0
                i = 0
                if(chunkCounter == 8) {
                    break
                }
            } else {
                checker = 0
            }
            i += 1
        }
        result[8] = str.substring(from: startIndex)
        return result
        
    }
    
    deinit {
        centralManager?.stopScan()
        cleanUp()
        //self.data = nil
        
        self.centralManager?.delegate = nil
        self.centralManager = nil
    }
}
