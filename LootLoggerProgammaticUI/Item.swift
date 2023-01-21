//
//  Item.swift
//  LootLoggerProgammaticUI
//
//  Created by George Mapaya on 2023-01-10.
//

import UIKit

class Item: Equatable {
    
    var name: String
    var valueInDollars: Int
    var serialNumber: String?
    var dateCreated: Date
    
    init(name: String, valueInDollars: Int, serialNumber: String?) {
        self.name = name
        self.valueInDollars = valueInDollars
        self.serialNumber = serialNumber
        self.dateCreated = Date()
    }
    
    convenience init(random: Bool = false) {
        if random {
            let adjectives = ["Fluffy", "Rusty", "Shiny"]
            let nouns = ["Mac", "Spork", "Bear"]
            let adjective = adjectives.randomElement()!
            let noun = nouns.randomElement()!
            let name = "\(adjective) \(noun)"
            let value = Int.random(in: 0 ..< 100)
            let serialNumber = UUID().uuidString.components(separatedBy: "-").first!
            self.init(name: name, valueInDollars: value, serialNumber: serialNumber)
        } else {
            self.init(name: "", valueInDollars: 0, serialNumber: nil)
        }
    }
    
    static func ==(lhs: Item, rhs: Item) -> Bool {
        lhs.name == rhs.name &&
        lhs.valueInDollars == rhs.valueInDollars &&
        lhs.serialNumber == rhs.serialNumber &&
        lhs.dateCreated == rhs.dateCreated
    }
    
    func acceptChanges(newName: String, newValue: Int, newSerialNumber: String?) {
        self.name = newName
        self.valueInDollars = newValue
        self.serialNumber = newSerialNumber
    }
    
    
}
