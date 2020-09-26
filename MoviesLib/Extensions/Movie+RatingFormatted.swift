//
//  Movie+RatingFormatted.swift
//  MoviesLib
//
//  Created by Usuário Convidado on 24/09/20.
//  Copyright © 2020 FIAP. All rights reserved.
//

import Foundation
import UIKit

extension Movie{
    var ratingFormatted: String {
        "⭐️ \(rating)/10"
    }
    
    var poster: UIImage? {
        if let data = image{
            return UIImage(data: data)
        }
        else{
            return nil
        }
    }
}
