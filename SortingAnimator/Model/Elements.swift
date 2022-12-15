//
//  Elements.swift
//  SortingAnimator
//
//  Created by Robert Miller on 15.12.2022.
//

import Foundation

class Elements {
    static func getRandomElements(for size: Int)->[UInt32] {
        var randomArray = (1...size).map{_ in arc4random_uniform(100)}
        randomArray.forEach { num in
            print("\(num)")
        }
        return randomArray
    }
}
