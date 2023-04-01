//
//  CategoryViewController.swift
//  ToDo-Angela
//
//  Created by Павел Грицков on 26.03.23.
//

import UIKit
import RealmSwift
import RandomColor

class CategoryViewController: SwipeTableViewController {

    lazy var realm: Realm = {
        return try! Realm()
    }()
    
    var categoryArray: Results<Category>?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
        loadCategories()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        settingUI()
    }
    
    func settingUI() {
        // настройка фона и цвета заголовка
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .systemBlue
        appearance.titleTextAttributes = [.foregroundColor : UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor : UIColor.white]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        // непрозрачность
        navigationController?.navigationBar.isTranslucent = false
        // большой нав бар
        navigationController?.navigationBar.prefersLargeTitles = true
        // темный светлый стить
        navigationController?.navigationBar.barStyle = .black
        // цвет кнопок в нав баре
        navigationController?.navigationBar.tintColor = .white
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: K.Alert.title, message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: K.Alert.actionTitle, style: .default) {[weak alert] action in
            let text = alert?.textFields?.first?.text ?? ""
            
            if text == "" { return } // проверка на пустую строку
            
            let newCategory = Category()
            let color = randomColor(hue: .blue, luminosity: .light)
            let hexColorName = color.hexString ?? "#FFFFFF"
            
            newCategory.name = text
            newCategory.hexColorName = hexColorName
            

            self.save(newCategory)
        }
        
        alert.addTextField { textField in
            textField.placeholder = "Create new item"
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    override func updateModel(at indexPath: IndexPath) {
        super.updateModel(at: indexPath)
        if let category = categoryArray?[indexPath.row] {
            delete(category)
        }
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
        // выпоняем супер, потом дополняем в тут в подклассе
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categoryArray?[indexPath.row] {
            cell.textLabel?.text = category.name
            cell.backgroundColor = UIColor(category.hexColorName)
        } else {
            cell.textLabel?.text = "No Categories"
        }

        return cell
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
