//
//  Int.swift
//  IMChat
//
//  Created by Ma7rous on 16/10/2022.
//

import Foundation

extension Int {
    func IMfromatSecondsFromTimer() -> String {
        let minutes = Int(self) / 60 % 60
        let seconds = Int(self) % 60
        return String(format: "%02i:%02i", minutes, seconds)
    }
}
