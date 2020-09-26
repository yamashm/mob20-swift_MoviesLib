//
//  CategoriesTableViewController.swift
//  MoviesLib
//
//  Created by Usuário Convidado on 26/09/20.
//  Copyright © 2020 FIAP. All rights reserved.
//

import UIKit
import CoreData

protocol CategoriesDelegate: class {
    func setSelectedCategories(_ categories: Set<Category>)
}

class CategoriesTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
       
    }

    // MARK: - Properties
    // para poder definir como weak, o protocol deve ser um AnyObject ou class
    //delegate deve ser sempre waek para evitar referencia ciclica
    weak var delegate: CategoriesDelegate?
    var selectedCategories: Set<Category> = [] {
        willSet{
            
        }
        
        didSet{
            delegate?.setSelectedCategories(selectedCategories)
        }
    }
    var categories: [Category] = []
    
    // MARK: - IBActions
    @IBAction func add(_ sender: UIBarButtonItem) {
        showCategoryAlert()
    }
    
    // MARK: - Methods
    private func showCategoryAlert(for category: Category? = nil){
        let title = category == nil ? "Adicionar" : "Ëditar"
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Nome da categoria"
            textField.text = category?.name
        }
        
        let okAction = UIAlertAction(title: title, style: .default) { (_) in
            let category = category ?? Category(context: self.context)
            category.name = alert.textFields?.first?.text
            do {
                try self.context.save()
                self.loadCategories()
            }catch{
                print(error)
            }
        }
        alert.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func loadCategories(){
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do{
            categories = try context.fetch(fetchRequest)
            tableView.reloadData()
        }catch{
            print(error)
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories.count
    }
    
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
           let category = categories[indexPath.row]
        
        if(selectedCategories.contains(category)){
            cell.accessoryType = .checkmark
        } else{
            cell.accessoryType = .none
        }
        
           cell.textLabel?.text = category.name
           return cell
       }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction  = UIContextualAction(style: .normal, title: "Editar") { (action, view, completionHandler) in
            let category = self.categories[indexPath.row]
            self.showCategoryAlert(for: category)
            completionHandler(true)
        }
        editAction.backgroundColor = .systemBlue
        editAction.image = UIImage(systemName: "pencil")
        
        return UISwipeActionsConfiguration(actions: [editAction])
    }

   override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Excluir") { (action, view, completionHandler) in
            let category = self.categories[indexPath.row]
            self.context.delete(category)
            do {
                try self.context.save()
            } catch {
                
            }
            self.categories.remove(at: indexPath.row)
            self.selectedCategories.remove(category)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            completionHandler(true)
        }
        deleteAction.backgroundColor = .systemRed
        deleteAction.image = UIImage(systemName: "trash")
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = self.categories[indexPath.row]
        let cell = tableView.cellForRow(at: indexPath)
        if cell?.accessoryType == UITableViewCell.AccessoryType.none {
            cell?.accessoryType = .checkmark
            selectedCategories.insert(category)
        } else {
            cell?.accessoryType = .none
            selectedCategories.remove(category)
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
