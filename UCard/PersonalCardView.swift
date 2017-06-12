//
//  PersonalCardView.swift
//  UCard
//
//  Created by YunSang Lee on 2017. 5. 29..
//  Copyright © 2017년 CITeam44. All rights reserved.
//

import UIKit
import CoreData
class PersonalCardView: CardView {
    
    // this is for DB
    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    var personalCard: PersonalCard?
    
    var numberOfCards = 0

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        loadPersonalCard();
    }
    
    func loadPersonalCard() {
        if let context = container?.viewContext {
            // running in main thread. may need to be moved to saperate thread
            let request: NSFetchRequest<PersonalCard> = PersonalCard.fetchRequest()
            //request.predicate = NSPredicate(format:)
            
            /*
            if let context = container?.viewContext {
                do {
                    let request = NSBatchDeleteRequest(fetchRequest: PersonalCard.fetchRequest())
                    try context.execute(request)
                    print("Data deleted")
                } catch {
                    print("error")
                }
            }
 */
            
            do {
                var result = try context.fetch(request)
                if result.count < 1 { // no personal card exist
                } else {
                    numberOfCards = 1
                    personalCard = result[0]
                    self.name = personalCard!.name!
                    self.design = personalCard!.design!
                    self.title = personalCard!.titleName!
                    self.company = personalCard!.companyName!
                    self.addressOne = personalCard!.addressOne!
                    self.addressTwo = personalCard!.addressTwo!
                    self.phone = personalCard!.phone!
                    self.email = personalCard!.email!
                    self.uniqueId = personalCard!.uniqueId!
                    self.updateCard()
                }
            } catch {
            }
        }
    }
    
    func getPersonalCard() -> PersonalCard? {
        if let context = container?.viewContext {
            // running in main thread. may need to be moved to saperate thread
            let request: NSFetchRequest<PersonalCard> = PersonalCard.fetchRequest()
            //request.predicate = NSPredicate(format:)
            
            /*
             if let context = container?.viewContext {
             do {
             let request = NSBatchDeleteRequest(fetchRequest: PersonalCard.fetchRequest())
             try context.execute(request)
             print("Data deleted")
             } catch {
             print("error")
             }
             }
             */
            
            do {
                var result = try context.fetch(request)
                if result.count < 1 { // no personal card exist
                } else {
                    return result[0]
                }
            } catch {
            }
        }
        return nil
    }
}
