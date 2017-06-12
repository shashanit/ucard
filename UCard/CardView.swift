//
//  CardView.swift
//  UCard
//
//  Created by YunSang Lee on 2017. 5. 29..
//  Copyright © 2017년 CITeam44. All rights reserved.
//

import UIKit

class CardView: UIWebView {
    // some one the value can be invisible
    // so that it is fine to be blank
    var name = ""
    var title = ""
    var company = ""
    var addressOne = ""
    var addressTwo = ""
    var phone = ""
    var email = ""
    var design = ""
    var uniqueId = ""
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.scrollView.bounces = false
        self.scrollView.isScrollEnabled = false
        self.scalesPageToFit = false
        self.dataDetectorTypes = .init(rawValue: 0) // none
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.scrollView.bounces = false
        self.scrollView.isScrollEnabled = false
        self.scalesPageToFit = false
        self.dataDetectorTypes = .init(rawValue: 0) // none
        self.backgroundColor = UIColor.clear
    }
    
    func updateCard() {
        // change attributes to given design
        var design = self.design
        design = design.replacingOccurrences(of: "NamePlaceHolder", with: self.name);
        design = design.replacingOccurrences(of: "TitlePlaceHolder", with: self.title);
        design = design.replacingOccurrences(of: "CompanyPlaceHolder", with: self.company);
        design = design.replacingOccurrences(of: "AddressLine1", with: self.addressOne);
        design = design.replacingOccurrences(of: "AddressLine2", with: self.addressTwo);
        design = design.replacingOccurrences(of: "MobilePhone", with: self.phone);
        design = design.replacingOccurrences(of: "EmailAddress", with: self.email);
        // redraw svg image
        self.loadHTMLString(design, baseURL: nil);
        self.scalesPageToFit = false
        self.isUserInteractionEnabled = false
        
        //self.contentMode = .scaleAspectFill
    }
}
