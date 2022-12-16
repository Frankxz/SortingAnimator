//
//  SortRectView.swift
//  SortingAnimator
//
//  Created by Robert Miller on 16.12.2022.
//

import UIKit

class SpeedTypeButton: UIButton {
    public var speedType: SpeedType?

    public let speedLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 28, weight: .heavy)
        label.textColor = .systemGray2
        label.textAlignment = .center
        return label
    }()

    init(speedType: SpeedType) {
        super.init(frame: .zero)
        self.speedType = speedType

        speedLabel.text = speedType.getSpeedTitle()
        setupButton(title: speedType.getTitle())

        setupConstraints()
        setupTitleOffset()
        layer.borderWidth = 2
        layer.borderColor = UIColor.systemGray2.cgColor
        tintColor = .systemGray2
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupButton(title: String) {
        setAttributedTitle(
            NSAttributedString(
                string: title,
                attributes: [
                    .font: UIFont.systemFont(ofSize: 16, weight: .bold),
                    .foregroundColor: UIColor.systemGray2 ]),
            for: .normal)

        layer.cornerRadius = 16
        backgroundColor = .clear
        tintColor = .black
    }

    private func setupTitleOffset() {
        contentHorizontalAlignment = .center
        contentVerticalAlignment = .bottom
    }

    private func setupConstraints() {
        addSubview(speedLabel)
        speedLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            speedLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            speedLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
}

enum SpeedType {
    case slow
    case medium
    case fast

    func getTitle() -> String {
        "\(self)".uppercased()
    }

    func getSpeedTitle() -> String {
        switch self {
        case .slow:
            return "0.5x"
        case .medium:
            return "1x"
        default:
            return "2x"
        }

    }
}
