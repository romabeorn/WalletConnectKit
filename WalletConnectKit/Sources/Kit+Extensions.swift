//
//  Kit+Extensions.swift
//  WalletConnectKit
//
//  Created by Overcout on 24.12.2021.
//

import Foundation

extension DispatchQueue {

    static func main(_ action: @autoclosure @escaping () -> ()) {
        main(action)
    }

    static func main(_ action: @escaping () -> ()) {
        if Thread.isMainThread {
            action()
        } else {
            DispatchQueue.main.sync { action() }
        }
    }
}

extension String {

    static func ~= (lhs: String, rhs: String) -> Bool {
        guard let regex = try? NSRegularExpression(pattern: rhs) else { return false }
        let range = NSRange(location: 0, length: lhs.utf16.count)
        return regex.firstMatch(in: lhs, options: [], range: range) != nil
    }
}
