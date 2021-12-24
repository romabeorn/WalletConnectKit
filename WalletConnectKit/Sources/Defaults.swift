//
//  Defaults.swift
//  WalletConnectKit
//
//  Created by Overcout on 24.12.2021.
//

import Foundation

/// UserDefaults Wrapper
///
/// - sessionCurrent: Current session's data
/// - sessions: Session's data list
@propertyWrapper enum Defaults<T>: String {
    
    case sessionCurrent
    case sessions

    // MARK: - Private Properties

    private var storage: UserDefaults { .standard }

    // MARK: - PropertyWrapper

    var wrappedValue: T? {
        get { return storage.value(forKey: rawValue) as? T }
        set { storage.setValue(newValue, forKey: rawValue) }
    }

    // MARK: - Init

    /// Инициализатор
    /// - Parameter key: Ключ
    init(key: Defaults) { self = key }
}
