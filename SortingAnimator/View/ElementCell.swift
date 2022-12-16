//
//  ElementCell.swift
//  SortingAnimator
//
//  Created by Robert Miller on 15.12.2022.
//

import UIKit

class ElementCell: UICollectionViewCell {
    // MARK: - Properties
    public let valueTextField: UITextField = {
        let textfield = UITextField()
        textfield.textColor = .white
        textfield.keyboardType = .asciiCapableNumberPad
        textfield.font = .systemFont(ofSize: 16, weight: .heavy)

        return textfield
    }()

    // MARK: - Inits
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupConstraints()
        layer.cornerRadius = 18
        layer.masksToBounds = true
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 2
        valueTextField.delegate = self
        addDoneButtonOnKeyboard()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configuring cell
    func configure(with value: UInt32) {
        valueTextField.text = "\(value)"
    }

    private func configureView() {
        layer.cornerRadius = frame.size.width / 2
        layer.masksToBounds = true
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 2
    }
}

// MARK: - UI + Constraints
extension ElementCell {
    private func setupConstraints() {
        addSubview(valueTextField)
        valueTextField.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            valueTextField.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            valueTextField.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
}

// MARK: - KeyBoard
extension ElementCell: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        let numberOfChars = newText.count
        return numberOfChars <= 3
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == "" {
            textField.text = "0"
        }
    }

    func addDoneButtonOnKeyboard(){
            let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
            doneToolbar.barStyle = .default

            let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))

            let items = [flexSpace, done]
            doneToolbar.items = items
            doneToolbar.sizeToFit()

            valueTextField.inputAccessoryView = doneToolbar
        }

        @objc func doneButtonAction(){
            valueTextField.resignFirstResponder()
        }

}
