//
//  ImageCollectionViewCell.swift
//  SnapImage
//
//  Created by Spencer Curtis on 1/6/17.
//  Copyright © 2017 Spencer Curtis. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    func updateWith(image: UIImage) {
        self.imageView.image = image
    }
    
}
