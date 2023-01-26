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

class DetailViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    // MARK: - Data stores
    
    var item: Item! {
        didSet {
            navigationItem.title = item.name
        }
    }
    var imageStore: ImageStore!
    var delegate: DetailViewControllerDelegate?
    
    // MARK: View objects
    
    var nameTextField = UITextField()
    var serialNumberTextField = UITextField()
    var valueTextField = UITextField()
    var dateCreatedLabel = UILabel()
    var imageView = UIImageView()
    let nameLabel = UILabel()
    let serialNumberLabel = UILabel()
    let valueLabel = UILabel()
    let nameStackView = UIStackView()
    let serialNumberStackView = UIStackView()
    let valueStackView = UIStackView()
    let formStackView = UIStackView()
    let adaptiveStackView = UIStackView()
    var toolbar = UIToolbar()
    
    // MARK: Formatters
    
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
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nameTextField.text = item.name
        serialNumberTextField.text = item.serialNumber
        valueTextField.text = numberFormatter.string(from: NSNumber(value: item.valueInDollars))
        dateCreatedLabel.text = dateFormatter.string(from: item.dateCreated)
        let itemKey = item.itemKey
        imageView.image = imageStore.image(forKey: itemKey)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let name = nameTextField.text ?? ""
        let value = numberFormatter.number(from: valueTextField.text!)?.intValue ?? 0
        let serialNumber = serialNumberTextField.text
        item.acceptChanges(newName: name, newValue: value, newSerialNumber: serialNumber)
        delegate?.didFinishEditing(self)
        view.endEditing(true)
    }
    
    // MARK: -  Adaptive interface (traitcollection) delegate methods
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        if newCollection.verticalSizeClass == .compact {
            // Change the axis and distribution of the adaptive stack view to display the form stack
            // view and the image side by side with equal width
            adaptiveStackView.axis = .horizontal
            adaptiveStackView.distribution = .fillEqually
        } else {
            // Change the axis and distribution of the adaptive stack view to display the form stack
            // view above the image with distribution set to fill
            adaptiveStackView.axis = .vertical
            adaptiveStackView.distribution = .fill
        }
    }
    
    // MARK: - Text field delegate methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // TODO: - Find out why the keyboard is not dismissing
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - Image picker controller delegate methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Get picked image from info dictionary
        let image = info[.originalImage] as! UIImage
        // Store the image in the image store for the item's key
        imageStore.setImage(image, forKey: item.itemKey)
        // Put that image on the screen in the image view
        imageView.image = image
        // Take image picker off the screen - must call this dismiss method
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Actions
    
    @objc func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func choosePhotoSource(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.modalPresentationStyle = .popover
        alertController.popoverPresentationController?.barButtonItem = sender
        // Option to use camera to take a photo
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
                let imagePicker = self.imagePicker(for: .camera)
                self.present(imagePicker, animated: true, completion: nil)
            }
            alertController.addAction(cameraAction)
        }
        // Option to use photo library to select a photo
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { _ in
            let imagePicker = self.imagePicker(for: .photoLibrary)
            imagePicker.modalPresentationStyle = .popover
            self.present(imagePicker, animated: true, completion: nil)
        }
        alertController.addAction(photoLibraryAction)
        // Option to cancel photo selection
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        // Present the alert controller
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Methods
    
    fileprivate func imagePicker(for sourceType: UIImagePickerController.SourceType) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        return imagePicker
    }
    
    
}

// MARK: - Extension detail view vontroller

extension DetailViewController {
    
    // MARK: Setup
    
    fileprivate func setup() {
        configure(self.view)
        configureLabels()
        configureFormStack()
        configureFormStacks()
        configureImageView()
        configureAdaptiveStack()
        configureToolbar()
        configureTextFields()
    }
    
    // MARK: Configure main view
    
