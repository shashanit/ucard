//
//  ChannelsCell.swift
//  LiveTVAppStoreScratch
//
//  Created by Shashwat Singh on 3/12/17.
//  Copyright © 2017 Shashanoid. All rights reserved.
//

import UIKit

class ChannelsCell: UITableViewCell {
    
    var channelinfo: Channel?{
        didSet{
            
            channelName.text = channelinfo?.name
            
            guard let categoryImageURL = channelinfo?.channelImage else {return}
            guard let url = URL(string: categoryImageURL) else {return}
            
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                
                if let err = error{
                    print("Failed to retrieve image", err)
                    return
                }
                
                guard let imageData = data else {return}
                
                let image = UIImage(data: imageData)
                
                DispatchQueue.main.async {
                    self.channelImage.image = image
                    
                }
                
                }.resume()
            
            channellanguage.text = channelinfo?.channelLanguage
            livenow.text = channelinfo?.livenow
            
            
            
        }
        
        
    }
    
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupviews()
    }
    
    
    let channelImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 16
        image.layer.masksToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        
        return image
    }()
    
    let channelName: UILabel = {
        let name = UILabel()
        name.font = UIFont.systemFont(ofSize: 18)
        name.textColor = .white
        name.translatesAutoresizingMaskIntoConstraints = false
        
        return name
    }()
    
    let channellanguage: UILabel = {
        let name = UILabel()
        name.font = UIFont.systemFont(ofSize: 12)
        name.translatesAutoresizingMaskIntoConstraints = false
        name.textColor = UIColor.darkGray
        return name
    }()
    
    
    
    let livenow: UILabel = {
        let livenow = UILabel()
        livenow.font = UIFont.systemFont(ofSize: 12)
        livenow.translatesAutoresizingMaskIntoConstraints = false
        livenow.textColor = UIColor.darkGray
        return livenow
    }()
    
    
    func setupviews(){
        
        
        addSubview(channelImage)
        channelImage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        
        channelImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        
        channelImage.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        channelImage.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        
        
        
        addSubview(channelName)
        
        channelName.leftAnchor.constraint(equalTo: channelImage.rightAnchor, constant: 20).isActive = true
        
        channelName.topAnchor.constraint(equalTo: self.topAnchor, constant: 30).isActive = true
        
        channelName.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        
        
        
        addSubview(channellanguage)
        
        channellanguage.leftAnchor.constraint(equalTo: channelImage.rightAnchor, constant: 20).isActive = true
        
        channellanguage.topAnchor.constraint(equalTo: channelName.bottomAnchor, constant: 25).isActive = true
        
        channellanguage.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        
        
        addSubview(livenow)
        livenow.leftAnchor.constraint(equalTo: channelImage.rightAnchor, constant: 20).isActive = true
        
        livenow.topAnchor.constraint(equalTo: channellanguage.bottomAnchor, constant: 0).isActive = true
        
        livenow.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        
        livenow.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        
        
        
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
