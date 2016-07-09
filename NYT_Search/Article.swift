//
//  Article.swift
//  NYT_Search
//
//  Created by Serge Sukhanov on 09.07.16.
//  Copyright © 2016 Serge Sukhanov. All rights reserved.
//

import Foundation
import UIKit

class Article {
    var name: String
    var date: String
    var link: String
    var image: UIImage?
    
    init(jsonDictionary: [String : AnyObject]) {
        self.name = jsonDictionary["keyForName"] as! String
        self.date = jsonDictionary["keyForDate"] as! String
        self.link = jsonDictionary["keyForLink"] as! String
        
        guard let imageURL = NSURL(string: jsonDictionary["keyForImage"] as! String),
            let imageData = NSData(contentsOfURL: imageURL) else {
                return
        }
        self.image = UIImage(data: imageData)
    }
}
