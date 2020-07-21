//
//  ViewController.swift
//  ShoppingList-Diffable
//
//  Created by Juan Ceballos on 7/19/20.
//  Copyright © 2020 Juan Ceballos. All rights reserved.
//

import UIKit

class ItemFeedViewController: UIViewController {
    
    private var tableView: UITableView!
    // private var collectionView: UICollectionView!
    
    // subclassing, rather than NSDiffableDataSource instance creation
    private var dataSource: DataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        configureTableView()
        configureDataSource()
    }
    
    private func configureNavBar()  {
        navigationItem.title = "Shopping List"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(toggleEditState))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(presentAddVC))
    }
    
    private func configureTableView()   {
        tableView = UITableView(frame: view.bounds, style: .insetGrouped)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.backgroundColor = .systemGroupedBackground
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
    }
    
    // compare this to countdown for how tv and item taken
    // also reference the datasource class
    private func configureDataSource()  {
        dataSource = DataSource(tableView: tableView, cellProvider: { (tableView, indexPath, item) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            let formattedPrice = String(format: "%.2f", item.price)
            cell.textLabel?.text = "\(item.name)\nPrice: $\(formattedPrice)"
            cell.textLabel?.numberOfLines = 0
            return cell
        })
        
        // setup type of animation
        dataSource.defaultRowAnimation = .fade
        
        // setup initial snapshot, snapshot of nsdiffdatasource
        // need to match datasource type
        var snapshot = NSDiffableDataSourceSnapshot<Category, Item>()
        
        // populate snapshot with sections and items for each section
        // power of CaseIterable, allows us to iterate through all the cases of an enum
        for category in Category.allCases   {
            // filter the testData() [items] for that particular category's items
            let items = Item.testData().filter {$0.category == category}
            snapshot.appendSections([category]) // add section to tableview
            snapshot.appendItems(items)
        }
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    @objc private func toggleEditState() {
        // 1. false  -> 2. true -> 3. false
            
            // 1. !isEditing = false -> true
            // 2. !isEditing = true -> false
            // 3. !isEditing = false -> true
            
            tableView.setEditing(!tableView.isEditing, animated: true)
            navigationItem.leftBarButtonItem?.title = tableView.isEditing ? "Done" : "Edit"
            
        //    if tableView.isEditing {
        //      navigationItem.leftBarButtonItem?.title = "Done"
        //    } else {
        //      navigationItem.leftBarButtonItem?.title = "Edit"
        //    }
    }
    
    @objc private func presentAddVC()    {
        
        // TODO:
        // 1. create an AddItemViewController.swift file
        // 2. add a View Controller object in Storyboard
        // 3. add 2 textfields, one for the item name and other for price
        // 4. add a picker view to manage the categories
        // 5. user is able to add a new item to a given category and click on a submit button
        // 6. use any communication paradigm to get data from AddItemViewController back to the ViewController
        // types: delegate, KVO, notification center, unwind segue, callback, combine
        guard let addItemVC = storyboard?.instantiateViewController(withIdentifier: "AddItemViewController") as? AddItemViewController else {
            return
        }
        addItemVC.delegate = self
        present(addItemVC, animated: true)
    }
    
}

/*
extension ViewController: AddItemViewControllerDelegate {
    func didAddItem(item: Item) {
        var snapshot = dataSource.snapshot()
        snapshot.appendItems([item], toSection: item.category)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}
*/
extension ItemFeedViewController: AddItemViewControllerDelegate {
    func didAddNewItem(_ addItemViewController: AddItemViewController, item: Item) {
        var snapshot = dataSource.snapshot()
        snapshot.appendItems([item], toSection: item.category)
        
        // no need for reloadData()
        // no need for property observers
        // apply snapshot is all we need with diff DS
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}
