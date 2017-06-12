//
//  AppCell.swift
//  LiveTVAppStoreScratch
//
//  Created by Shashwat Singh on 3/10/17.
//  Copyright © 2017 Shashanoid. All rights reserved.
//

import UIKit

class CategoryInfoCell: UICollectionViewCell {
    
    var category: Category?{
        didSet{
            
            guard let categoryImageURL = category?.categoryImageURL else {return}
            guard let url = URL(string: categoryImageURL) else {return}
            
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                
                if let err = error{
                    print("Failed to retrieve image", err)
                    return
                }
                
                guard let imageData = data else {return}
                
                let image = UIImage(data: imageData)
                
                DispatchQueue.main.async {
                    self.imageView.image = image
                    
                }
                
                }.resume()
            
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 16
        iv.layer.masksToBounds = true
        
        return iv
    }()
    
    let nameLabel: UILabel = {
        
        let label =  UILabel()
        label.text = "Entertainment"
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 14)
        
        
        return label
        
    }()
    
    let priceLabel: UILabel = {
        
        let label =  UILabel()
        label.text = "English"
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.darkGray
        
        
        return label
        
    }()
    
    
    func setupviews(){
        
        addSubview(imageView)
        addSubview(nameLabel)
        addSubview(priceLabel)
        
        imageView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.width)
        nameLabel.frame = CGRect(x: 0, y: frame.width + 2, width: frame.width, height: 40)
        priceLabel.frame = CGRect(x: 0, y: frame.width + 32, width: frame.width, height: 20)
        
        
    }
}
