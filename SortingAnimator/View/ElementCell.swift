//
//  ElementCell.swift
//  SortingAnimator
//
//  Created by Robert Miller on 15.12.2022.
//

import UIKit

class ElementCell: UICollectionViewCell {
    // MARK: - Properties
    public let valueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 16, weight: .heavy)
        return label
    }()

    // MARK: - Inits
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupConstraints()
        layer.cornerRadius = frame.size.width / 2
        layer.masksToBounds = true
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 2
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configuring cell
    func configure(with value: UInt32) {
        valueLabel.text = "\(value)"

    }
}

// MARK: - UI + Constraints
extension ElementCell {
    private func setupConstraints() {
        addSubview(valueLabel)
        valueLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            valueLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            valueLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }

}
