//
//  ViewController.swift
//  LiveTVAppStoreScratch
//
//  Created by Shashwat Singh on 3/9/17.
//  Copyright © 2017 Shashanoid. All rights reserved.
//

import UIKit


class CategoryController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UINavigationBarDelegate{
    
    
    fileprivate let cellId = "cellId"
    fileprivate let largeCellId = "largeCellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(CategoryCell.self, forCellWithReuseIdentifier: "cellId")
        collectionView?.register(LargeCategoryCell.self, forCellWithReuseIdentifier: largeCellId)
        collectionView?.register(FirstLargeCell.self, forCellWithReuseIdentifier: "FirstCellID")
        navigationItem.title = "Card Store"
        
        let height: CGFloat = 75
        let navbar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: height))
        navbar.backgroundColor = UIColor.white
        navbar.delegate = self as! UINavigationBarDelegate
        
        let navItem = UINavigationItem()
        navItem.title = "Card Store"
        navItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(closestore))
        navItem.rightBarButtonItem = UIBarButtonItem(title: "Edit Card", style: .plain, target: self, action: #selector(setname))
        
        navbar.items = [navItem]
        
        view.addSubview(navbar)
        
        collectionView?.frame = CGRect(x: 0, y: height, width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.height - height))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(help))
        
        
    }
    
    func closestore(){
        dismiss(animated: true, completion: nil)
    }

    func setname(){
       // let data = Bundle.main.loadNibNamed("CardListViewController", owner: self, options: nil) as! CardListViewController
        
        
        
    }
    
    func help(){
        
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == 0{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: largeCellId, for: indexPath) as! LargeCategoryCell
            cell.featuredAppsController = self
            return cell
        }
        
        if indexPath.item == 2{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FirstCellID", for: indexPath) as! FirstLargeCell
            cell.featuredAppsController = self
            return cell
        }
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! CategoryCell
        cell.featuredAppsController = self
        
        if indexPath.item == 2 {
            cell.nameLabel.text = "Editor's Choice"
        }
        
        if indexPath.item == 3 {
            cell.nameLabel.text = "Recommended For You"
        }
        
        return cell
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.item == 0{
            return CGSize(width: view.frame.width, height: 160)
        }
        return CGSize(width: view.frame.width, height: 180)
    }
    
    
}






class FirstLargeCell: FirstSectionCell {
    
    private let largeCellId = "LargeAppcellId"
    
    override func setupviews() {
        super.setupviews()
        
        appsCollectionView.register(LargeAppCell.self, forCellWithReuseIdentifier: "LargeAppcellId")
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: largeCellId , for: indexPath) as! CategoryInfoCell
        cell.nameLabel.text = categories?[indexPath.item].name
        cell.priceLabel.text = categories?[indexPath.item].language
        cell.category = categories?[indexPath.item]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if frame.width > 600{
            return CGSize(width: 400, height: frame.height - 7)
            
        }
        return CGSize(width: frame.width - 40, height: frame.height - 7)
    }
    
    class LargeAppCell: CategoryInfoCell{
        override func setupviews() {
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.layer.cornerRadius = 10
            addSubview(imageView)
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":imageView]))
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":imageView]))
            
        }
        
    }
    
}










class LargeCategoryCell: BannerCell {
    
    private let largeCellId = "LargeAppcellId"
    
    override func setupviews() {
        super.setupviews()
        
        appsCollectionView.register(LargeAppCell.self, forCellWithReuseIdentifier: "LargeAppcellId")
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: largeCellId , for: indexPath) as! CategoryInfoCell
        cell.nameLabel.text = categories?[indexPath.item].name
        cell.priceLabel.text = categories?[indexPath.item].language
        cell.category = categories?[indexPath.item]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if frame.width > 600{
            return CGSize(width: 400, height: frame.height - 7)
            
        }
        return CGSize(width: frame.width - 40, height: frame.height - 7)
    }
    
    class LargeAppCell: CategoryInfoCell{
        override func setupviews() {
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.layer.cornerRadius = 10
            addSubview(imageView)
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":imageView]))
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":imageView]))
            
        }
        
    }
    
}






