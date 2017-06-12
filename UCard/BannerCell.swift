//
//  CategoryCell.swift
//  LiveTVAppStoreScratch
//
//  Created by Shashwat Singh on 3/9/17.
//  Copyright © 2017 Shashanoid. All rights reserved.
//

import UIKit

class BannerCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    var categories: [Category]?
    var featuredAppsController: CategoryController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupviews()
        setupchannels()
        
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let nameLabel: UILabel = {
        let label =  UILabel()
        label.text = "Categories"
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        
        
        return label
        
        
        
    }()
    
    let appsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .white
        
        
        
        return collectionView
    }()
    
    
    
    func setupviews(){
        
        addSubview(appsCollectionView)
        
        appsCollectionView.dataSource = self
        appsCollectionView.delegate = self
        
        appsCollectionView.register(CategoryInfoCell.self, forCellWithReuseIdentifier: "cellId")
        
        
        //   addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":nameLabel]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":appsCollectionView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":appsCollectionView]))
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = categories?.count{
            return count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! CategoryInfoCell
        cell.nameLabel.text = categories?[indexPath.item].name
        cell.priceLabel.text = categories?[indexPath.item].language
        cell.category = categories?[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 160)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 7, left: 5, bottom: 0, right: 7)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        let imageurl = categories?[indexPath.item].categoryImageURL
        print(imageurl)
        
        
        
        
    
        
    }
    
    
    func setupchannels(){
        
        guard let url = URL(string: "https://api.myjson.com/bins/620c1") else {return}
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if error != nil{
                print(error as Any)
                return
            }
            
            
            guard let processdata = data else {return}
            
            do{
                let json = try(JSONSerialization.jsonObject(with: processdata, options: .mutableContainers))
                guard let dictionaries = json as? [[String:Any]] else {return}
                
                self.categories = []
                for dictionary in dictionaries{
                    let category = Category(dictionary: dictionary)
                    self.categories?.append(category)
                    
                    
                    
                }
                
                
                DispatchQueue.main.async {
                    self.appsCollectionView.reloadData()
                }
                
                
            }catch{
                //print error
            }
            
            
            }.resume()
        
    }
    
    
    
    
}




