//
//  PersonalInfoViewController.swift
//  UCard
//
//  Created by YunSang Lee on 2017. 6. 3..
//  Copyright © 2017년 CITeam44. All rights reserved.
//

import UIKit
import CoreData

class PersonalInfoViewController: UIViewController {
    
    // this is for DB
    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var company: UITextField!
    @IBOutlet weak var addressOne: UITextField!
    @IBOutlet weak var addressTwo: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var emailAddress: UITextField!
    
    var mainViewController: UIViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let context = container?.viewContext {
            let request: NSFetchRequest<PersonalCard> = PersonalCard.fetchRequest()
            do {
                var result = try context.fetch(request)
                if result.count > 0 { // if personal card exist
                    let fullNameArr = result[0].name?.components(separatedBy: " ")
                    firstName.text = fullNameArr?[0]
                    lastName.text = fullNameArr?[1]
                    titleField.text = result[0].titleName
                    company.text = result[0].companyName
                    addressOne.text = result[0].addressOne
                    addressTwo.text = result[0].addressTwo
                    phone.text = result[0].phone
                    emailAddress.text = result[0].email
                }
            } catch {
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func cancelButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButton(_ sender: UIButton) {
        if let context = container?.viewContext {
            let request: NSFetchRequest<PersonalCard> = PersonalCard.fetchRequest()
            do {
                var result = try context.fetch(request)
                if result.count < 1 { // no personal card exist
                    let newCard = PersonalCard(context: context)
                    newCard.name = firstName.text! + " " + lastName.text!
                    newCard.design = defaultDesign
                    newCard.titleName = titleField.text!
                    newCard.companyName = company.text!
                    newCard.addressOne = addressOne.text!
                    newCard.addressTwo = addressTwo.text!
                    newCard.phone = phone.text!
                    newCard.email = emailAddress.text!
                    newCard.uniqueId = UUID().uuidString // this is not guaranteed to be unique, this part need to be enhanced using the server
                } else {
                    result[0].name = firstName.text! + " " + lastName.text!
                    result[0].titleName = titleField.text!
                    result[0].companyName = company.text!
                    result[0].addressOne = addressOne.text!
                    result[0].addressTwo = addressTwo.text!
                    result[0].phone = phone.text!
                    result[0].email = emailAddress.text!
                    //result[0].design = "<?xml version=\"1.0\" encoding=\"utf-8\"?><!-- Generator: Adobe Illustrator 15.1.0, SVG Export Plug-In . SVG Version: 6.00 Build 0)  --><!DOCTYPE svg PUBLIC \"-//W3C//DTD SVG 1.1//EN\" \"http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd\"><svg style=\"position:absolute;height:100%;width:100%;top:0;left:0;\" version=\"1.1\" id=\"Layer_1\" xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\" x=\"0px\" y=\"0px\" width=\"309.379px\" height=\"162.42px\" viewBox=\"0 0 309.379 162.42\" enable-background=\"new 0 0 309.379 162.42\" xml:space=\"preserve\"><g><g><defs><rect id=\"SVGID_1_\" x=\"-1\" y=\"-1.541\" width=\"312.333\" height=\"164.961\"/></defs><clipPath id=\"SVGID_2_\"><use xlink:href=\"#SVGID_1_\"  overflow=\"visible\"/></clipPath><rect x=\"0.037\" y=\"-0.504\" clip-path=\"url(#SVGID_2_)\" fill=\"#5A5F5E\" width=\"310.258\" height=\"162.887\"/></g></g><g><g><defs><rect id=\"SVGID_3_\" x=\"10.045\" y=\"62.934\" width=\"166.754\" height=\"38.592\"/></defs><clipPath id=\"SVGID_4_\"><use xlink:href=\"#SVGID_3_\"  overflow=\"visible\"/></clipPath><g clip-path=\"url(#SVGID_4_)\"><text transform=\"matrix(1 0 0 1 16.1562 83.8867)\" fill=\"#FFFFFF\" font-family=\"'DINAlternate-Bold'\" font-size=\"21.7732\">CompanyPlaceHolder</text></g></g></g><g><g><defs><rect id=\"SVGID_5_\" x=\"149.438\" y=\"3.49\" width=\"157.596\" height=\"154.897\"/></defs><clipPath id=\"SVGID_6_\"><use xlink:href=\"#SVGID_5_\"  overflow=\"visible\"/></clipPath><rect x=\"150.475\" y=\"4.528\" clip-path=\"url(#SVGID_6_)\" fill=\"#3C4552\" width=\"155.523\" height=\"152.823\"/></g></g><g><g><defs><rect id=\"SVGID_7_\" x=\"159.609\" y=\"6.172\" width=\"118.414\" height=\"149.536\"/></defs><clipPath id=\"SVGID_8_\"><use xlink:href=\"#SVGID_7_\"  overflow=\"visible\"/></clipPath><g clip-path=\"url(#SVGID_8_)\"><text transform=\"matrix(1 0 0 1 163.6138 73.0322)\" fill=\"#FFFFFF\" font-family=\"'Helvetica'\" font-size=\"12.4418\">AddressLine1</text></g></g><g><defs><rect id=\"SVGID_9_\" x=\"159.609\" y=\"6.172\" width=\"118.414\" height=\"149.536\"/></defs><clipPath id=\"SVGID_10_\"><use xlink:href=\"#SVGID_9_\"  overflow=\"visible\"/></clipPath><g clip-path=\"url(#SVGID_10_)\"><text transform=\"matrix(1 0 0 1 163.6138 87.7773)\" fill=\"#FFFFFF\" font-family=\"'Helvetica'\" font-size=\"12.4418\">AddressLine2</text></g></g><g><defs><rect id=\"SVGID_11_\" x=\"159.609\" y=\"6.172\" width=\"118.414\" height=\"149.536\"/></defs><clipPath id=\"SVGID_12_\"><use xlink:href=\"#SVGID_11_\"  overflow=\"visible\"/></clipPath><g clip-path=\"url(#SVGID_12_)\"><text transform=\"matrix(1 0 0 1 163.6138 111.2705)\" fill=\"#FFFFFF\" font-family=\"'Helvetica'\" font-size=\"12.4418\">MobilePhone</text></g></g><g><defs><rect id=\"SVGID_13_\" x=\"159.609\" y=\"6.172\" width=\"118.414\" height=\"149.536\"/></defs><clipPath id=\"SVGID_14_\"><use xlink:href=\"#SVGID_13_\"  overflow=\"visible\"/></clipPath><g clip-path=\"url(#SVGID_14_)\"><text transform=\"matrix(1 0 0 1 163.6138 135.4199)\" fill=\"#FFFFFF\" font-family=\"'Helvetica'\" font-size=\"12.4418\">EmailAddress</text></g></g></g><text transform=\"matrix(1 0 0 1 164.1567 31.2207)\" fill=\"#FFFFFF\" font-family=\"'DINAlternate-Bold'\" font-size=\"21.7732\">NamePlaceHolder</text><text transform=\"matrix(1 0 0 1 190.334 46.6191)\" fill=\"#C5C6C6\" font-family=\"'Helvetica'\" font-size=\"12.4418\">TitlePlaceHolder</text>TitlePlaceHolder</text></svg>"
                    if(mainViewController is MainViewController) {
                        let mainViewController = self.mainViewController as! MainViewController
                        mainViewController.personalCardView.name  = result[0].name!
                        mainViewController.personalCardView.title = result[0].titleName!
                        mainViewController.personalCardView.company = result[0].companyName!
                        mainViewController.personalCardView.addressOne = result[0].addressOne!
                        mainViewController.personalCardView.addressTwo = result[0].addressTwo!
                        mainViewController.personalCardView.phone = result[0].phone!
                        mainViewController.personalCardView.email = result[0].email!
                        //mainViewController.personalCardView.design = result[0].design!
                    } else {
                        result[0].design = defaultDesign
                    }
                }
                try? context.save()
            } catch {
            }
        }
        if(mainViewController is MainViewController) {
            let mainViewController = self.mainViewController as! MainViewController
            mainViewController.personalCardView.updateCard()
            self.dismiss(animated: true, completion: nil)
        } else if(mainViewController is TutorialViewController) {
            let mainViewController = self.mainViewController as! TutorialViewController
            mainViewController.finished()
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // default design for new card
    // TODO: this can be moved into separate txt svg instead of being inline
    let defaultDesign = "<?xml version=\"1.0\" encoding=\"utf-8\"?><!-- Generator: Adobe Illustrator 15.1.0, SVG Export Plug-In . SVG Version: 6.00 Build 0)  --><!DOCTYPE svg PUBLIC \"-//W3C//DTD SVG 1.1//EN\" \"http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd\"><svg style=\"position:absolute;height:100%;width:100%;top:0;left:0;\" version=\"1.1\" id=\"Layer_1\" xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\" x=\"0px\" y=\"0px\" width=\"309.379px\" height=\"162.42px\" viewBox=\"0 0 309.379 162.42\" enable-background=\"new 0 0 309.379 162.42\" xml:space=\"preserve\"><g><g><defs><rect id=\"SVGID_1_\" x=\"-1\" y=\"-1.541\" width=\"312.333\" height=\"164.961\"/></defs><clipPath id=\"SVGID_2_\"><use xlink:href=\"#SVGID_1_\"  overflow=\"visible\"/></clipPath><rect x=\"0.037\" y=\"-0.504\" clip-path=\"url(#SVGID_2_)\" fill=\"#5A5F5E\" width=\"310.258\" height=\"162.887\"/></g></g><g><g><defs><rect id=\"SVGID_3_\" x=\"10.045\" y=\"62.934\" width=\"166.754\" height=\"38.592\"/></defs><clipPath id=\"SVGID_4_\"><use xlink:href=\"#SVGID_3_\"  overflow=\"visible\"/></clipPath><g clip-path=\"url(#SVGID_4_)\"><text transform=\"matrix(1 0 0 1 16.1562 83.8867)\" fill=\"#FFFFFF\" font-family=\"'DINAlternate-Bold'\" font-size=\"21.7732\">CompanyPlaceHolder</text></g></g></g><g><g><defs><rect id=\"SVGID_5_\" x=\"149.438\" y=\"3.49\" width=\"157.596\" height=\"154.897\"/></defs><clipPath id=\"SVGID_6_\"><use xlink:href=\"#SVGID_5_\"  overflow=\"visible\"/></clipPath><rect x=\"150.475\" y=\"4.528\" clip-path=\"url(#SVGID_6_)\" fill=\"#3C4552\" width=\"155.523\" height=\"152.823\"/></g></g><g><g><defs><rect id=\"SVGID_7_\" x=\"159.609\" y=\"6.172\" width=\"118.414\" height=\"149.536\"/></defs><clipPath id=\"SVGID_8_\"><use xlink:href=\"#SVGID_7_\"  overflow=\"visible\"/></clipPath><g clip-path=\"url(#SVGID_8_)\"><text transform=\"matrix(1 0 0 1 163.6138 73.0322)\" fill=\"#FFFFFF\" font-family=\"'Helvetica'\" font-size=\"12.4418\">AddressLine1</text></g></g><g><defs><rect id=\"SVGID_9_\" x=\"159.609\" y=\"6.172\" width=\"118.414\" height=\"149.536\"/></defs><clipPath id=\"SVGID_10_\"><use xlink:href=\"#SVGID_9_\"  overflow=\"visible\"/></clipPath><g clip-path=\"url(#SVGID_10_)\"><text transform=\"matrix(1 0 0 1 163.6138 87.7773)\" fill=\"#FFFFFF\" font-family=\"'Helvetica'\" font-size=\"12.4418\">AddressLine2</text></g></g><g><defs><rect id=\"SVGID_11_\" x=\"159.609\" y=\"6.172\" width=\"118.414\" height=\"149.536\"/></defs><clipPath id=\"SVGID_12_\"><use xlink:href=\"#SVGID_11_\"  overflow=\"visible\"/></clipPath><g clip-path=\"url(#SVGID_12_)\"><text transform=\"matrix(1 0 0 1 163.6138 111.2705)\" fill=\"#FFFFFF\" font-family=\"'Helvetica'\" font-size=\"12.4418\">MobilePhone</text></g></g><g><defs><rect id=\"SVGID_13_\" x=\"159.609\" y=\"6.172\" width=\"118.414\" height=\"149.536\"/></defs><clipPath id=\"SVGID_14_\"><use xlink:href=\"#SVGID_13_\"  overflow=\"visible\"/></clipPath><g clip-path=\"url(#SVGID_14_)\"><text transform=\"matrix(1 0 0 1 163.6138 135.4199)\" fill=\"#FFFFFF\" font-family=\"'Helvetica'\" font-size=\"12.4418\">EmailAddress</text></g></g></g><text transform=\"matrix(1 0 0 1 164.1567 31.2207)\" fill=\"#FFFFFF\" font-family=\"'DINAlternate-Bold'\" font-size=\"21.7732\">NamePlaceHolder</text><text transform=\"matrix(1 0 0 1 190.334 46.6191)\" fill=\"#C5C6C6\" font-family=\"'Helvetica'\" font-size=\"12.4418\">TitlePlaceHolder</text>TitlePlaceHolder</text></svg>"

}
