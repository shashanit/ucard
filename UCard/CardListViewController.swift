//
//  ViewController.swift
//  UCard
//
//  Created by YunSang Lee on 2017. 3. 9..
//  Copyright © 2017년 CITeam44. All rights reserved.
//

// THIS CODE IS NOT BEING USED!!
// THIS DOCUMENT IS OBSOLETE!!!

import UIKit
import AssetsLibrary

class CardListViewController: UIView, UIGestureRecognizerDelegate, UISearchBarDelegate {
    
    func background(){
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            self.backgroundColor = UIColor.clear
            
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = self.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            self.insertSubview(blurEffectView, at:0)
            
            let backgroundView = UIImageView(image: #imageLiteral(resourceName: "pp2"))
            backgroundView.frame = self.bounds
            backgroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.insertSubview(backgroundView, at:0)
        }
    }
    
    
    
    @IBOutlet weak var cardListView: CardListView!
    
    @IBOutlet weak var personalCardView: UIWebView!
    
    @IBAction func searchButton(_ sender: Any) {
        self.searchSlide()
    }
    
    let navigationstuff = UINavigationController()
    
    enum Status {
        case cardList
        case personalCard
        case search
    }
    
    var status: Status = .cardList
    
    enum GestureType {
        case none
        case showPersonalCard
        case closePersonalCard
        case transmitCard
    }
    
    var gestureType: GestureType = .none
    
    var pangesture:UIPanGestureRecognizer?
    var personalCardTap: UITapGestureRecognizer?
    var originTouchY:CGFloat = 0.0
    func pan(rec:UIPanGestureRecognizer){
        let point = rec.location(in: self)
        let shiftY:CGFloat = point.y - originTouchY
        
        switch rec.state {
        case .began:
            switch status {
            case .cardList:
                gestureType = .showPersonalCard
                originTouchY = point.y
            default:
                if (point.y >= 350) { // dragging on cardListView
                    originTouchY = point.y - cardListView.bounds.height * 0.55
                    gestureType = .closePersonalCard
                } else if(point.y >= 64 && point.y <= 260) {
                    gestureType = .transmitCard
                }
            }
        case .changed:
            switch status {
            case .cardList: // cardList
                cardListView.transform = CGAffineTransform.init(translationX: 0, y: shiftY)
                personalCardView.transform = CGAffineTransform.init(translationX: 0, y: shiftY)
            default: // personalCard
                if(gestureType == .closePersonalCard) {
                    cardListView.transform = CGAffineTransform.init(translationX: 0, y: shiftY)
                    personalCardView.transform = CGAffineTransform.init(translationX: 0, y: shiftY)
                }
            }
            
        default:
            switch status {
            case .cardList: // cardList
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
            default: // personalCard
                if(gestureType == .showPersonalCard) {
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
                }
            }
            
            gestureType = .none
        }
    }
    
    func tap(rec: UITapGestureRecognizer) {
        if(status == .personalCard) {
            let point = rec.location(in: self)
            if (personalCardView.frame.contains(point)) {
                //self.performSegue(withIdentifier: "personalInfoSegue", sender: nil)
            }
        }
    }
    
    @IBAction func OpenStore(_ sender: Any) {

            let layout = UICollectionViewFlowLayout()
            let controlpanel = CategoryController(collectionViewLayout: layout)
        
         self.navigationstuff.present(UIViewController(), animated: true, completion: nil)

    }

 
    open override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        var point = gestureRecognizer.location(in: self)
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
            let searchBarFrame = CGRect(x: 0, y: -44, width: self.bounds.width, height: 44)
            let searchBar = UISearchBar(frame: searchBarFrame)
            searchBar.delegate = self
            searchBar.setShowsCancelButton(true, animated: false)
            if let cancelButton = searchBar.value(forKey: "cancelButton") as? UIButton {
                cancelButton.isEnabled = true
            }
            self.addSubview(searchBar)
            UIView.animate(withDuration: 0.3, delay: 0, options: [],
                           animations: {
                            searchBar.frame = CGRect(x: 0, y: 20, width: self.bounds.width, height: 44)
            }, 
                           completion: nil
            )
            status = .search
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // for gesture
        if pangesture == nil {
            pangesture = UIPanGestureRecognizer(target: self,action: #selector(CardListViewController.pan(rec:)))
            pangesture!.delegate = self
            self.addGestureRecognizer(pangesture!)
        }
        if personalCardTap == nil {
            personalCardTap = UITapGestureRecognizer(target: self,action: #selector(CardListViewController.tap(rec:)))
            personalCardTap!.delegate = self
            self.addGestureRecognizer(personalCardTap!)
        }
        
        background();
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchText = searchBar.text as String!
        print("searchText \(searchText!)")
        self.cardListView.search(with: searchText!)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        UIView.animate(withDuration: 0.3, delay: 0, options: [],
                       animations: {
                        searchBar.frame = CGRect(x: 0, y: -44, width: self.bounds.width, height: 44)
        },
                       completion: { _ in
                        searchBar.removeFromSuperview()
                        self.status = .cardList
        }
        )
    }
}

