//
//  TodoeyViewController.swift
//  Todoey
//
//  Created by Павел Грицков on 29.03.23.
//

import UIKit
import RealmSwift
import RandomColor

class TodoeyViewController: SwipeTableViewController {
   
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
        
        tableView.rowHeight = 80.0
        settingUI()
    }
    
    func settingUI() {
        // appearance searchBar
        searchBar.barTintColor = randomColor(hue: .blue, luminosity: .light)
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
                        newItem.dataCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Ошибка сохранения \(error)")
                }
            }
            self.tableView.reloadData()
        }
        
        alert.addTextField { textField in
            textField.placeholder = "Search items"
            localTextField = textField
        }
        alert.addAction(action)
        
        present(alert, animated: true)
    }
    
    // MARK: - Delete items
    
    override func updateModel(at indexPath: IndexPath) {
        super.updateModel(at: indexPath)

        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(item)
                }
            } catch {
                print("Ошибка удаления \(error)")
            }
        }
    }
    
    // MARK: - Load items
    
    func loadItems() {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    deinit {
        print("deinit")
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
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = todoItems?[indexPath.row].title ?? "No item"
        }
        
        let color = randomColor(hue: .blue, luminosity: .light)
        cell.backgroundColor = color
        
        return cell
    }
}

// MARK: - UISearchBarDelegate

extension TodoeyViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // поиск по title содержащий searchBar.text и отсортированный по title в алфавитном порядке
        todoItems = todoItems?.filter("title CONTAINS %@", searchBar.text!).sorted(byKeyPath: "dataCreated", ascending: true)
        
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // если текст удали то отключает использование searchBar
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}


