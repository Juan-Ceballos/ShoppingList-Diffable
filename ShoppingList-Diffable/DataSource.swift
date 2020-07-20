//
//  DataSource.swift
//  ShoppingList-Diffable
//
//  Created by Juan Ceballos on 7/19/20.
//  Copyright © 2020 Juan Ceballos. All rights reserved.
//

import UIKit

// conforms to UITableViewDataSource
class DataSource: UITableViewDiffableDataSource<Category, Item> {
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if Category.allCases[section] == .shoppingCart {
            return "🛒" + Category.allCases[section].rawValue
        } else {
            return Category.allCases[section].rawValue // "Running"
        }
    }
}
