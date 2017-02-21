//
//  TweetDetailTableViewCell.swift
//  Smashtag
//
//  Created by Ziheng Chen on 2/13/17.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import UIKit
import Twitter

class TweetImageTableViewCell: UITableViewCell {

    @IBOutlet weak var images: UIImageView!
    
    var imageInfo: Twitter.MediaItem? { didSet{ updateUI() } }
    
    private func updateUI() {
        if let imageURL = imageInfo?.url {
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                if let imageData = try? Data(contentsOf: imageURL) {
                    DispatchQueue.main.async {
                        self?.images.image = UIImage(data: imageData)
                    }
                }
            }
        }
    }
}
