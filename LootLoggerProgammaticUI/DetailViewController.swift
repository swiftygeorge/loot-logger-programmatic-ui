//
//  DetailViewController.swift
//  LootLoggerProgammaticUI
//
//  Created by George Mapaya on 2023-01-14.
//

import UIKit

class DetailViewController: UIViewController {
    
    var item: Item!
    
    var nameTextField: UITextField = UITextField()
    var serialNumberTextField: UITextField = UITextField()
    var valueTextField: UITextField = UITextField()
    var dateCreatedLabel = UILabel()
    
    let numberFormatter: NumberFormatter = {
       let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.minimumFractionDigits = 2
        nf.maximumFractionDigits = 2
        return nf
    }()
    let dateFormatter: DateFormatter = {
       let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .none
        return df
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nameTextField.text = item.name
        serialNumberTextField.text = item.serialNumber
        valueTextField.text = numberFormatter.string(from: NSNumber(value: item.valueInDollars))
        dateCreatedLabel.text = dateFormatter.string(from: item.dateCreated)
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .systemBackground
        dateCreatedLabel.text = "Date Created"
        dateCreatedLabel.textAlignment = .center
        dateCreatedLabel.setContentHuggingPriority(UILayoutPriority(249), for: .vertical)
        configureStacks()
    }
    
    
}

// MARK: - Extension DetailViewController Methods

extension DetailViewController {
    
    fileprivate func configureStacks() {
        // Labels
        let nameLabel = UILabel()
        let serialNumberLabel = UILabel()
        let valueLabel = UILabel()
        // Stack views
        let nameStackView = UIStackView(arrangedSubviews: [nameLabel, nameTextField])
        let serialNumberStackView = UIStackView(arrangedSubviews: [serialNumberLabel, serialNumberTextField])
        let valueStackView = UIStackView(arrangedSubviews: [valueLabel, valueTextField])
        // Configure stack views
        configureStackView(nameStackView, forTextField: nameTextField, withLabel: nameLabel, andLabelText: "Name")
        configureStackView(serialNumberStackView, forTextField: serialNumberTextField, withLabel: serialNumberLabel, andLabelText: "Serial")
        configureStackView(valueStackView, forTextField: valueTextField, withLabel: valueLabel, andLabelText: "Value")
        // Add a vertical stack view to hold all the stack views
        let verticalStackView = UIStackView(arrangedSubviews: [nameStackView, serialNumberStackView, valueStackView, dateCreatedLabel])
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 8
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(verticalStackView)
        
        // MARK: - Constraint subviews
        
        let margins = view.layoutMarginsGuide
        NSLayoutConstraint.activate([
            // TextFields
            serialNumberTextField.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            valueTextField.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            // verticalStackView
            verticalStackView.topAnchor.constraint(equalTo: margins.topAnchor, constant: 8),
            verticalStackView.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: 8),
            verticalStackView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            verticalStackView.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        ])
    }
    
    fileprivate func configureStackView(_ stackView: UIStackView, forTextField textField: UITextField, withLabel label: UILabel, andLabelText text: String) {
        // Label
        label.text = text
        label.translatesAutoresizingMaskIntoConstraints = false
        // TextField
        textField.borderStyle = .roundedRect
        textField.setContentHuggingPriority(UILayoutPriority(249), for: .horizontal)
        textField.setContentCompressionResistancePriority(UILayoutPriority(749), for: .horizontal)
        textField.translatesAutoresizingMaskIntoConstraints = false
        // stackView
        stackView.axis = .horizontal
        stackView.spacing = 8
    }
    
    
}
