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
        label.text = "Bubble sort"
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
        button.setImage(UIImage(systemName: "play"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        return button
    }()

    private lazy var generateRandomButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 22
        button.backgroundColor = .tertiarySystemGroupedBackground
        button.setImage(UIImage(systemName: "wand.and.rays"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.blue, for: .selected)
        button.addTarget(self, action: #selector(generateRandomTapped(_:)), for: .touchUpInside)
        return button
    }()


    private let infoView = InfoView(frame: .zero)

    private var elements: [Int] = [5,4,3,2,1,0]

    private var unsortedElements: [Int] = []

    private var isCellsEditing: Bool = false

    private var isCellsSorted: Bool = false

    private var timer: Timer?



    // MARK: - VC LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupConstraints()
        
        collectionView.delegate = self
        collectionView.dataSource = self

        startButton.isEnabled = false
        startButton.backgroundColor = .systemBlue.withAlphaComponent(0.7)
        generateRandomButton.isEnabled = false
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

    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = elements.remove(at: sourceIndexPath.row)
        elements.insert(item, at: destinationIndexPath.row)
    }
}

// MARK: - Sort animating logic
extension ViewController {
    private func startBubleSort() {
        unsortedElements = elements
        elements = []
        var elementsOnOwnPosition = 0
        let visibleCells = collectionView.visibleCells as! [ElementCell]
        visibleCells.forEach { cell in
            let value = Int(cell.valueTextField.text ?? "") ?? 0
            print("val: \(value)")
            elements.append(value)
        }

        elements = BubbleSorter.altBubleSort(elements, completion: { firstElIndex, secondElIndex, isEnded, isCircleEnded   in

            if isCircleEnded {
                print("Circle is Ended")
                elementsOnOwnPosition += 1
            }

            let index1 = IndexPath(item: firstElIndex, section: 0)
            let index2 =  IndexPath(item: secondElIndex, section: 0)

            guard let cell1 = self.collectionView.cellForItem(at: index1) as? ElementCell else { return }
            guard let cell2 = self.collectionView.cellForItem(at: index2) as? ElementCell else { return }

            cell1.shake()

            UIView.animate(withDuration: TimeInterval(BubbleSorter.bubbleSortSpeed / 2)) {
                cell1.backgroundColor = .systemBlue
                cell2.backgroundColor = .systemBlue
            }

            self.collectionView.moveItem(at: index2, to: index1)

            for (index, cell) in self.collectionView.visibleCells.enumerated() {
                if index < self.collectionView.visibleCells.count - elementsOnOwnPosition {
                    UIView.animate(withDuration: TimeInterval(BubbleSorter.bubbleSortSpeed)) {
                        cell.backgroundColor = .black
                    }
                } else  {
                    UIView.animate(withDuration: TimeInterval(BubbleSorter.bubbleSortSpeed)) {
                        cell.backgroundColor = .systemGreen
                    }
                }
            }

            if isEnded {
                self.collectionView.visibleCells.forEach { cell in
                    UIView.animate(withDuration: TimeInterval(BubbleSorter.bubbleSortSpeed) / 2, delay: 0.5) {
                        cell.backgroundColor = .systemGreen
                    }
                }
                if !self.isCellsSorted {
                    UIView.animate(withDuration: 0.3, delay: 0.7) {
                        self.startButton.isEnabled = true
                        self.segmentedControl.isUserInteractionEnabled = true
                        self.startButton.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
                        self.startButton.backgroundColor = .systemYellow
                        self.isCellsSorted.toggle()
                        self.toggleCellsEditing()
                    }
                }
            }
        })
    }
}

// MARK: - ProgressView
extension ViewController {
    private func startProgressView() {
        var timeInterval = 0.13
        switch segmentedControl.selectedItem.speedType {
            case .slow: timeInterval = 0.39
            case .medium: timeInterval = 0.13
            case .fast: timeInterval = 0.07
            case .none: timeInterval = 0.13
        }
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true, block: { _ in
            self.animateLoading()
        })
    }

    private func animateLoading() {
        infoView.updateProgress()
        if (infoView.progressView.progress >= 1) {
            self.timer?.invalidate()
        }
    }
}

// MARK: - Editing cells
extension ViewController {
    private func toggleCellsEditing() {
        let visibleCells = collectionView.visibleCells as! [ElementCell]
        visibleCells.forEach { cell in
            cell.valueTextField.isUserInteractionEnabled.toggle()
        }
    }
}

// MARK: - Actions
extension ViewController {
    @objc func buttonTapped(_ sender: UIButton) {
        if isCellsSorted {
            restartElements()
            return
        }

        toggleCellsEditing()
        UIView.animate(withDuration: 0.3) {
            self.startButton.isEnabled = false
            self.generateRandomButton.isEnabled = false
            self.segmentedControl.isUserInteractionEnabled = false
            self.startButton.backgroundColor = .systemBlue.withAlphaComponent(0.7)
        }
        startBubleSort()
        startProgressView()
    }

    private func restartElements() {
        elements = unsortedElements
        collectionView.reloadData()

        UIView.animate(withDuration: 0.3) {
            self.startButton.isEnabled = false
            self.startButton.backgroundColor = .systemBlue
            self.startButton.setImage(UIImage(systemName: "play"), for: .normal)
            self.isCellsSorted.toggle()
            self.toggleCellsEditing()
        }

        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { _ in
            self.infoView.resetProgress()
            if (self.infoView.progressView.progress <= 0) {
                self.timer?.invalidate()
                self.startButton.isEnabled = true
                self.generateRandomButton.isEnabled = true
            }
        })
    }

    @objc private func handleSegmentedControl(_ sender: CustomSegmentedControl) {
        BubbleSorter.changeBubleSortSpeed(for: segmentedControl.selectedItem.speedType ?? .medium)

        UIView.animate(withDuration: 0.3) {
            self.startButton.isEnabled = true
            self.startButton.backgroundColor = .systemBlue
            self.generateRandomButton.isEnabled = true
        }
    }

    @objc private func generateRandomTapped(_ sender: UIButton) {
        elements = Elements.getRandomElements(for: 6)
        unsortedElements = elements
        collectionView.reloadData()
        startButton.isEnabled = true
        startButton.backgroundColor = .systemBlue
    }
}

// MARK: - UI + Constraints
extension ViewController {
    private func setupConstraints() {
        view.addSubviewsWithMask([ collectionView, startButton, generateRandomButton, segmentedControl, titleLabel, infoView ])

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

            infoView.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            infoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            infoView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            startButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80),
            startButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            startButton.trailingAnchor.constraint(equalTo: generateRandomButton.leadingAnchor, constant: -20),
            startButton.heightAnchor.constraint(equalToConstant: 44),

            generateRandomButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            generateRandomButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80),
            generateRandomButton.heightAnchor.constraint(equalToConstant: 44),
            generateRandomButton.widthAnchor.constraint(equalToConstant: 44),
        ])
    }
}
