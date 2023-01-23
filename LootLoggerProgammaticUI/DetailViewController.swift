//
//  DetailViewController.swift
//  LootLoggerProgammaticUI
//
//  Created by George Mapaya on 2023-01-14.
//

import UIKit

protocol DetailViewControllerDelegate {
    func didFinishEditing(_ detailViewController: DetailViewController)
}

class DetailViewController: UIViewController, UITextFieldDelegate {
    
    var item: Item! {
        didSet {
            navigationItem.title = item.name
        }
    }
    var delegate: DetailViewControllerDelegate?
    
    var nameTextField = UITextField()
    var serialNumberTextField = UITextField()
    var valueTextField = UITextField()
    var dateCreatedLabel = UILabel()
    var toolbar = UIToolbar()
    let mainStackView = UIStackView()
    
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
    
    override func viewDidLoad() {
        configureMainView()
        configureDateLabel()
        configureStacks()
        configureTextFields()
        configureToolBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nameTextField.text = item.name
        serialNumberTextField.text = item.serialNumber
        valueTextField.text = numberFormatter.string(from: NSNumber(value: item.valueInDollars))
        dateCreatedLabel.text = dateFormatter.string(from: item.dateCreated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let name = nameTextField.text ?? ""
        let value = numberFormatter.number(from: valueTextField.text!)?.intValue ?? 0
        let serialNumber = serialNumberTextField.text
        item.acceptChanges(newName: name, newValue: value, newSerialNumber: serialNumber)
        delegate?.didFinishEditing(self)
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // TODO: - Find out why the keyboard is not dismissing
        textField.resignFirstResponder()
        return true
    }
    
    @objc func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func choosePhotoSource(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.modalPresentationStyle = .popover
        alertController.popoverPresentationController?.barButtonItem = sender
        // Option to use camera to take a photo
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
            print("Present camera")
        }
        // Option to use photo library to select a photo
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { _ in
            print("Present photo library")
        }
        // Option to cancel photo selection
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        // Add actions to alert controller
        alertController.addAction(cameraAction)
        alertController.addAction(photoLibraryAction)
        alertController.addAction(cancelAction)
        // Present the alert controller
        present(alertController, animated: true, completion: nil)
    }
    
    
}

// MARK: - Extension DetailViewController Methods

extension DetailViewController {
    
    fileprivate func configureMainView() {
        view.backgroundColor = .systemBackground
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backgroundTapped(_:))))
    }
    
    fileprivate func configureDateLabel() {
        dateCreatedLabel.text = "Date Created"
        dateCreatedLabel.textAlignment = .center
        dateCreatedLabel.setContentHuggingPriority(UILayoutPriority(249), for: .vertical)
    }
    
    fileprivate func configureTextFields() {
        nameTextField.delegate = self
        valueTextField.delegate = self
        serialNumberTextField.delegate = self
    }
    
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
        // Configure main stack view
        mainStackView.axis = .vertical
        mainStackView.spacing = 8
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        let views = [nameStackView, serialNumberStackView, valueStackView, dateCreatedLabel]
        for view in views {
            mainStackView.addArrangedSubview(view)
        }
        view.addSubview(mainStackView)
        
        // MARK: - Constraint subviews
        
        let margins = view.layoutMarginsGuide
        NSLayoutConstraint.activate([
            // TextFields
            serialNumberTextField.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            valueTextField.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            // verticalStackView
            mainStackView.topAnchor.constraint(equalTo: margins.topAnchor, constant: 8),
            mainStackView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
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
    
    fileprivate func configureToolBar() {
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        toolbar.items = [UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(choosePhotoSource(_:)))]
        view.addSubview(toolbar)
        // Set constraints
        toolbar.topAnchor.constraint(equalTo: mainStackView.bottomAnchor, constant: -8).isActive = true
        toolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        toolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        toolbar.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor).isActive = true
    }
    
    
}
