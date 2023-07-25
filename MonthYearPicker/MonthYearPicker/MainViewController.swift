//
//  ViewController.swift
//  MonthYearPicker
//
//  Created by AlexBezkopylnyi on 25.07.2023.
//

import UIKit

class MainViewController: UIViewController {
    
    private let containerView = UIView()
    private let datePicker = MonthYearPicker()
    private let textField = UITextField()
    
    private lazy var dateFormatter: DateFormatter = {
       let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        return dateFormatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

private extension MainViewController {
    func setupUI() {
        view.backgroundColor = .systemGray3
        view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.view.centerYAnchor),
            containerView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        setupDatePicker()
        setupTextField()
        setupToolbar()
    }
    
    func setupDatePicker() {
        datePicker.onDateSelected = { [weak self] (month, year) in
            guard let _ = self else { return }
            let newDate = Date().set(year: year, month: month)
            self?.updateTextField(with: newDate)
        }
    }
    
    func setupTextField() {
        containerView.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            textField.heightAnchor.constraint(equalToConstant: 35),
            textField.topAnchor.constraint(equalTo: containerView.topAnchor)
        ])
        textField.inputView = datePicker
        textField.borderStyle = .roundedRect
        textField.delegate = self
        textField.placeholder = "Pick your date"
    }
    
    func updateTextField(with newDate: Date) {
        textField.text = dateFormatter.string(from: newDate)
    }
    
    func setupToolbar() {
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonAction))
        let title = UIBarButtonItem(title: "Select Month and Year", style: .plain, target: nil, action: nil)
        title.isEnabled = false
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let toolBar = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
        toolBar.setItems([flexibleSpace, title, flexibleSpace, doneButton], animated: true)
        textField.inputAccessoryView = toolBar
    }
    
    @objc func doneButtonAction() {
        textField.resignFirstResponder()
    }
}

extension MainViewController: UITextFieldDelegate {
    
}
