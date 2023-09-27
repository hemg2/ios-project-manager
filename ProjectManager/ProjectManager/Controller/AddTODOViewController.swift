//
//  AddTODOViewController.swift
//  ProjectManager
//
//  Created by Hemg on 2023/09/26.
//

import UIKit

protocol AddTodoDelegate: AnyObject {
    func didAddTodoItem(title: String, body: String, date: Date)
}

final class AddTODOViewController: UIViewController {
    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = .preferredFont(forTextStyle: .title1)
        textField.placeholder = "Title"
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1.0
        
        return textField
    }()
    
    private let bodyTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .preferredFont(forTextStyle: .body)
        textView.text = "여기는 할일 내용 입력하는 곳입니다."
        textView.textColor = .placeholderText
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 1.0
        
        return textView
    }()
    
    private let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        
        return datePicker
    }()
    
    weak var delegate: AddTodoDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViewController()
        setUpBarButtonItem()
        configureUI()
        setUpViewLayout()
    }
    
    private func setUpViewController() {
        view.backgroundColor = .systemBackground
        title = "TODO"
        bodyTextView.delegate = self
    }
    
    private func setUpBarButtonItem() {
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButton))
        navigationItem.rightBarButtonItem = doneButton
        
        let cancel = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancelButton))
        navigationItem.leftBarButtonItem = cancel
    }
    
    @objc private func doneButton() {
        setUpItemText()
        dismiss(animated: true)
    }
    
    @objc private func cancelButton() {
        dismiss(animated: true)
    }
    
    private func configureUI() {
        view.addSubview(titleTextField)
        view.addSubview(bodyTextView)
        view.addSubview(datePicker)
    }

    private func setUpViewLayout() {
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 4),
            titleTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -4),
            
            datePicker.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 4),
            datePicker.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 4),
            datePicker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -4),
            
            bodyTextView.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 4),
            bodyTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 4),
            bodyTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -4),
            bodyTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -4)
        ])
    }
    
    private func setUpItemText() {
        let date = datePicker.date
        guard let titleText = titleTextField.text,
              let bodyText = bodyTextView.text else {
            return
        }
        
        delegate?.didAddTodoItem(title: titleText, body: bodyText, date: date)
    }
}

extension AddTODOViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "여기는 할일 내용 입력하는 곳입니다." {
            textView.text = ""
            textView.textColor = .label
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "여기는 할일 내용 입력하는 곳입니다."
            textView.textColor = .placeholderText
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let changedText = currentText.replacingCharacters(in: stringRange, with: text)
        
        return changedText.count <= 999
    }
}