    fileprivate func configure(_ view: UIView) {
        view.backgroundColor = .primaryBrandFillColor
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backgroundTapped(_:))))
    }
    
    // MARK: Configure labels
    
    fileprivate func configureLabels() {
        configure(dateCreatedLabel, withLabelText: "Date Created", andTextAlignment: .center, isLowPriority: true)
        let labels = [nameLabel, serialNumberLabel, valueLabel]
        let labelText = ["Name", "Serial", "Value"]
        for index in 0 ..< labels.count {
            configure(labels[index], withLabelText: labelText[index], andTextAlignment: .left)
        }
    }
    
    // MARK: Configure text fields
    
    fileprivate func configureTextFields() {
        let textFields = [nameTextField, serialNumberTextField, valueTextField]
        for textField in textFields {
            configure(textField, withBorderStyle: .roundedRect)
        }
        NSLayoutConstraint.activate([
            // TODO: - Find out why the text for nameLabel is getting trancated when the two layout constraints below are enabled
            serialNumberTextField.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            valueTextField.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor)
        ])
    }
    
    // MARK: Configure stack views
    
    fileprivate func configureFormStacks() {
        let labels = [nameLabel, serialNumberLabel, valueLabel]
        let textFields = [nameTextField, serialNumberTextField, valueTextField]
        let stackViews = [nameStackView, serialNumberStackView, valueStackView]
        for index in 0 ..< labels.count {
            configure(stackViews[index], withAxis: .horizontal, andSpacing: 8)
            stackViews[index].insertArrangedSubview(labels[index], at: 0)
            stackViews[index].insertArrangedSubview(textFields[index], at: 1)
        }
    }
    
    fileprivate func configureFormStack() {
        configure(formStackView, withAxis: .vertical, andSpacing: 8)
        let views = [nameStackView, serialNumberStackView, valueStackView, dateCreatedLabel]
        for view in views {
            formStackView.addArrangedSubview(view)
        }
    }
    
    fileprivate func configureAdaptiveStack() {
        let axis: NSLayoutConstraint.Axis = UITraitCollection.current.horizontalSizeClass == .compact ? .vertical : .horizontal
        let distribution: UIStackView.Distribution = UITraitCollection.current.horizontalSizeClass == .compact ? .fill : .fillEqually
        configure(adaptiveStackView, withAxis: axis, withDistribution: distribution, andSpacing: 8)
        let views = [formStackView, imageView]
        for view in views {
            adaptiveStackView.addArrangedSubview(view)
        }
        view.addSubview(adaptiveStackView)
        let margins = view.layoutMarginsGuide
        NSLayoutConstraint.activate([
            adaptiveStackView.topAnchor.constraint(equalTo: margins.topAnchor, constant: 8),
            adaptiveStackView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            adaptiveStackView.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        ])
    }
    
    // MARK: Configure image view
    
    fileprivate func configureImageView() {
        configure(imageView, withContentMode: .scaleAspectFit)
    }
    
    // MARK: Configure tool bar
    
    fileprivate func configureToolbar() {
        configure(toolbar)
    }
    
    // MARK: View configuration methods
    
    fileprivate func configure(_ imageView: UIImageView, withContentMode contentMode: UIView.ContentMode) {
        imageView.contentMode = contentMode
        imageView.setContentHuggingPriority(.defaultLow, for: .vertical)
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        imageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    fileprivate func configure(_ toolbar: UIToolbar) {
        toolbar.items = [UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(choosePhotoSource(_:)))]
        toolbar.barTintColor = .secondaryBrandFillColor
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(toolbar)
        toolbar.topAnchor.constraint(equalTo: adaptiveStackView.bottomAnchor, constant: 8).isActive = true
        toolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        toolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        toolbar.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor).isActive = true
    }
    
    fileprivate func configure(_ label: UILabel, withLabelText text: String, andTextAlignment alignment: NSTextAlignment, isLowPriority: Bool = false) {
        label.text = text
        label.textAlignment = alignment
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        if isLowPriority {
            label.setContentHuggingPriority(.defaultLow, for: .vertical)
        }
        label.translatesAutoresizingMaskIntoConstraints = false
    }
    
    fileprivate func configure(_ textField: UITextField, withBorderStyle borderStyle: UITextField.BorderStyle) {
        textField.backgroundColor = .tertiarySystemFill
        textField.borderStyle = borderStyle
        textField.delegate = self
        textField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        textField.translatesAutoresizingMaskIntoConstraints = false
    }
    
    fileprivate func configure(_ stackView: UIStackView, withAxis axis: NSLayoutConstraint.Axis, withDistribution distribution: UIStackView.Distribution = .fill, andSpacing spacing: CGFloat) {
        stackView.axis = axis
        stackView.distribution = distribution
        stackView.spacing = spacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
}
