//
//  InfoView.swift
//  SortingAnimator
//
//  Created by Robert Miller on 16.12.2022.
//

import UIKit

class InfoView: UIView {
    private let circlesLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        label.text = "Bubble sort"
        return label
    }()

    override init(frame: CGRect) {
        self.init()
        print("ss")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI
extension InfoView {

}
