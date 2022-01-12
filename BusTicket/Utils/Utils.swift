//
//  Utils.swift
//  BusTicket
//
//  Created by Jithin on 12/01/22.
//

import Foundation

struct Utils {
    static func getRandomBool() -> Bool {
        let randomValue = Int.random(in: 1...4)
        return randomValue == 1
    }
}
