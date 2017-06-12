//
//  CardCell.swift
//  UCard
//
//  Created by YunSang Lee on 2017. 3. 13..
//  Copyright © 2017년 CITeam44. All rights reserved.
//

import UIKit

let iphone67 = 0.9375
let iphone67Plus = 1.035

class CardCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.masksToBounds = false
        layer.shadowRadius = 8
        layer.shadowOffset = CGSize(width: 0, height: -2)
        layer.shadowOpacity = Float(0.5)
        layer.shadowColor = UIColor.black.withAlphaComponent(0.5).cgColor
        backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // rendering new versions of card
    func initCardView(name:String, titleName: String, companyName: String, addressOne: String, addressTwo: String, phone: String, email: String, design: String) {
        let cardView = CardView.init(frame: CGRect(x: 0, y: 0, width: 400*iphone67, height: 210*iphone67))
        cardView.name = name
        cardView.title = titleName
        cardView.company = companyName
        cardView.addressOne = addressOne
        cardView.addressTwo = addressTwo
        cardView.phone = phone
        cardView.email = email
        cardView.design = design
        cardView.updateCard()
        self.addSubview(cardView)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // rendering old versions of card
    func initImage(imageName: String) {
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        
        imageView.frame = CGRect(x: 0, y: 0, width: 400*iphone67, height: 210*iphone67)
        self.addSubview(imageView)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
