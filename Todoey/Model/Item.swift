//
//  Item.swift
//  Todoey
//
//  Created by Павел Грицков on 29.03.23.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    
    // обратная связь с родительской категорией
    // class и property с которой связь
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
