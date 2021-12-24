//
//  WalletConnectService.swift
//  WalletConnectKit
//
//  Created by Overcout on 24.12.2021.
//

import Foundation
import WalletConnectSwift

/// Error's enumeration
///
/// - noCurrentSession: Error getting current session
public enum WalletConnectServiceError: Error {

    case noCurrentSession
}

/// Default Wallet Connect Service
public final class WalletConnectServiceDefault {
    
    // MARK: - WalletConnectServiceProtocol Properties
    
    public weak var serviceDelegate: WalletConnectServiceDelegate?
    
    public weak var delegate: ClientDelegate?
    
    public var client: Client?

    public let bridgeProvider: BridgeProviderProtocol

    public let dAppInfoProvider: DAppInfoProviderProtocol

    public let clientMetaProvider: ClientMetaProviderProtocol
    
    public let sessionStorage: SessionStorageProtocol

    // MARK: - Init
    
    /// Service Init
    /// - Parameters:
    ///   - sessionStorage: Wallet Connect session storage
    ///   - bridgeProvider: Wallet Connect bridge data provider
    ///   - dAppInfoProvider: dApp technical data provider
    ///   - clientMetaProvider: dApp business data provider
    public init(sessionStorage: SessionStorageProtocol,
         bridgeProvider: BridgeProviderProtocol,
         dAppInfoProvider: DAppInfoProviderProtocol,
         clientMetaProvider: ClientMetaProviderProtocol) {
        self.sessionStorage = sessionStorage
        self.bridgeProvider = bridgeProvider
        self.dAppInfoProvider = dAppInfoProvider
        self.clientMetaProvider = clientMetaProvider
    }
}

// MARK: - WalletConnectServiceProtocol

extension WalletConnectServiceDefault: WalletConnectServiceProtocol {

    public func connect() throws {
        let peerMeta = Session.ClientMeta(
            name: clientMetaProvider.name,
            description: clientMetaProvider.description,
            icons: clientMetaProvider.icons,
            url: clientMetaProvider.url,
            scheme: clientMetaProvider.scheme
        )
        let dAppInfo = Session.DAppInfo(
            peerId: dAppInfoProvider.peerId,
            peerMeta: peerMeta
        )
        let url = WCURL(
            topic: bridgeProvider.topic(),
            version: bridgeProvider.version(),
            bridgeURL: bridgeProvider.bridgeURL(),
            key: bridgeProvider.key()
        )
        DispatchQueue.main { self.serviceDelegate?.willConnect(to: url) }
        client = Client(delegate: self, dAppInfo: dAppInfo)
        try client?.connect(to: url)
    }

    public func reconnect() throws {
        guard let session = try sessionStorage.getCurrentSession() else {
            throw WalletConnectServiceError.noCurrentSession
        }
        client = Client(delegate: self, dAppInfo: session.dAppInfo)
        DispatchQueue.main { self.serviceDelegate?.willReconnect(to: session.url) }
        try client?.reconnect(to: session)
    }
    
    public func disconnect() throws {
        guard let session = try sessionStorage.getCurrentSession() else {
            throw WalletConnectServiceError.noCurrentSession
        }
        client = Client(delegate: self, dAppInfo: session.dAppInfo)
        DispatchQueue.main { self.serviceDelegate?.willDisconnect(from: session.url) }
        try client?.disconnect(from: session)
    }
}

// MARK: - ClientDelegate

extension WalletConnectServiceDefault: ClientDelegate {

    public func client(_ client: Client, didFailToConnect url: WCURL) {
        DispatchQueue.main { self.delegate?.client(client, didFailToConnect: url) }
    }
    
    public func client(_ client: Client, didConnect url: WCURL) {
        DispatchQueue.main { self.delegate?.client(client, didConnect: url) }
    }
    
    public func client(_ client: Client, didConnect session: Session) {
        try? sessionStorage.setCurrent(session: session)
        try? sessionStorage.append(session: session)
        DispatchQueue.main { self.delegate?.client(client, didConnect: session) }
    }
    
    public func client(_ client: Client, didDisconnect session: Session) {
        try? sessionStorage.setCurrent(session: session)
        try? sessionStorage.remove(session: session)
        DispatchQueue.main { self.delegate?.client(client, didDisconnect: session) }
    }
    
    public func client(_ client: Client, didUpdate session: Session) {
        try? sessionStorage.setCurrent(session: session)
        try? sessionStorage.updateCurrent(session: session)
        DispatchQueue.main { self.delegate?.client(client, didUpdate: session) }
    }
}
