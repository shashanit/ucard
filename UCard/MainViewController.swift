//
//  MainViewController.swift
//  UCard
//
//  Created by YunSang Lee on 2017. 6. 3..
//  Copyright © 2017년 CITeam44. All rights reserved.
//

import UIKit
import AssetsLibrary

class MainViewController: UIViewController, UIGestureRecognizerDelegate, UISearchBarDelegate, BLEFinderDelegate {
    
    enum Status {
        case cardList
        case personalCard
        case cardTrasnmited
        case cardReceived
        case search
    }
    
    var status:Status = .cardList
    
    enum GestureType {
        case none
        case showPersonalCard
        case closePersonalCard
        case transmitCard
        case cancelTransmit
        case takeReceivedCard
    }
    
    var gestureType: GestureType = .none
    var pangesture:UIPanGestureRecognizer?
    var personalCardTap: UITapGestureRecognizer?
    var originTouchY:CGFloat = 0.0
    var bleFinder:BLEFinder?
    var bleAdvertiser:BLEAdvertiser?

    @IBOutlet weak var cardListView: CardListView!
    @IBOutlet weak var personalCardView: PersonalCardView!
    @IBAction func searchButton(_ sender: UIButton) {
        searchSlide()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // for gesture
        if pangesture == nil {
            pangesture = UIPanGestureRecognizer(target: self,action: #selector(MainViewController.pan(rec:)))
            pangesture!.delegate = self
            self.view.addGestureRecognizer(pangesture!)
        }
        if personalCardTap == nil {
            personalCardTap = UITapGestureRecognizer(target: self,action: #selector(MainViewController.tap(rec:)))
            personalCardTap!.delegate = self
            self.view.addGestureRecognizer(personalCardTap!)
        }
        
        background();
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if(personalCardView.numberOfCards == 0) {
            // There is no personal card, probably first time using the app
            self.performSegue(withIdentifier: "tutorialSegue", sender: nil)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func background(){
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            self.view.backgroundColor = UIColor.clear
            
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = self.view.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            self.view.insertSubview(blurEffectView, at:0)
            
            let backgroundView = UIImageView(image: #imageLiteral(resourceName: "pp2"))
            backgroundView.frame = self.view.bounds
            backgroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.view.insertSubview(backgroundView, at:0)
        }
    }
    
    // gesture
    func pan(rec:UIPanGestureRecognizer){
        let point = rec.location(in: self.view)
        let shiftY:CGFloat = point.y - originTouchY
        
        switch rec.state {
        case .began:
            switch status {
            case .cardList:
                gestureType = .showPersonalCard
                originTouchY = point.y
            case .personalCard:
                if (point.y >= 350) { // dragging on cardListView
                    originTouchY = point.y - cardListView.bounds.height * 0.55
                    gestureType = .closePersonalCard
                } else if(point.y >= 64 && point.y <= 260) { // dragging on personalCardView
                    gestureType = .transmitCard
                    originTouchY = point.y
                }
            case .cardTrasnmited:
                if !(point.y >= 350) { // dragging on cardListView
                    originTouchY = point.y
                    gestureType = .cancelTransmit
                }
            case .cardReceived:
                if(point.y >= 64 && point.y <= 260) { // dragging on personalCardView
                    gestureType = .takeReceivedCard
                    originTouchY = point.y
                }
            default: break
            }
        case .changed:
            switch gestureType {
            case .showPersonalCard: // cardList
                cardListView.transform = CGAffineTransform.init(translationX: 0, y: shiftY)
                personalCardView.transform = CGAffineTransform.init(translationX: 0, y: shiftY)
            case .closePersonalCard: // personalCard
                cardListView.transform = CGAffineTransform.init(translationX: 0, y: shiftY)
                personalCardView.transform = CGAffineTransform.init(translationX: 0, y: shiftY)
            case .transmitCard:
                personalCardView.transform = CGAffineTransform.init(translationX: 0, y: shiftY + cardListView.bounds.height * 0.55)
            case .cancelTransmit:
                personalCardView.transform = CGAffineTransform.init(translationX: 0, y: sqrt(shiftY)*25)
            case .takeReceivedCard:
                personalCardView.transform = CGAffineTransform.init(translationX: 0, y: shiftY + cardListView.bounds.height * 0.55)
            default: break
            }
            
        default:
            switch gestureType {
            case .showPersonalCard: // cardList
                let activePersonalCard = (shiftY > personalCardView.frame.height/3) ? true : false
                let newY = (activePersonalCard) ? cardListView.bounds.height * 0.55 : 0
                
                UIView.animate(withDuration: 0.3, animations: {
                    self.cardListView.layer.transform = CATransform3DMakeTranslation(0, newY, 0)
                    self.personalCardView.layer.transform = CATransform3DMakeTranslation(0, newY, 0)
                }, completion: nil)
                
                if(activePersonalCard) {
                    cardListView.isUserInteractionEnabled = false
                    status = .personalCard
                }
            case .closePersonalCard: // personalCard
                let deactivePersonalCard = (shiftY > personalCardView.frame.height*5/6) ? false : true
                let newY = (deactivePersonalCard) ?  0 : cardListView.bounds.height * 0.55
                
                if(deactivePersonalCard) {
                    cardListView.isUserInteractionEnabled = true
                    status = .cardList
                    UIView.animate(withDuration: 0.3, animations: {
                        self.cardListView.layer.transform = CATransform3DMakeTranslation(0, 0, 0)
                        self.personalCardView.layer.transform = CATransform3DMakeTranslation(0, -270, 0)
                    }, completion: nil)
                } else {
                    UIView.animate(withDuration: 0.3, animations: {
                        self.cardListView.layer.transform = CATransform3DMakeTranslation(0, newY, 0)
                        self.personalCardView.layer.transform = CATransform3DMakeTranslation(0, newY, 0)
                    }, completion: nil)
                }
            case .transmitCard:
                let transmitPersonalCard = ((-1 * shiftY) > personalCardView.frame.height*2/3) ? true : false
                if(transmitPersonalCard) {
                    UIView.animate(withDuration: 0.3, animations: {
                        self.personalCardView.layer.transform = CATransform3DMakeTranslation(0, -270, 0)
                    }, completion: nil)
                    status = .cardTrasnmited
                    bleFinder = BLEFinder()
                    bleFinder?.uniqueID = personalCardView.uniqueId
                    bleFinder?.delegate = self
                    bleAdvertiser = BLEAdvertiser()
                    bleAdvertiser?.uniqueID = personalCardView.uniqueId
                    bleAdvertiser?.personalCard = personalCardView.getPersonalCard()!
                    
                } else {
                    UIView.animate(withDuration: 0.3, animations: {
                        self.personalCardView.layer.transform = CATransform3DMakeTranslation(0, self.cardListView.bounds.height * 0.55, 0)
                    }, completion: nil)
                }
            case .cancelTransmit:
                let cancelTransmit = (shiftY > personalCardView.frame.height*1/3) ? true : false
                if(cancelTransmit) {
                    UIView.animate(withDuration: 0.3, animations: {
                        self.personalCardView.layer.transform = CATransform3DMakeTranslation(0, self.cardListView.bounds.height * 0.55, 0)
                    }, completion: nil)
                    status = .personalCard
                    if(bleFinder != nil) {
                        bleFinder!.cleanUp()
                        bleFinder!.centralManager!.stopScan()
                        bleFinder = nil
                    }
                    if(bleAdvertiser != nil) {
                        bleAdvertiser!.stopAdvertising()
                        bleAdvertiser = nil
                    }
                } else {
                    UIView.animate(withDuration: 0.3, animations: {
                        self.personalCardView.layer.transform = CATransform3DMakeTranslation(0, -270, 0)
                    }, completion: nil)
                }
            case .takeReceivedCard:
                let rejectCard = ((-1 * shiftY) > personalCardView.frame.height*2/3) ? true : false
                let receiveCard = (shiftY > personalCardView.frame.height*1/3) ? true : false
                if(rejectCard) {
                    UIView.animate(withDuration: 0.3, animations: {
                        self.personalCardView.layer.transform = CATransform3DMakeTranslation(0, -270, 0)
                    }, completion: nil)
                    // get ready for next try
                    bleFinder = nil
                    bleAdvertiser = nil
                    status = .cardTrasnmited
                    bleFinder = BLEFinder()
                    bleFinder?.uniqueID = personalCardView.uniqueId
                    bleFinder?.delegate = self
                    bleAdvertiser = BLEAdvertiser()
                    bleAdvertiser?.uniqueID = personalCardView.uniqueId
                    bleAdvertiser?.personalCard = personalCardView.getPersonalCard()!
                    status = .cardTrasnmited
                } else if(receiveCard) {
                    UIView.animate(withDuration: 0.3, animations: {
                        self.personalCardView.layer.transform = CATransform3DMakeTranslation(0, 700, 0)
                    }, completion: { finished in
                        UIView.animate(withDuration: 0.3, animations: {
                            self.cardListView.layer.transform = CATransform3DMakeTranslation(0, 0, 0)
                        }, completion: nil)
                        self.personalCardView.layer.transform = CATransform3DMakeTranslation(0, -270, 0)
                        self.personalCardView.loadPersonalCard()
                        self.status = .cardList
                        self.cardListView.isUserInteractionEnabled = true
                    })
                    
                    cardListView.addCard(name: personalCardView.name, titleName: personalCardView.title, companyName: personalCardView.company, phone: personalCardView.phone, email: personalCardView.email, addressOne: personalCardView.addressOne, addressTwo: personalCardView.addressTwo, design: personalCardView.design)
                } else {
                    UIView.animate(withDuration: 0.3, animations: {
                        self.personalCardView.layer.transform = CATransform3DMakeTranslation(0, self.cardListView.bounds.height * 0.55, 0)
                    }, completion: nil)
                }
            default: break
            }
            
            gestureType = .none
        }
    }
    
    func tap(rec: UITapGestureRecognizer) {
        if(status == .personalCard) {
            let point = rec.location(in: self.view)
            if (personalCardView.frame.contains(point)) {
                self.performSegue(withIdentifier: "personalInfoSegue", sender: nil)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is PersonalInfoViewController {
            let destination = segue.destination as! PersonalInfoViewController
            destination.mainViewController = self
        } else if segue.destination is TutorialViewController {
            let destination = segue.destination as! TutorialViewController
            destination.mainViewController = self
        }
    }
    
    open func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let point = gestureRecognizer.location(in: self.view)
        print("x: \(point.x)\t\ty: \(point.y)\n");
        
        switch status {
        case .cardList:
            if (point.y > 20 && point.y < 80) && status == .cardList { // dragging on top margin
                return true
            }
        default:
            return true
        }
        return false
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
    func searchSlide() {
        if(status == .cardList) {
            let searchBarFrame = CGRect(x: 0, y: -44, width: self.view.bounds.width, height: 44)
            let searchBar = UISearchBar(frame: searchBarFrame)
            searchBar.delegate = self
            searchBar.setShowsCancelButton(true, animated: false)
            if let cancelButton = searchBar.value(forKey: "cancelButton") as? UIButton {
                cancelButton.isEnabled = true
            }
            self.view.addSubview(searchBar)
            UIView.animate(withDuration: 0.3, delay: 0, options: [],
                           animations: {
                            searchBar.frame = CGRect(x: 0, y: 20, width: self.view.bounds.width, height: 44)
            },
                           completion: nil
            )
            status = .search
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchText = searchBar.text as String!
        print("searchText \(searchText!)")
        self.cardListView.search(with: searchText!)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        UIView.animate(withDuration: 0.3, delay: 0, options: [],
                       animations: {
                        searchBar.frame = CGRect(x: 0, y: -44, width: self.view.bounds.width, height: 44)
        },
                       completion: { _ in
                        searchBar.removeFromSuperview()
                        self.status = .cardList
        }
        )
    }
    
    func BLEFinderFoundClosest(key: String) {
        bleAdvertiser?.targetPeripheralID = key
    }
    
    func BLEFinderVerifiedCurrentCentral() {
        bleAdvertiser?.centralIsVerified = true
    }
    
    func BLEFinderHasReceivedCard(name: String, titleName: String, companyName: String, phone: String, email: String, addressOne: String, addressTwo: String, design: String) {
        personalCardView.name = name
        personalCardView.title = titleName
        personalCardView.company = companyName
        personalCardView.phone = phone
        personalCardView.email = email
        personalCardView.addressOne = addressOne
        personalCardView.addressTwo = addressTwo
        personalCardView.design = design
        personalCardView.updateCard()
        status = .cardReceived
        UIView.animate(withDuration: 0.3, animations: {
            self.personalCardView.layer.transform = CATransform3DMakeTranslation(0, self.cardListView.bounds.height * 0.55, 0)
        }, completion: nil)
    }
}
