//
//  CategoryCell.swift
//  LiveTVAppStoreScratch
//
//  Created by Shashwat Singh on 3/9/17.
//  Copyright © 2017 Shashanoid. All rights reserved.
//

import UIKit

class CategoryCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
{
    
    
    
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
        label.text = "Free Cards"
        label.textColor = .black
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16.0)
        
        
        return label
        
        
        
    }()
    
    let appsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.bounces = false
        collectionView.backgroundColor = .black
        
        
        return collectionView
    }()
    
    
    
    
    
    func setupviews(){
        
        
        
        addSubview(appsCollectionView)
        addSubview(nameLabel)
        
        
        
        
        appsCollectionView.dataSource = self
        appsCollectionView.delegate = self
        
        
        
        appsCollectionView.register(testcell.self, forCellWithReuseIdentifier: "cellId")
        
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-14-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":nameLabel]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":appsCollectionView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[namelabel(30)][v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["namelabel":nameLabel, "v0":appsCollectionView]))
        
    }
    
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! testcell
        //        if indexPath.item == 6 {
        //            cell.imageView.image = #imageLiteral(resourceName: "sample1")
        //        }
        cell.backgroundColor = .red
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //        if indexPath.item == 6 {
        //            return CGSize(width: frame.width, height: 200)
        //
        //        }
        return CGSize(width: 170, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 10, bottom: 0, right: 14)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("Item selected")
        
    }
    
    
    
    
    func setupchannels(){
        
        guard let url = URL(string: "https://iphoneapp.livemobiletv247.com/release/banner.php") else {return}
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




