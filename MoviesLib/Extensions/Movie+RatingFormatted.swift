//
//  Movie+RatingFormatted.swift
//  MoviesLib
//
//  Created by Usuário Convidado on 24/09/20.
//  Copyright © 2020 FIAP. All rights reserved.
//

import Foundation

extension Movie{
    var ratingFormatted: String {
        "⭐️ \(rating ?? 0)/10"
    }
}
