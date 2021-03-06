//
//  Article.swift
//  NYT_Search
//
//  Created by Serge Sukhanov on 09.07.17.
//  Copyright © 2016 Serge Sukhanov. All rights reserved.
//

import Foundation
import UIKit

let imageDomain = "https://static01.nyt.com/"

class Article {
    var name: String
    var date: String?
    var author: String?
    var link: String
    var image: UIImage?
    
    init(jsonDictionary: [String : AnyObject]) {
        let jsonHeadline = jsonDictionary["headline"] as! [String : AnyObject]
        self.name = jsonHeadline["main"] as! String
        
        if let jsonByLine = jsonDictionary["byline"] as? [String : AnyObject] {
            self.author = jsonByLine["original"] as? String
        }
        
        let jsonDate = jsonDictionary["pub_date"] as! String
        let jsonDateArray = jsonDate.componentsSeparatedByString("T")
        if let dateString = jsonDateArray.first {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            if let date = dateFormatter.dateFromString(dateString) {
                dateFormatter.dateFormat = "dd/MM/yyyy"
                self.date = dateFormatter.stringFromDate(date)
            }
        }
        
        self.link = jsonDictionary["web_url"] as! String
        
        
        if let jsonMultimedia = jsonDictionary["multimedia"] as? [[String : AnyObject]] {
            if jsonMultimedia.count > 0 {
                guard let imageURLString = jsonMultimedia[0]["url"] as? String,
                    let imageURL = NSURL(string: imageDomain + imageURLString),
                    let imageData = NSData(contentsOfURL: imageURL) else {
                        return
                }
                self.image = UIImage(data: imageData)
            }
        }
    }
}
