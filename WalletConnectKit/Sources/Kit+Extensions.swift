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
