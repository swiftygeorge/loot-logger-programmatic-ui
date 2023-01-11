//
//  ItemsViewController.swift
//  LootLoggerProgammaticUI
//
//  Created by George Mapaya on 2023-01-10.
//

import UIKit

class ItemsViewController: UITableViewController {
   
    var itemStore: ItemStore!
    
    let editButton = UIButton(type: .system)
    let addButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemStore.allItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // TODO: - Find out how to make cell reusable programmatically
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "UITableViewCell")
        let item = itemStore.allItems[indexPath.row]
        var configuration = cell.defaultContentConfiguration()
        configuration.text = item.name
        configuration.secondaryText = "$\(item.valueInDollars)"
        cell.contentConfiguration = configuration
        return cell
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        itemStore.moveItem(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // If we are in deleting mode...
        if editingStyle == .delete {
            let item = itemStore.allItems[indexPath.row]
            itemStore.deleteItem(item)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    @objc func toggleEditMode(_ sender: UIButton) {
        // If the table view controller is currently in editing mode...
        if isEditing {
            // Inform the user of the change in state
            sender.setTitle("Edit", for: .normal)
            // Get out of editing mode
            setEditing(false, animated: true)
        } else {
            // Inform the user that the view controller is entering edit mode
            sender.setTitle("Done", for: .normal)
            // Enter editing mode
            setEditing(true, animated: true)
        }
    }
    
    @objc func addNewItem(_ sender: UIButton) {
        itemStore.createItem()
        let lastRow = tableView.numberOfRows(inSection: 0)
        let indexPath = IndexPath(row: lastRow, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    

}

// MARK: - Methods

extension ItemsViewController {
    
    fileprivate func configureTableView() {
        tableView = UITableView(frame: view.frame, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        configureTableViewHeader()
    }
    
    fileprivate func configureTableViewHeader() {
        // Create header view and add its subviews
        let headerView = UIView()
        headerView.frame.size.height = 60
        addView(editButton, toSuperView: headerView)
        addView(addButton, toSuperView: headerView)
        tableView.tableHeaderView = headerView
        // Style editButton and addButton and constraint them inside the header view
        configureButton(editButton, withTitle: "Edit", andTintColor: .tintColor)
        configureButton(addButton, withTitle: "Add", andTintColor: .tintColor)
        constraintTableHeaderViewElements(toSuperView: tableView.tableHeaderView!)
    }
    
    fileprivate func constraintTableHeaderViewElements(toSuperView superView: UIView) {
        let padding = 8.0
        NSLayoutConstraint.activate([
            editButton.leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: padding),
            editButton.centerYAnchor.constraint(equalTo: superView.centerYAnchor),
            addButton.trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: -padding),
            addButton.centerYAnchor.constraint(equalTo: editButton.centerYAnchor),
        ])
    }
    
    fileprivate func configureButton(_ button: UIButton, withTitle title: String, andTintColor tintColor: UIColor) {
        var configuration = UIButton.Configuration.borderless()
        configuration.automaticallyUpdateForSelection = true
        configuration.title = title
        configuration.titleAlignment = .center
        button.configuration = configuration
        switch button {
        case editButton:
            button.addTarget(self, action: #selector(toggleEditMode(_:)), for: .touchUpInside)
        case addButton:
            button.addTarget(self, action: #selector(addNewItem(_:)), for: .touchUpInside)
        default:
            fatalError("Unrecognized button!")
        }
    }
    
    fileprivate func addView(_ view: UIView, toSuperView superView: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        superView.addSubview(view)
    }
    
    
}
