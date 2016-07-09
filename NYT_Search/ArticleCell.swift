//
//  ArticleCell.swift
//  NYT_Search
//
//  Created by Serge Sukhanov on 09.07.16.
//  Copyright © 2016 Serge Sukhanov. All rights reserved.
//

import UIKit

class ArticleCell: UITableViewCell {
    
    var article: Article?

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var imageImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell() {
        if let article = article {
            nameLabel.text = article.name
            authorLabel.text = article.author
            dateLabel.text = article.date
            imageImageView.image = nil
            if let articleImage = article.image {
                imageImageView.image = articleImage
            }
        }
    }
    
}
