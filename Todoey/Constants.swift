//
//  Constants.swift
//  ToDo-Angela
//
//  Created by Павел Грицков on 26.03.23.
//

import Foundation

struct K {
    static let userDefautsKey = "ToDoListArray"
    static let itemsFileName = "Items.plist"
    
    enum cellId {
        static let ItemIdentifier = "TodoeyItemCell"
        static let categoryIdentifier = "CaterogyCell"
    }
    
    enum Alert{
        static let title = "Add new todoey"
        static let actionTitle = "Add"
    }
    
    enum segue {
        static let items = "goToItems"
    }
    
}
