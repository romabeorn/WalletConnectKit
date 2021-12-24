//
//  WalletConnectService.swift
//  WalletConnectKit
//
//  Created by Overcout on 24.12.2021.
//

import WalletConnectSwift

/// Error's enumeration
///
/// - noCurrentSession: Error getting current session
enum WalletConnectServiceError: Error {

    case noCurrentSession
}

/// Default Wallet Connect Service
final class WalletConnectServiceDefault {
    
    // MARK: - WalletConnectServiceProtocol Properties
    
    weak var serviceDelegate: WalletConnectServiceDelegate?
    
    weak var delegate: ClientDelegate?
    
    var client: Client?

    let bridgeProvider: BridgeProviderProtocol

    let dAppInfoProvider: DAppInfoProviderProtocol

    let clientMetaProvider: ClientMetaProviderProtocol
    
    let sessionStorage: SessionStorageProtocol

    // MARK: - Init
    
    /// Service Init
    /// - Parameters:
    ///   - sessionStorage: Wallet Connect session storage
    ///   - bridgeProvider: Wallet Connect bridge data provider
    ///   - dAppInfoProvider: dApp technical data provider
    ///   - clientMetaProvider: dApp business data provider
    init(sessionStorage: SessionStorageProtocol,
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

    func connect() throws {
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

    func reconnect() throws {
        guard let session = try sessionStorage.getCurrentSession() else {
            throw WalletConnectServiceError.noCurrentSession
        }
        client = Client(delegate: self, dAppInfo: session.dAppInfo)
        DispatchQueue.main { self.serviceDelegate?.willReconnect(to: session.url) }
        try client?.reconnect(to: session)
    }
    
    func disconnect() throws {
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

    func client(_ client: Client, didFailToConnect url: WCURL) {
        DispatchQueue.main { self.delegate?.client(client, didFailToConnect: url) }
    }
    
    func client(_ client: Client, didConnect url: WCURL) {
        DispatchQueue.main { self.delegate?.client(client, didConnect: url) }
    }
    
    func client(_ client: Client, didConnect session: Session) {
        try? sessionStorage.setCurrent(session: session)
        try? sessionStorage.append(session: session)
        DispatchQueue.main { self.delegate?.client(client, didConnect: session) }
    }
    
    func client(_ client: Client, didDisconnect session: Session) {
        try? sessionStorage.setCurrent(session: session)
        try? sessionStorage.remove(session: session)
        DispatchQueue.main { self.delegate?.client(client, didDisconnect: session) }
    }
    
    func client(_ client: Client, didUpdate session: Session) {
        try? sessionStorage.setCurrent(session: session)
        try? sessionStorage.updateCurrent(session: session)
        DispatchQueue.main { self.delegate?.client(client, didUpdate: session) }
    }
}
