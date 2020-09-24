//
//  Movies.swift
//  MoviesLib
//
//  Created by Usuário Convidado on 24/09/20.
//  Copyright © 2020 FIAP. All rights reserved.
//

import Foundation

//Decodable, permite criar o objeto a partir do json
//Encodable, permite cirar json a partir do objeto
//Codable, ambos os acima
struct Movie: Decodable {
    //Pode se usar optional caso alguma dessas propriedads nao seja necessaria
    let title: String?
    let categories: String?
    let duration: String?
    let rating: Double?
    let summary: String?
    let image: String?
    
    //Caso o json venha com outros nomes
    //E necessario colocar um case para todas as propriedades
    enum CodingKeys: String, CodingKey {
        case title = "titulo"
        case categories, duration, rating, summary, image
    }
    
    //Caso se queira que alguma propriedade tenha um valor padrao
    init(from decoder: Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decodeIfPresent(String.self, forKey: .title) ?? "Titulo desconhecido"
        categories = try container.decodeIfPresent(String.self, forKey: .categories)
        duration = try container.decodeIfPresent(String.self, forKey: .duration)
        rating = try container.decodeIfPresent(Double.self, forKey: .rating)
        summary = try container.decodeIfPresent(String.self, forKey: .summary)
        image = try container.decodeIfPresent(String.self, forKey: .image) ?? "placeholder"
    }
}
