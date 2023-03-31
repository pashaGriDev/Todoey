//
//  Category.swift
//  Todoey
//
//  Created by Павел Грицков on 29.03.23.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var hexColorName: String = ""

    // связь один ко многим с Item
    let items = List<Item>() // массив Item типа Array<String>
}
