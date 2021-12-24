//
//  WalletConnectServiceProtocol.swift
//  WalletConnectKit
//
//  Created by Overcout on 24.12.2021.
//

import WalletConnectSwift

/// Kit Service to connect with the bridge via Wallect Connect 1.x.x framework
/// To continue connection with any wallet on iOS call the deeplink of wallet app, after initiating connection to bridge
public protocol WalletConnectServiceProtocol {

    // MARK: - Wallet Connect
    
    /// Wallet Connect default delegate object
    var delegate: ClientDelegate? { get set }
    
    /// Wallet Connect Client current instance
    var client: Client? { get }

    // MARK: - Delegate
    
    /// Service delegate object
    var serviceDelegate: WalletConnectServiceDelegate? { get set }

    // MARK: - Providers

    /// Wallet Connect bridge data provider
    var bridgeProvider: BridgeProviderProtocol { get }
    
    /// dApp technical data provider
    var dAppInfoProvider: DAppInfoProviderProtocol { get }
    
    ///  dApp business data provider
    var clientMetaProvider: ClientMetaProviderProtocol { get }

    // MARK: - Storage

    /// Wallet Connect session storage
    var sessionStorage: SessionStorageProtocol { get }
    
    // MARK: - Management
    
    /// Initiate connection from dApp. Starting a handshake
    func connect() throws
    
    /// Reconnect with current session. Notifying the bridge about user's desire to restore session
    func reconnect() throws
    
    /// Disconnect with current session. Notifying the bridge about user's desire to disconnect
    func disconnect() throws
}
