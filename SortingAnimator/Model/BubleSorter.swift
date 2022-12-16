//
//  BubleSort.swift
//  SortingAnimator
//
//  Created by Robert Miller on 15.12.2022.
//

import Foundation

struct BubbleSorter {
    static var bubbleSortSpeed: Double = 500

    // MARK: - Sort logic
    static func altBubleSort(_ arr: [UInt32], completion: @escaping (_ firstElIndex: Int, _ secondElIndex: Int, _ isEnded: Bool, _ isCircleIterationEnded: Bool)->()) -> [UInt32] {
        guard arr.count > 1 else {return arr}
        var sortedArray = arr

        for i in 0..<sortedArray.count {
            for j in 0..<sortedArray.count-i-1 {
                let circleDelay = (sortedArray.count * i * Int(bubbleSortSpeed * 1000))
                let delay = (j * (Int(bubbleSortSpeed * 1000))) + circleDelay
                if sortedArray[j] > sortedArray[j + 1] {
                    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(delay)) {
                        let isEnded = (i >= sortedArray.count - 2)
                        let isCircleIterationEnded = (j == sortedArray.count - i - 2)
                        completion(j + 1, j, isEnded, isCircleIterationEnded)
                    }
                    sortedArray.swapAt(j + 1, j)
                }
            }
        }

        return sortedArray
    }

    // MARK: - Speed configuration
    static func changeBubleSortSpeed(for speedType: SpeedType) {
        switch speedType {
        case .slow: bubbleSortSpeed = 1.5
        case .medium: bubbleSortSpeed = 0.5
        case .fast: bubbleSortSpeed = 0.25
        }
    }
}
