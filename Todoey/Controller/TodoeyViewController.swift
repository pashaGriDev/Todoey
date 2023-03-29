//
//  TodoeyViewController.swift
//  Todoey
//
//  Created by Павел Грицков on 29.03.23.
//

import UIKit
import RealmSwift

class TodoeyViewController: UITableViewController {
   
    @IBOutlet weak var searchBar: UISearchBar!
    
    var todoItems: Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory: Category? {
        didSet {
          loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var localTextField = UITextField()
        
        let alert = UIAlertController(title: K.Alert.title, message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: K.Alert.actionTitle, style: .default) { action in
            let text = localTextField.text ?? ""

            if text == "" { return } // проверка пустой строки
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write { // записать
                        let newItem = Item()
                        newItem.title = text
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Ошибка \(error)")
                }
            }
            
            self.tableView.reloadData()
//          self.saveItems()
            
        }
        
        alert.addTextField { textField in
            textField.placeholder = "Search items"
            localTextField = textField
        }
        alert.addAction(action)
        
        present(alert, animated: true)
    }
    
    deinit {
        print("deinit")
    }
}

// MARK: - Save and load data

extension TodoeyViewController {
    
    func saveItems() {
        
    }

    func loadItems() {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
}

// MARK: - UITableViewDelegate

extension TodoeyViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Ошибка сохранения статуса \(error)")
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
    
}


// MARK: - UITableViewDataSource

extension TodoeyViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellId.ItemIdentifier, for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = todoItems?[indexPath.row].title ?? "No item"
        }
        
        return cell
    }
}

// MARK: - UISearchBarDelegate

extension TodoeyViewController: UISearchBarDelegate {
    
}


