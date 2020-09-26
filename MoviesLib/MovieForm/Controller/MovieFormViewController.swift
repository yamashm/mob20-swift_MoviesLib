//
//  MovieFormViewController.swift
//  MoviesLib
//
//  Created by Usuário Convidado on 26/09/20.
//  Copyright © 2020 FIAP. All rights reserved.
//

import UIKit

final class MovieFormViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var textFieldTitle: UITextField!
    @IBOutlet weak var textFieldRating: UITextField!
    @IBOutlet weak var textFieldDuration: UITextField!
    @IBOutlet weak var labelCategories: UILabel!
    @IBOutlet weak var imageViewPoster: UIImageView!
    @IBOutlet weak var textViewSummary: UITextView!
    @IBOutlet weak var buttonSave: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    // MARK: - Properties
    var movie: Movie?
    
    // MARK: - Super Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Observar o evento do teclado aparecer
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        //Observa o evento do teclado desaparecer
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - IBActions
    @IBAction func selectImage(_ sender: Any) {
    }
    @IBAction func save(_ sender: Any) {
        if movie == nil{
            movie = Movie(context: context)
        }
        movie?.title = textFieldTitle.text
        movie?.summary = textViewSummary.text
        movie?.duration = textFieldDuration.text
        let rating = Double(textFieldRating.text!) ?? 0
        movie?.rating = rating
        movie?.image = imageViewPoster.image?.jpegData(compressionQuality: 0.9)
        
        view.endEditing(true) //Retira o teclado
        
        do{
            try context.save()
            navigationController?.popViewController(animated: true)
        }catch{
            print(error)
        }
    }
    
    // MARK: - Methods
    private func setupView(){
        if let movie = movie{
            title = "Edicao de filme"
            textFieldTitle.text = movie.title
            textFieldRating.text = "\(movie.rating ?? 0)"
            textFieldDuration.text = movie.duration
            textViewSummary.text = movie.summary
            buttonSave.setTitle("Alterar", for: .normal)
            if let data = movie.image {
                imageViewPoster.image = UIImage(data: data)
            }
        }
    }
    
    @objc
    private func keyboardWillShow(notification: NSNotification){
        guard let userInfo = notification.userInfo, let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {return}
        //Altera o espaco na base da scrollview com base na altura do teclado tirando a safearea
        scrollView.contentInset.bottom = keyboardFrame.size.height - view.safeAreaInsets.bottom
        scrollView.verticalScrollIndicatorInsets.bottom  = keyboardFrame.size.height - view.safeAreaInsets.bottom
    }
    
    @objc
    private func keyboardWillHide(){
        scrollView.contentInset.bottom = 0
        scrollView.verticalScrollIndicatorInsets.bottom  = 0
    }

}
