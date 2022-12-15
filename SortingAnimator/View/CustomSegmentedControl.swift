//
//  CustomSegmentedControl.swift
//  SortingAnimator
//
//  Created by Robert Miller on 15.12.2022.
//

import UIKit

class CustomSegmentedControl: UIView {

    public var items = [SpeedTypeButton]()
    public var buttons = [SpeedTypeButton]()
    public var selectedItem = SpeedTypeButton(speedType: .medium)

    private let selectedItemTextColor = UIColor.white
    private let unselectedItemTextColor = UIColor.darkGray
    private let selectedItemViewColor = UIColor.systemPurple

    override func draw(_ rect: CGRect) {

    }

    init(frame: CGRect, items: [SpeedTypeButton]) {
        super.init(frame: frame)
        self.items = items
        setupView()
        updateView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundColor = .clear
        layer.cornerRadius = 10
        layer.masksToBounds = true
    }

    func updateView() {
        buttons.removeAll()
        subviews.forEach { $0.removeFromSuperview()}

        items.forEach { item in
            item.addTarget(self, action: #selector(changeSelectedItem(button:)), for: .touchUpInside)
            item.heightAnchor.constraint(equalToConstant: 100).isActive = true
            buttons.append(item)
        }
        buttons.first?.setTitleColor(selectedItemTextColor, for: .normal)

        selectedItem = buttons.first ?? selectedItem
        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }

    @objc func changeSelectedItem(button: SpeedTypeButton) {
        for (buttonIndex, btn) in buttons.enumerated() {
            btn.layer.borderColor = UIColor.systemGray2.cgColor
            btn.speedLabel.textColor = UIColor.systemGray2
            btn.setAttributedTitle(
                NSAttributedString(
                    string: (btn.titleLabel?.text!)!,
                    attributes: [
                        .font: UIFont.systemFont(ofSize: 16, weight: .bold),
                        .foregroundColor: UIColor.systemGray2 ]),
                for: .normal)

            if btn == button {
                selectedItem = btn
                let selectorStartPosition = frame.width /  CGFloat(buttons.count) * CGFloat(buttonIndex)
                UIView.animate(withDuration: 0.3) {
                    button.layer.borderColor = UIColor.systemBlue.cgColor
                    button.speedLabel.textColor = UIColor.black
                    btn.setAttributedTitle(
                        NSAttributedString(
                            string: (btn.titleLabel?.text!)!,
                            attributes: [
                                .font: UIFont.systemFont(ofSize: 16, weight: .bold),
                                .foregroundColor: UIColor.black ]),
                        for: .normal)
                }
            }
        }
    }
}
