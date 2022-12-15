//
//  BubleSort.swift
//  SortingAnimator
//
//  Created by Robert Miller on 15.12.2022.
//

import Foundation

extension Array where Element: Comparable {

    func altBubleSort(_ arr: [UInt32], completion: @escaping (_ firstElIndex: Int, _ secondElIndex: Int, _ isEnded: Bool, _ isCircleIterationEnded: Bool)->()) -> [UInt32] {
        guard arr.count > 1 else {return arr}
        var sortedArray = arr
        for i in 0..<sortedArray.count {
            for j in 0..<sortedArray.count-i-1 {
                let delay = (j * 500) + (sortedArray.count * i * 500)
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(delay)) {
                    print("SWIPING \(i) \(j)")
                    let isEnded = (i >= sortedArray.count - 2)
                    let isCircleIterationEnded = (j == sortedArray.count-i-2)
                    completion(j + 1, j, isEnded, isCircleIterationEnded)
                }
                if sortedArray[j]>sortedArray[j + 1] {
                    sortedArray.swapAt(j + 1, j)
                }
            }
        }

        return sortedArray
    }

    func swap<T: Comparable>(left: inout T, right: inout T) {
        print("Swapping \(left) and \(right)")
        let temp = right
        right = left
        left = temp
    }

}
