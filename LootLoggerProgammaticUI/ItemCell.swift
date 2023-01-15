//
//  ItemCell.swift
//  LootLoggerProgammaticUI
//
//  Created by George Mapaya on 2023-01-14.
//

import UIKit

class ItemCell: UITableViewCell {
    
    var nameLabel = UILabel()
    var serialNumberLabel = UILabel()
    var valueLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // MARK: - Configure the cell's suviews
        
        // nameLabel
        nameLabel.font = .preferredFont(forTextStyle: .body)
        nameLabel.adjustsFontForContentSizeCategory = true
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nameLabel)
        // serialNumberLabel
        serialNumberLabel.font = .preferredFont(forTextStyle: .caption1)
        serialNumberLabel.adjustsFontForContentSizeCategory = true
        serialNumberLabel.textColor = .secondaryLabel
        serialNumberLabel.setContentHuggingPriority(UILayoutPriority(250), for: .vertical)
        serialNumberLabel.setContentCompressionResistancePriority(UILayoutPriority(749), for: .vertical)
        serialNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(serialNumberLabel)
        // valueLabel
        valueLabel.font = .preferredFont(forTextStyle: .body)
        valueLabel.adjustsFontForContentSizeCategory = true
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(valueLabel)
        
        // MARK: - Add constraints to subviews
        
        let margins = contentView.layoutMarginsGuide
        NSLayoutConstraint.activate([
            // nameLabel
            nameLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: margins.topAnchor),
            // serialNumberLabel
            serialNumberLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            serialNumberLabel.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
            serialNumberLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            // valueLabel
            valueLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            valueLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
