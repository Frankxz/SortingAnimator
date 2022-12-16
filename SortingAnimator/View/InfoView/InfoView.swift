//
//  InfoView.swift
//  SortingAnimator
//
//  Created by Robert Miller on 16.12.2022.
//

import UIKit

class InfoView: UIView {
    private let progressValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .medium)
        label.textColor = .black
        label.textAlignment = .center
        label.text = "0%"
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .regular)
        label.textColor = .black
        label.textAlignment = .center
        label.text = "Waiting to start sorting"
        return label
    }()

    public let progressView = CustomProgressView(frame: .zero)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
        progressView.color = .systemGreen
        print("sss")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Update progress
extension InfoView {
    public func updateProgress() {
        if progressView.progress < 1 {
            progressView.progress += 0.01
            progressValueLabel.text = "\(Int(progressView.progress * 100))%"
            descriptionLabel.text = "Sorting in progress..."
        } else {
            progressValueLabel.text = "100%"
            descriptionLabel.text = "Successfully sorted."
        }
    }
}

// MARK: - UI + COnstraints
extension InfoView {
    private func setupView() {
        progressView.color = .systemGreen
        self.layer.borderColor = UIColor.orange.cgColor
        self.layer.borderWidth = 2
        self.layer.cornerRadius = 16
    }

    private func setupConstraints() {
        addSubviewsWithMask([progressView, progressValueLabel, descriptionLabel])
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            progressView.centerXAnchor.constraint(equalTo: centerXAnchor),
            progressView.widthAnchor.constraint(equalToConstant: 100),
            progressView.heightAnchor.constraint(equalToConstant: 100),

            progressValueLabel.centerXAnchor.constraint(equalTo: progressView.centerXAnchor),
            progressValueLabel.centerYAnchor.constraint(equalTo: progressView.centerYAnchor),

            descriptionLabel.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
        ])
    }
}
