//
//  ViewController.swift
//  MoviesLib
//
//  Created by Usuário Convidado on 22/09/20.
//  Copyright © 2020 FIAP. All rights reserved.
//

import UIKit

final class MovieViewController: UIViewController {

    //Marcadores MARK, funcionam como regions.Organizam o codigo caso a classe seja muito grande.
    //Sinal de menos antes cria uma linha antes, depois, cria depois
    // MARK: - IBOutlets
    @IBOutlet weak var imageViewPoster: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelCategories: UILabel!
    @IBOutlet weak var labelDuration: UILabel!
    @IBOutlet weak var labelRating: UILabel!
    @IBOutlet weak var textViewSummary: UITextView!
    
    // MARK: - Properties
    var movie: Movie!
    
    // MARK: - Super Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    
        //loadMovies()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imageViewPoster.image = UIImage(named: movie.image ?? "placeholder")
        labelTitle.text = movie.title
        labelCategories.text = movie.categories
        labelDuration.text = movie.duration
        labelRating.text = movie.ratingFormatted
        labelDuration.text = movie.duration
        textViewSummary.text = movie.summary
        
    }
    
    // MARK: - IBActions
    
    // MARK: - Methods
}

