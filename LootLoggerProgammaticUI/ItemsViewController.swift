//
//  ItemsViewController.swift
//  LootLoggerProgammaticUI
//
//  Created by George Mapaya on 2023-01-10.
//

import UIKit

class ItemsViewController: UITableViewController, DetailViewControllerDelegate {
   
    var itemStore: ItemStore!
    var imageStore: ImageStore!
    var addButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 65
        configureNavBar()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemStore.allItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        let item = itemStore.allItems[indexPath.row]
        cell.nameLabel.text = item.name
        cell.serialNumberLabel.text = item.serialNumber
        cell.valueLabel.text = "$\(item.valueInDollars)"
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
            imageStore.deleteImage(forKey: item.itemKey)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = itemStore.allItems[indexPath.row]
        let detailViewController = DetailViewController()
        detailViewController.delegate = self
        detailViewController.item = item
        detailViewController.imageStore = imageStore
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    // MARK: - Methods
    
    func didFinishEditing(_ detailViewController: DetailViewController) {
        tableView.reloadData()
    }
    
    @objc func addNewItem(_ sender: UIBarButtonItem) {
        itemStore.createItem()
        let lastRow = tableView.numberOfRows(inSection: 0)
        let indexPath = IndexPath(row: lastRow, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    fileprivate func configureTableView() {
        tableView = UITableView(frame: view.frame, style: .plain)
        tableView.register(ItemCell.self, forCellReuseIdentifier: "ItemCell")
        tableView.allowsMultipleSelection = false
    }
    
    fileprivate func addView(_ view: UIView, toSuperView superView: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        superView.addSubview(view)
    }
    
    fileprivate func configureNavBar() {
        navigationItem.leftBarButtonItem = editButtonItem
        self.navigationItem.title = "LootLogger"
        addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewItem(_:)))
        navigationItem.rightBarButtonItem = addButton
    }
    

}
