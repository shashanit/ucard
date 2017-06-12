//
//  CardListView.swift
//  UCard
//
//  Created by YunSang Lee on 2017. 3. 9..
//  Copyright © 2017년 CITeam44. All rights reserved.
//

import UIKit
import CoreData

public protocol CardListViewDataSource: class {
    //func cardAtIndex() -> Card
}

class CardListView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UIViewControllerTransitioningDelegate {
    
    // public weak var datasource:CardListViewDataSource
    
    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    private var cards = [Card]() {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    lazy var collectionView:UICollectionView = {
        let layout = CardLayout()
        let view = UICollectionView.init(frame: self.frame, collectionViewLayout: layout)
        view.delegate = self
        view.dataSource = self
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        // setup cell
        view.register(CardCell.self, forCellWithReuseIdentifier: "CardCell")
        view.alwaysBounceVertical = true
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // setup collectionView
        self.addSubview(collectionView)
        self.translatesAutoresizingMaskIntoConstraints = false
        let left = NSLayoutConstraint.init(item: collectionView, attribute: .left, relatedBy: .equal, toItem: collectionView.superview!, attribute: .left, multiplier: 1.0, constant: 0.0)
        let right = NSLayoutConstraint.init(item: collectionView, attribute: .right, relatedBy: .equal, toItem: collectionView.superview!, attribute: .right, multiplier: 1.0, constant: 0.0)
        let top = NSLayoutConstraint.init(item: collectionView, attribute: .top, relatedBy: .equal, toItem: collectionView.superview!, attribute: .top, multiplier: 1.0, constant: 0.0)
        let bottom = NSLayoutConstraint.init(item: collectionView, attribute: .bottom, relatedBy: .equal, toItem: collectionView.superview!, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        self.addConstraints([left,right,top,bottom])
        
        
        if let custom = self.collectionView.collectionViewLayout as? CardLayout {
            //custom.showStyle = .normal
        }
        getCardList()
        
        self.backgroundColor = UIColor.clear
        
        
        
        
        // test code for database
        // this is BAD!!!
        // TODO: make debuging exception for the testing code
        /*
         print("Test begins in 3 seconds...")
         sleep(3);
         print("\nDeleting all data...")
         DBTDeleteAll()
         sleep(1);
         print("\nInserting dummy data...")
         DBTAddCards(withAmount: 20)
         sleep(1);
         print("\nSearching with string: Nathan...")
         DBTSearchCards(withString: "Nathan")
         sleep(1);
         print("\nSearching with string: Vid...")
         DBTSearchCards(withString: "Vid")
         sleep(1);
         print("\nSearching with string: ar...")
         DBTSearchCards(withString: "ar")
         sleep(1);
         print("\nTest done!")
         sleep(1);
         cards = []
         getCardList()
         */
        
        
        // generate random cards
        /*
         var arr = [AnyObject]()
         arr.append("sample3" as AnyObject)
         arr.append("sample2" as AnyObject)
         arr.append("sample1" as AnyObject)
         arr.append("sample4" as AnyObject)
         var last = 4;
         for i in stride(from: 0, through: 20, by: 1) {
         var random: Int
         repeat {
         random = Int(arc4random_uniform(4)) + 1
         } while(last == random)
         last = random
         arr.append("sample\(random)" as AnyObject)
         }
         cards += arr
         */
        //self.collectionView.reloadData()
    }
    
    public func addCard(name: String, titleName: String, companyName: String, phone: String, email: String, addressOne: String, addressTwo: String, design: String) {
        if let context = container?.viewContext {
            let newCard = Card(context: context)
            newCard.name = name
            newCard.titleName = titleName
            newCard.companyName = companyName
            newCard.phone = phone
            newCard.email = email
            newCard.addressOne = addressOne
            newCard.addressTwo = addressTwo
            newCard.design = design
            try? context.save()
            getCardList()
        }
    }

    func getCardList() {
        if let context = container?.viewContext {
            // running in main thread. may need to be moved to saperate thread
            let request: NSFetchRequest<Card> = Card.fetchRequest()
            //request.predicate = NSPredicate(format:)
            
            do {
                var result = try context.fetch(request)
                if result.count < 1 {
                    // there is no card
                } else {
                    cards = result
                }
            } catch {
            }
        }
    }
    
    func search(with str:String) {
        if(str == "") {
            getCardList()
        } else {
            if let context = container?.viewContext {
                let request: NSFetchRequest<Card> = Card.fetchRequest()
                request.predicate = NSPredicate(format: "(any name contains[c] %@) OR (any titleName contains[c] %@) OR (any phone contains[c] %@) OR (any email contains[c] %@) OR (any addressOne contains[c] %@) OR (any addressTwo contains[c] %@) OR (any companyName contains[c] %@)", str, str, str, str, str, str, str)
                
                do {
                    let result = try context.fetch(request)
                    cards = result
                } catch {
                }
            }
        }
    }
    
    //------------------------------------------------------------------------------------------------------------------------------------
    // DB Test
    //------------------------------------------------------------------------------------------------------------------------------------
    
    struct DummyCard {
        var name: String = ""
        var design: String = ""
        var title: String = ""
        var addressOne: String = ""
        var addressTwo: String = ""
        var phone: String = ""
        var email: String = ""
        var company: String = ""
    }
    
    lazy var sampleCards: [DummyCard] = {
        var returnArr: [DummyCard] = []
        returnArr.append(DummyCard())
        returnArr[0].name = "Gordon Freeman"
        returnArr[0].design = "sample1"
        returnArr[0].title = "Doctor"
        returnArr[0].addressOne = "P.O. Box 3985"
        returnArr[0].addressTwo = "Black Mesa Drive, NM 87545"
        returnArr[0].phone = "1(800)786-1410"
        returnArr[0].email = "gfreeman@bmrf.us"
        returnArr[0].company = "Black Mesa"
        returnArr.append(DummyCard())
        returnArr[1].name = "Warren Vidic"
        returnArr[1].design = "sample2"
        returnArr[1].title = "Head of the Genetic Memory Research and the Animus Project"
        returnArr[1].addressOne = ""
        returnArr[1].addressTwo = ""
        returnArr[1].phone = ""
        returnArr[1].email = "wvidic@abstergo.com"
        returnArr[1].company = "Abstergo Industries"
        returnArr.append(DummyCard())
        returnArr[2].name = "Nathan Drake"
        returnArr[2].design = "sample3"
        returnArr[2].title = ""
        returnArr[2].addressOne = "160 Guard Ave, Apt.3, Key West, Florida"
        returnArr[2].addressTwo = ""
        returnArr[2].phone = "786-078-1332"
        returnArr[2].email = ""
        returnArr[2].company = ""
        returnArr.append(DummyCard())
        returnArr[3].name = "Baron von Fancy"
        returnArr[3].design = "sample4"
        returnArr[2].title = "Collection Of Models"
        returnArr[2].addressOne = "453 Granville Lane, Green Bank, NJ 07701"
        returnArr[2].addressTwo = ""
        returnArr[2].phone = "973-525-0130"
        returnArr[2].email = "keith@baronvonfancy.com"
        returnArr[2].company = "AttDesign"
        returnArr.append(DummyCard())
        returnArr[4].name = "EcoTime"
        returnArr[4].design = "sample5"
        returnArr[2].title = ""
        returnArr[2].addressOne = "453 Granville Lane, Green Bank, NJ 07701"
        returnArr[2].addressTwo = ""
        returnArr[2].phone = "973-525-0130"
        returnArr[2].email = "ecotime@vveco.com"
        returnArr[2].company = "Eco-production"
        returnArr.append(DummyCard())
        returnArr[5].name = "YunSang Lee"
        returnArr[5].design = "sample6"
        return returnArr
    }()
    
    func DBTDeleteAll() {
        if let context = container?.viewContext {
            do {
                let request = NSBatchDeleteRequest(fetchRequest: Card.fetchRequest())
                try context.execute(request)
                cards = []
                print("Data deleted")
            } catch {
                print("error")
            }
        }
    }
    
    func DBTAddCards(withAmount amount:Int) {
        if let context = container?.viewContext {
            do {
                for i in stride(from: 0, through: amount - 1, by: 1) {
                    let newCard = Card(context: context)
                    newCard.name = sampleCards[i%6].name
                    newCard.design = sampleCards[i%6].design
                    newCard.titleName = sampleCards[i%6].title
                    newCard.addressOne = sampleCards[i%6].addressOne
                    newCard.addressTwo = sampleCards[i%6].addressTwo
                    newCard.phone = sampleCards[i%6].phone
                    newCard.email = sampleCards[i%6].email
                    newCard.companyName = sampleCards[i%6].company
                    
                    cards.append(newCard)
                    print("New Card added: (name: " + newCard.name! + ", design: " + newCard.design!)
                    collectionView.reloadData()
                }
                try? context.save()
            } catch {
                print("error")
            }
        }
    }
    
    func DBTSearchCards(withString str:String) {
        if let context = container?.viewContext {
            let request: NSFetchRequest<Card> = Card.fetchRequest()
            request.predicate = NSPredicate(format: "any name contains[c] %@", str)
            
            do {
                let result = try context.fetch(request)
                cards = result
                for i in stride(from: 0, through: result.count - 1, by: 1) {
                    print("Card\(i)(name: " + cards[i].name! + ", design: " + cards[i].design!)
                }
            } catch {
            }
        }
    }
    
    // ------------------------------------------------------------------------------------------------------------------------------------
    // collectionView delegate
    //-------------------------------------------------------------------------------------------------------------------------------------
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let card = collectionView.collectionViewLayout as? CardLayout {
            card.selected = indexPath.row
        }
    }
    
    /*
     func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
     let width = self.frame.size.width//some width
     let height: CGFloat = 300 //ratio
     return CGSize(width: width, height: height);
     } */
    
    // datasource
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = { () -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell" , for: indexPath )
            // cell.label.text = "Hello Text"
            cell.backgroundColor = UIColor.green
            if let cell = cell as? CardCell {
                // check the version of the card
                let isOld = (cards[indexPath.row].design!.characters.count < 20)
                if(isOld) {
                    cell.initImage(imageName: cards[indexPath.row].design!)
                } else {
                    cell.initCardView(name:cards[indexPath.row].name!, titleName:cards[indexPath.row].titleName!, companyName:cards[indexPath.row].companyName!, addressOne:cards[indexPath.row].addressOne!, addressTwo:cards[indexPath.row].addressTwo!, phone:cards[indexPath.row].phone!, email:cards[indexPath.row].email!, design:cards[indexPath.row].design!)
                }
            }
            return cell
            }() as? CardCell else {
                return UICollectionViewCell()
        }
        
        return cell
    }
    
}
