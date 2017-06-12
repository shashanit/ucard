//
//  Models.swift
//  LiveTVAppStoreScratch
//
//  Created by Shashwat Singh on 3/10/17.
//  Copyright © 2017 Shashanoid. All rights reserved.
//

import UIKit

class Category: NSObject{
    
    let name: String
    let image: UIImage
    let language: String
    let channels: [Channel]
    let categoryImageURL: String
    
    init(name: String, image: UIImage, language: String, channels: [Channel]) {
        self.name = name
        self.image = image
        self.language = language
        self.channels = channels
        self.categoryImageURL = ""
    }
    
    init(dictionary: [String:Any]) {
        self.name = dictionary["name"] as? String ?? ""
        self.image = #imageLiteral(resourceName: "sample1.png")
        self.language = dictionary["language"] as? String ?? ""
        self.categoryImageURL = dictionary["categoryImageURL"] as? String ?? ""
        
        var channels = [Channel]()
        
        if let channelinfo = dictionary["channels"] as? [[String: Any]]{
            for channel in channelinfo{
                if let channelName = channel["channelName"] as? String{
                    if let channelImage = channel["channelImageURL"] as? String{
                        if let channelurl = channel["channelLink"] as? String{
                            if let channelLanguage = channel["language"] as? String{
                                if let livenow = channel["livenow"] as? String{
                                    if let nowplaying = channel["nowplaying"] as? String{
                                        if let upnext = channel["upnext"] as? String{
                                            if let later = channel["later"] as? String{
                                                let channel = Channel(name: channelName, channelImage: channelImage, channelUrl: channelurl, channelLanguage: channelLanguage, livenow: livenow, nowplaying: nowplaying, upnext: upnext, later: later )
                                                channels.append(channel)
                                            }
                                        }
                                    }
                                }
                            }
                            
                        }
                    }
                }
            }
            
        }
        self.channels = channels
        
        
        
        
    }
    
}


class Channel{
    
    
    let name: String
    let channelImage: String
    let channelUrl: String
    let channelLanguage: String
    let livenow: String
    let nowplaying: String
    let upnext: String
    let later: String
    
    init(name: String, channelImage: String, channelUrl: String, channelLanguage: String, livenow: String, nowplaying: String, upnext: String, later: String) {
        self.name = name
        self.channelImage = channelImage
        self.channelUrl = channelUrl
        self.channelLanguage = channelLanguage
        self.livenow = livenow
        self.nowplaying = nowplaying
        self.upnext = upnext
        self.later = later
    }
    
    
}





