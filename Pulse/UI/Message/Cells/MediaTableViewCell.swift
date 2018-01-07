//
//  MediaTableViewCell.swift
//  Pulse
//
//  Created by Luke Klinker on 1/7/18.
//  Copyright © 2018 Luke Klinker. All rights reserved.
//

import UIKit
import Kingfisher
import SwiftyJSON

class MediaTableViewCell : MessageTableViewCell {
    
    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func bind(conversation: Conversation, message: Message) {
        super.bind(conversation: conversation, message: message)
        
        if let dataFromString = message.data.data(using: .utf8, allowLossyConversion: false) {
            do {
                let json = try JSON(data: dataFromString)
                
                if (message.mimeType == MimeType.MEDIA_YOUTUBE_V2) {
                    handleYoutube(json: json)
                } else if (message.mimeType == MimeType.MEDIA_ARTICLE) {
                    handleArticle(json: json)
                }
            } catch { }
        }
        
        self.timestamp.isHidden = true
    }
    
    private func handleArticle(json: JSON) {
        let imageUrl = URL(string: json["image_url"].string!)!
        
        self.previewImage.kf.setImage(with: imageUrl, options: [.transition(.fade(0.2))])
        self.title.text = " \(json["title"].string!)"
        self.descriptionLabel.text = " \(json["description"].string!)"
    }
    
    private func handleYoutube(json: JSON) {
        let thumbnail = URL(string: json["thumbnail"].string!)!
        
        self.previewImage.kf.setImage(with: thumbnail, options: [.transition(.fade(0.2))])
        self.title.text = " \(json["title"].string!)"
        self.descriptionLabel.text = " YouTube"
    }
}

