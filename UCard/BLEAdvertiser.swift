//
//  BLEAdvertiser.swift
//  UCard
//
//  Created by YunSang Lee on 2017. 5. 22..
//  Copyright © 2017년 CITeam44. All rights reserved.
//

import UIKit

import CoreBluetooth

protocol BLEAdvertiserDelegate {
    func peripheralDidSubscribe() -> String
}

// unique id for this app
let uuid = CBUUID(string: "8A6A072D-B340-4C71-BE88-2AB1482CE661")

class BLEAdvertiser: NSObject, CBPeripheralManagerDelegate {
    var peripheralManager:CBPeripheralManager?
    
    var delegate: BLEAdvertiserDelegate?
    var sendingData:Data?
    var sendingDataIdx: Data.Index = 0
    var uniqueID = ""
    var targetPeripheralID = ""
    var centralIsVerified = false
    var characteristic:CBMutableCharacteristic?
    var sendingEOM = false
    let chunkLimit: Data.Index = 20
    
    var personalCard: PersonalCard?
    
    override init() {
        super.init()
        
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if peripheral.state == .poweredOn {
            characteristic = CBMutableCharacteristic(type: uuid,
                                                         properties: .notify,
                                                         value: nil,
                                                         permissions: .readable)
            let service = CBMutableService(type: uuid,
                                           primary: true)
            
            service.characteristics = [characteristic!]
            
            peripheralManager!.add(service)
            
            let advertisingDictionary:NSDictionary = [CBAdvertisementDataServiceUUIDsKey    : [uuid],
                                                      CBAdvertisementDataLocalNameKey       : "UCard"]
            
            peripheralManager!.startAdvertising(advertisingDictionary as? [String : Any])
        } else if peripheral.state == .poweredOff {
            peripheralManager!.stopAdvertising()
        }
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
        // TODO: verification steps
         //if(centralIsVerified) {
            var stringData = "Card^&^"
            stringData += (personalCard!.name! + "^&^")
            stringData += (personalCard!.titleName! + "^&^")
            stringData += (personalCard!.companyName! + "^&^")
            stringData += (personalCard!.phone! + "^&^")
            stringData += (personalCard!.email! + "^&^")
            stringData += (personalCard!.addressOne! + "^&^")
            stringData += (personalCard!.addressTwo! + "^&^")
            stringData += personalCard!.design!
            sendingData = (stringData.data(using: .utf8))
            sendingDataIdx = 0
            sendData()
        /*
        } else {
            sendingData = ("ID^&^" + uniqueID + "^&^" + targetPeripheralID).data(using: .utf8)
            sendingDataIdx = 0
            print("sending message: \("ID^&^" + uniqueID + "^&^" + targetPeripheralID)")
            sendData()
        }
        */
        
    }
    
    func sendData() {
        // check whether data or EOM need to be sent
        if(sendingEOM) {
            // EOM need to be sent
            // sending EOM
            let didSend = peripheralManager!.updateValue("EOM".data(using: .utf8)!, for: characteristic!, onSubscribedCentrals: nil)
            // check if it sent
            if(didSend) {
                sendingEOM = false
                print("Sent EOM")
            }
            return
        }
        
        // data need to be sent
        var didSend = true
        while(didSend) {
            // make new chunk
            
            var sendingAmount:Data.Index = sendingData!.count - sendingDataIdx
            sendingAmount = sendingAmount > chunkLimit ? chunkLimit : sendingAmount
            
            let chunk = sendingData?.subdata(in: Range<Data.Index>(uncheckedBounds: (lower: sendingDataIdx, upper:sendingDataIdx+sendingAmount)))
            
            didSend = peripheralManager!.updateValue(chunk!, for: characteristic!, onSubscribedCentrals: nil)
            
            if(!didSend) {
                print("Error in BLEAdvertiser.swift: Failed to transmit data to central")
                return
            }
            
            // print out transmited data for debuging purpose
             var stringData = String(data: chunk!, encoding: .utf8)!
            print("sent : \(stringData)")
            
            // update index
            sendingDataIdx += sendingAmount
            
            // check if there are more data to be sent
            if(sendingDataIdx >= sendingData!.count) {
                sendingEOM = true
                let didSend = peripheralManager!.updateValue("EOM".data(using: .utf8)!, for: characteristic!, onSubscribedCentrals: nil)
                if(didSend) {
                    sendingEOM = false
                    print("Sent EOM")
                }
                return
            }
        }
    }
    
    func peripheralManagerIsReady(toUpdateSubscribers peripheral: CBPeripheralManager) {
        sendData()
    }
    
    func isPeripheralAdvertising() -> Bool {
        return peripheralManager!.isAdvertising
    }
    
    func stopAdvertising() {
        peripheralManager!.stopAdvertising()
    }
    
    func startAdvertising() {
        let advertisingDictionary:NSDictionary = [CBAdvertisementDataServiceUUIDsKey    : [uuid],
                                                  CBAdvertisementDataLocalNameKey       : "UCard"]
        peripheralManager!.startAdvertising(advertisingDictionary as? [String : Any])
    }
    
    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        if((error) != nil) {    
            // error handling
            print("error")
            return
        }
    }
}
