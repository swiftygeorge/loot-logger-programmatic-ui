//
//  ItemStore.swift
//  LootLoggerProgammaticUI
//
//  Created by George Mapaya on 2023-01-10.
//

import UIKit

class ItemStore {
    
    var allItems = [Item]()
    let archiveURL: URL = {
        let documentDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentDirectories.first!
        return documentDirectory.appending(component: "items.plist")
    }()
    
    init() {
        loadItems()
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(saveChanges), name: UIScene.didDisconnectNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(saveChanges), name: UIScene.didEnterBackgroundNotification, object: nil)
    }
    
    @discardableResult func createItem() -> Item {
        let newItem = Item(random: true)
        allItems.append(newItem)
        return newItem
    }
    
    func moveItem(from fromIndex: Int, to toIndex: Int) {
        let item = allItems[fromIndex]
        allItems.remove(at: fromIndex)
        allItems.insert(item, at: toIndex)
    }
    
    func deleteItem(_ item: Item) {
        if let index = allItems.firstIndex(of: item) {
            allItems.remove(at: index)
        }
    }
    
    @objc func saveChanges() throws {
        do {
            let encoder = PropertyListEncoder()
            let data = try encoder.encode(allItems)
            try data.write(to: archiveURL, options: [.atomic])
        } catch let encodingError {
            print("Unable to save items: \(encodingError.localizedDescription)")
        }
    }
    
    fileprivate func loadItems() {
        do {
            let decoder = PropertyListDecoder()
            let data = try Data(contentsOf: archiveURL)
            let items = try decoder.decode([Item].self, from: data)
            allItems = items
        } catch let decodingError {
            print("Could not load saved items: \(decodingError.localizedDescription)")
        }
    }
    
    
}
