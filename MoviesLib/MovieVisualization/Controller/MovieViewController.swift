//
//  ViewController.swift
//  MoviesLib
//
//  Created by Usuário Convidado on 22/09/20.
//  Copyright © 2020 FIAP. All rights reserved.
//

import UIKit
import AVKit

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
    @IBOutlet weak var viewTrailer: UIView!
    
    // MARK: - Properties
    var movie: Movie!
    var moviePlayer: AVPlayer?
    var moviePlayerController: AVPlayerViewController?
    var trailer: String = ""
    
    // MARK: - Super Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //loadMovies()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //imageViewPoster.image = UIImage(named: movie.image ?? "placeholder")
        labelTitle.text = movie.title
        //labelCategories.text = movie.categories
        labelDuration.text = movie.duration
        labelRating.text = movie.ratingFormatted
        labelDuration.text = movie.duration
        textViewSummary.text = movie.summary
        imageViewPoster.image = movie.poster
        labelCategories.text = (movie.categories as? Set<Category>)?.compactMap({$0.name}).sorted().joined(separator: " | ")
        
        if let title = movie.title {
            loadTrailer(with: title)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? MovieFormViewController {
            vc.movie = movie
        }
    }
    
    // MARK: - IBActions
    @IBAction func playTrailer(_ sender: UIButton) {
        /*
         guard let moviePlayerController = moviePlayerController else {return}
         present(moviePlayerController, animated: true) {
         self.moviePlayer?.play()
         }
         */
        viewTrailer.isHidden = false
        sender.isHidden = true
        moviePlayer?.play()
    }
    
    
    // MARK: - Methods
    private func loadTrailer(with title: String){
        let itunesPath = "https://itunes.apple.com/search?media=movie&entity=movie&term="
        guard let encodedTitle = title.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
            let url = URL(string: "\(itunesPath)\(encodedTitle)") else {return}
        
        URLSession.shared.dataTask(with: url) {(data, _,_) in
            let apiResult = try! JSONDecoder().decode(ItunesResult.self, from: data!)
            self.trailer = apiResult.results.first?.previewUrl ?? ""
            self.prepareVideo()
        }.resume()
    }
    
    private func prepareVideo(){
        guard let url = URL(string: trailer) else {return}
        moviePlayer = AVPlayer(url: url)
        DispatchQueue.main.async {
            self.moviePlayerController = AVPlayerViewController()
            self.moviePlayerController?.player = self.moviePlayer
            
            guard let movieView = self.moviePlayerController?.view else {return}
            movieView.frame = self.viewTrailer.bounds
            self.viewTrailer.addSubview(movieView)
        }
    }
}

struct ItunesResult: Codable{
    let results: [MovieInfo]
}

struct MovieInfo: Codable{
    let previewUrl: String
}

