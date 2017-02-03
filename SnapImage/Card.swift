//
//  Card.swift
//  SnapImage
//
//  Created by Spencer Curtis on 1/9/17.
//  Copyright © 2017 Spencer Curtis. All rights reserved.
//

import Foundation
import UIKit

class Card {
    
    private let kImageEndpoint = "image"
    private let kSuit = "suit"
    private let kValue = "value"
    
    let imageEndpoint: String
    let suit: String
    let value: String
    var image: UIImage?
    
    init(imageEndpoint: String, value: String, suit: String) {
        self.imageEndpoint = imageEndpoint
        self.value = value
        self.suit = suit
    }
    
    init?(jsonDictionary: [String: Any]) {
        guard let imageEndpoint = jsonDictionary[kImageEndpoint] as? String, let value = jsonDictionary[kValue] as? String, let suit = jsonDictionary[kSuit] as? String else { return nil }
        
        self.imageEndpoint = imageEndpoint
        self.value = value
        self.suit = suit
    }
    
}
