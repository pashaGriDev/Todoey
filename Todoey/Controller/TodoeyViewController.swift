//
//  TodoeyViewController.swift
//  Todoey
//
//  Created by Павел Грицков on 29.03.23.
//

import Foundation
import UIKit

class TodoeyViewController: UITableViewController {
   
    @IBOutlet weak var searchBar: UISearchBar!
    
    var array = ["1"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var localTextField = UITextField()
        
        let alert = UIAlertController(title: K.Alert.title, message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: K.Alert.actionTitle, style: .default) { action in
            let text = localTextField.text ?? ""
            print(text)
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

// MARK: - UITableViewDelegate

extension TodoeyViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("pressed cell")
    }
    
}


// MARK: - UITableViewDataSource

extension TodoeyViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellId.ItemIdentifier, for: indexPath)
        cell.textLabel?.text = array[indexPath.row]
        return cell
    }
}

// MARK: - UISearchBarDelegate

extension TodoeyViewController: UISearchBarDelegate {
    
}


