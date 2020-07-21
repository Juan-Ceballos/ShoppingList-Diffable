//
//  DataSource.swift
//  ShoppingList-Diffable
//
//  Created by Juan Ceballos on 7/19/20.
//  Copyright © 2020 Juan Ceballos. All rights reserved.
//

import UIKit

// conforms to UITableViewDataSource
// snapshot becomes source of truth
class DataSource: UITableViewDiffableDataSource<Category, Item> {
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if Category.allCases[section] == .shoppingCart {
            return "🛒" + Category.allCases[section].rawValue
        } else {
            return Category.allCases[section].rawValue // "Running"
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // 1. get the current snapshot
            var snapshot = self.snapshot()
            // 2. get the item using the itemIdentifier
            if let item = itemIdentifier(for: indexPath) {
                // 3. delete the item from the snapshot
                snapshot.deleteItems([item])
                // 4. apply the snapshot (apple changes to the datasource
                //    which in turn updates the table view
                apply(snapshot, animatingDifferences: false)
            }
            
        }
    }
    
    // possible code snippet reordering diffDSTV
    // 1. reordering steps
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // 2. reordering steps
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // get the source item
        guard let sourceItem = itemIdentifier(for: sourceIndexPath) else {return}
        
        // Scenario 1: sttempting to move to self
        guard sourceIndexPath != destinationIndexPath else {return}
        
        // get the destination item
        let destionationItem = itemIdentifier(for: destinationIndexPath)
        
        // get the current snapshot
        var snapshot = self.snapshot()
        
        // handle Scenario 2 and 3
        if let destinationItem = destionationItem {
           // get the source index and the destiantion index
            if let sourceIndex = snapshot.indexOfItem(sourceItem),
                let destinationIndex = snapshot.indexOfItem(destinationItem) {
                
                // what order should we be inserting the source item
                let isAfter = destinationIndex > sourceIndex && snapshot.sectionIdentifier(containingItem: sourceItem) == snapshot.sectionIdentifier(containingItem: destinationItem)
                
                // first delete the source item
                snapshot.deleteItems([sourceItem])
                // Scenario 2
                if isAfter  {
                    snapshot.insertItems([sourceItem], afterItem: destinationItem)
                }
                // Scenario 3
                else {
                    snapshot.insertItems([sourceItem], beforeItem: destinationItem)
                }
            }
        }
        
        // handle Scenario 4
        // no index path at destination section
        else {
            // get the section for the destination idex path
            let destinationSection = snapshot.sectionIdentifiers[destinationIndexPath.section]
            
            // delete the source item before reinserting it
            snapshot.deleteItems([sourceItem])
            
            // append the source item at the new section
            snapshot.appendItems([sourceItem], toSection: destinationSection)
        }
        
        // apply changes to the data source
        apply(snapshot, animatingDifferences: false)
    }
    
}
