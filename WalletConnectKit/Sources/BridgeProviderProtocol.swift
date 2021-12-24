//
//  BridgeProviderProtocol.swift
//  WalletConnectKit
//
//  Created by Overcout on 24.12.2021.
//

import Foundation

/// Wallect Connect bridge data provider
public protocol BridgeProviderProtocol {

    /// Random generated topic UUID
    func topic() -> String

    /// Brdige URL
    func bridgeURL() -> URL

    /// Random generated key
    func key() -> String

    /// Version of bridge URL
    func version() -> String
}
