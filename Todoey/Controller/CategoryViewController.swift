//
//  CategoryViewController.swift
//  ToDo-Angela
//
//  Created by Павел Грицков on 26.03.23.
//

import UIKit
import RealmSwift
import SwipeCellKit

class CategoryViewController: UITableViewController {

    lazy var realm: Realm = {
        return try! Realm()
    }()
    
    var categoryArray: Results<Category>?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 80.0
        loadCategories()
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: K.Alert.title, message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: K.Alert.actionTitle, style: .default) {[weak alert] action in
            let text = alert?.textFields?.first?.text ?? ""
            
            if text == "" { return } // проверка на пустую строку
            
            let newCategory = Category()
            newCategory.name = text

            self.save(newCategory)
        }
        
        alert.addTextField { textField in
            textField.placeholder = "Create new item"
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    deinit {
        print("deinit")
    }
}

// MARK: - Save, load and delete data

extension CategoryViewController {

    func save(_ category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Ошибка сохранения \(error)")
        }
        
        tableView.reloadData()
    }
    
    func delete(_ category: Category) {
        do {
            try realm.write {
                realm.delete(category)
            }
        } catch {
            print("Ошибка удаления \(error)")
        }
        
//        tableView.reloadData()
    }

    func loadCategories() {
        categoryArray = realm.objects(Category.self)
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource

extension CategoryViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellId.categoryIdentifier, for: indexPath) as! SwipeTableViewCell
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Categories"
        cell.delegate = self
        return cell
    }
}

// MARK: - SwipeTableViewCellDelegate

extension CategoryViewController: SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeCellKit.SwipeActionsOrientation) -> [SwipeCellKit.SwipeAction]? {
        
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            
            if let category = self.categoryArray?[indexPath.row] {
                self.delete(category)
            }
        }
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
//        options.transitionStyle = .border
        return options
    }
}

// MARK: - UITableViewDelegate

extension CategoryViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /*
         tableView.deselectRow(at: indexPath, animated: true)
         некоректно работает с методом
         tableView.indexPathForSelectedRow
         при переходе indexPath == nil
         */
        
        performSegue(withIdentifier: K.segue.items, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoeyViewController

        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }
}
