//
//  MoviesTableViewController.swift
//  MoviesLib
//
//  Created by Usuário Convidado on 24/09/20.
//  Copyright © 2020 FIAP. All rights reserved.
//

import UIKit
import CoreData

class MoviesTableViewController: UITableViewController {

    // MARK: - Properties
    //var movies: [Movie] = []
    let label: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "Sem filmes cadastrados"
        label.textAlignment = .center
        label.font = UIFont.italicSystemFont(ofSize: 16.0)
        return label
    }()
    lazy var fetchedResultsController: NSFetchedResultsController<Movie> = {
        let fetchRequest: NSFetchRequest<Movie> = Movie.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    // MARK: - Super Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        loadMovies()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? MovieViewController, let indexPath = tableView.indexPathForSelectedRow else {return}
        vc.movie = fetchedResultsController.object(at: indexPath)//movies[indexPath.row]
    }
    
    // MARK: - Methods
    private func loadMovies(){
        try? fetchedResultsController.performFetch()
        /*
        guard let jsonURL = Bundle.main.url(forResource: "movies", withExtension: "json") else {return}
        
        do {
            let jsonData = try Data(contentsOf: jsonURL)
            
            let jsonDecoder = JSONDecoder()
            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
            //jsonDecoder.dateDecodingStrategy = .iso8601
            movies = try jsonDecoder.decode([Movie].self, from: jsonData)
            //movies.forEach{print($0.title)}
            tableView.reloadData()
        } catch{
            print(error)
        }
 */
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //return movies.count
        let count = fetchedResultsController.fetchedObjects?.count ?? 0
        tableView.backgroundView = count > 0 ? nil : label
        return count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? MovieTableViewCell else {
            return UITableViewCell()
        }
        // Identifier foi definido no Main.storyboard, na Table View Cell
        // Configure the cell...
        
        let movie = fetchedResultsController.object(at: indexPath)//movies[indexPath.row]
        
        cell.configure(with: movie)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let movie  = fetchedResultsController.object(at: indexPath)
            context.delete(movie)
            try? context.save()
        }
    }
}

extension MoviesTableViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
}
