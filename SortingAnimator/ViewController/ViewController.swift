//
//  ViewController.swift
//  SortingAnimator
//
//  Created by Robert Miller on 15.12.2022.
//

import UIKit

class ViewController: UIViewController {
    // MARK: - Properties
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        label.text = "Choose sort type"
        return label
    }()

    private lazy var segmentedControl: CustomSegmentedControl = {
        let items = [
            SpeedTypeButton(speedType: .slow),
            SpeedTypeButton(speedType: .medium),
            SpeedTypeButton(speedType: .fast)
        ]
        let control = CustomSegmentedControl(frame: CGRect(x: 0, y: 0, width: 400, height: 100), items: items)
        control.items.forEach { btn in
            btn.addTarget(self, action: #selector(handleSegmentedControl(_:)), for: .touchUpInside)
        }
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()

    private let collectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 8
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(ElementCell.self, forCellWithReuseIdentifier: "cell")
        cv.backgroundColor = .clear
        return cv
    }()

    private lazy var startButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 16
        button.backgroundColor = .systemBlue
        button.setTitle("Start", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        return button
    }()

    private lazy var restartButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 22
        button.backgroundColor = .tertiarySystemGroupedBackground
        button.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.blue, for: .selected)
        button.addTarget(self, action: #selector(restartButtonTapped(_:)), for: .touchUpInside)
        return button
    }()

    private lazy var editButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 22
        button.backgroundColor = .tertiarySystemGroupedBackground
        button.setImage(UIImage(systemName: "pencil"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.blue, for: .selected)
        button.addTarget(self, action: #selector(restartButtonTapped(_:)), for: .touchUpInside)
        return button
    }()

    private var elements: [UInt32] = [5,4,3,2,1,0]

    // MARK: - VC LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupConstraints()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

// MARK: - UI + Constraints
extension ViewController {
    private func setupConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        startButton.translatesAutoresizingMaskIntoConstraints = false
        restartButton.translatesAutoresizingMaskIntoConstraints = false
        editButton.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(collectionView)
        view.addSubview(startButton)
        view.addSubview(restartButton)
        view.addSubview(editButton)
        view.addSubview(segmentedControl)
        view.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            segmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            segmentedControl.heightAnchor.constraint(equalToConstant: 100),

            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            collectionView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            collectionView.heightAnchor.constraint(equalToConstant: 60),

            startButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80),
            startButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            startButton.trailingAnchor.constraint(equalTo: restartButton.leadingAnchor, constant: -20),
            startButton.heightAnchor.constraint(equalToConstant: 44),

            restartButton.trailingAnchor.constraint(equalTo: editButton.leadingAnchor, constant: -20),
            restartButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80),
            restartButton.heightAnchor.constraint(equalToConstant: 44),
            restartButton.widthAnchor.constraint(equalToConstant: 44),

            editButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            editButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80),
            editButton.heightAnchor.constraint(equalToConstant: 44),
            editButton.widthAnchor.constraint(equalToConstant: 44),
        ])
    }
}

// MARK: - CollectionView DataSource
extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        elements.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ElementCell
        cell.layer.masksToBounds = true
        cell.backgroundColor = .black
        cell.configure(with: elements[indexPath.row])

        return cell
    }
}

// MARK: - CollectionView FLOW LAYOUT
extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sideSize = (Int(collectionView.frame.width) - 10) / elements.count
        return CGSize(width: sideSize, height: sideSize)
    }
}

// MARK: - Sort Actions
extension ViewController {
    @objc func buttonTapped(_ sender: UIButton) {
        switch segmentedControl.selectedItem.speedType {
        case .slow:
            startBubleSort()
        case .medium:
            titleLabel.text = ""
        default:
            titleLabel.text = "CHOSE TYPE !!!"
        }
    }

    @objc func restartButtonTapped(_ sender: UIButton) {
        elements = [5,6,3,2,1,0]
        collectionView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = elements.remove(at: sourceIndexPath.row)
        elements.insert(item, at: destinationIndexPath.row)
    }

    private func startBubleSort() {
        elements = []
        var elementsOnOwnPosition = 0
        let visibleCells = collectionView.visibleCells as! [ElementCell]
        visibleCells.forEach { cell in
            let value = Int(cell.valueTextField.text ?? "") ?? 0
            print("val: \(value)")
            elements.append(UInt32(value))
        }
       // collectionView.reloadData()
        elements = elements.altBubleSort(elements, completion: { firstElIndex, secondElIndex, isEnded, isCircleEnded   in

            if isCircleEnded {
                print("Circle is Ended")
                elementsOnOwnPosition += 1
            }

            let index1 = IndexPath(item: firstElIndex, section: 0)
            let index2 =  IndexPath(item: secondElIndex, section: 0)

            guard let cell1 = self.collectionView.cellForItem(at: index1) as? ElementCell else { return }
            guard let cell2 = self.collectionView.cellForItem(at: index2) as? ElementCell else { return }

            cell1.shake()

            UIView.animate(withDuration: 0.45) {
                cell1.backgroundColor = .systemBlue
                cell2.backgroundColor = .systemBlue
            }

            UIView.animate(withDuration: 0.1, delay: 0.3) {
                self.collectionView.moveItem(at: index2, to: index1)

            }

            for (index, cell) in self.collectionView.visibleCells.enumerated() {
                if index < self.collectionView.visibleCells.count - elementsOnOwnPosition {
                    UIView.animate(withDuration: 0.55) {
                        cell.backgroundColor = .black
                    }
                } else  {
                    UIView.animate(withDuration: 0.55) {
                        cell.backgroundColor = .systemGreen
                    }
                }
            }

            if isEnded {
                self.collectionView.visibleCells.forEach { cell in
                    UIView.animate(withDuration: 0.25, delay: 0.5) {
                        cell.backgroundColor = .systemGreen
                    }
                }
            }
        })
        elements.forEach { el in
            print("\(el)")
        }

    }
}

// MARK: - SegmentedControl Action
extension ViewController {
    @objc private func handleSegmentedControl(_ sender: CustomSegmentedControl) {
        UIView.animate(withDuration: 0.2) { [weak self] in
            switch self?.segmentedControl.selectedItem.speedType {
            case .slow:
                self?.titleLabel.text = "Slow speed"
            case .medium:
                self?.titleLabel.text = "Medium speed"
            case .fast:
                self?.titleLabel.text = "Fast speed"
            case .none:
                self?.titleLabel.text = "Choose speed type"
            }
        }
    }
}
