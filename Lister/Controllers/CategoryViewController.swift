//
//  CategoryViewController.swift
//  Lister
//
//  Created by Geovanny quiroz on 7/23/19.
//  Copyright © 2019 Geovanny quiroz. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {

    let realm = try! Realm()
    var categories: Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .white
    }

    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categories?[indexPath.row]{
            
            cell.textLabel?.text = category.name
            
            guard let categoryColor = UIColor(hexString: category.color) else {
                fatalError()
            }

            cell.backgroundColor = categoryColor
            cell.textLabel?.textColor = .white
        }

        return cell
    }

    //MARK: - Data Manipulation Methods
    func save(category: Category){
        do{
            try realm.write {
                realm.add(category)
            }
        }
        catch{
            print("Error saving context, \(error)")
        }
        tableView.reloadData()
    }

    func loadCategories() {
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }

    //MARK - Delete Data inherited from Swipe
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row]{
            do{
                try self.realm.write{
                    self.realm.delete(categoryForDeletion)
                }
            }
            catch{
                print("Error deleting category, \(error)")
            }
        }
    }

    //MARK: - Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {

        var textField = UITextField()

        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)

        let action = UIAlertAction(title: "Add", style: .default) { (action) in

            // what happends when user clicks the add item button on UIAlert
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.color = UIColor.flatBlack().hexValue()
            self.save(category: newCategory)
        }

        let cancel = UIAlertAction(title: "Cancel", style: .cancel) {
            (cancel) in
            alert.dismiss(animated: true, completion: nil)
        }

        alert.addTextField { (field) in
            textField.placeholder = "Create Category"
            textField = field
        }

        alert.addAction(cancel)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)

    }

    //MARK: TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
}
