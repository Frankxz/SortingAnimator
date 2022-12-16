//
//  Elements.swift
//  SortingAnimator
//
//  Created by Robert Miller on 15.12.2022.
//

import Foundation

class Elements {
    static func getRandomElements(for size: Int)->[Int] {
        let uint32Array = (1...size).map{_ in arc4random_uniform(100)}
        var intArray: [Int] = []
        uint32Array.forEach { num in
            intArray.append(Int(num))
        }
        return intArray
    }
}
