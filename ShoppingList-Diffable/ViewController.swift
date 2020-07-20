//
//  ViewController.swift
//  ShoppingList-Diffable
//
//  Created by Juan Ceballos on 7/19/20.
//  Copyright © 2020 Juan Ceballos. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
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
            cell.textLabel?.text = "\(item.name)"
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
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    @objc private func toggleEditState() {
        
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
    }

}

