//
//  Mememe.swift
//  Mememe 1.0
//
//  Created by Sayali Joshi on 25/03/20.
//  Copyright © 2020 Sayali Joshi. All rights reserved.
//

import Foundation
import UIKit

struct  Mememe {
    var topText : String
    var bottomText : String
    var originalImage : UIImage
    var memedImage : UIImage
    
    init(topText : String, bottomText : String, originalImage : UIImage, memedImage : UIImage) {
        self.topText = topText
        self.bottomText = bottomText
        self.originalImage = originalImage
        self.memedImage = memedImage
    }
}
