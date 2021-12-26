//
//  BSCDataSeed.swift
//  WalletConnectKit
//
//  Created by Overcout on 27.12.2021.
//

import Foundation

/// BSCDataSeed JSON RPC endpoint service
public final class BSCDataSeed: JSONRPCEndpointProtocol {

    // MARK: - BSCDataSeed Properties

    public var rpc: String = "https://bsc-dataseed.binance.org"
    
    public let idEnumerator: JSONRPCIdEnumeratorProtocol

    public let networkService: JSONRPCServiceProtocol
    
    public let handlerManager: JSONRPCHandlerManagerProtocol

    // MARK: - Init
    
    /// BSC DataSeed service initialiser
    ///
    /// - Parameters:
    ///   - customRPCURL: Custom BSC dataseed url string
    ///   - networkService: JSON RPC Service Communication Protocol
    ///   - handlerManager: Handler Manager
    public init(customRPCURL: URL? = nil,
                idEnumerator: JSONRPCIdEnumeratorProtocol? = nil,
                networkService: JSONRPCServiceProtocol? = nil,
                handlerManager: JSONRPCHandlerManagerProtocol? = nil) {
        let url = customRPCURL ?? URL(string: rpc)!
        rpc = customRPCURL?.absoluteString ?? rpc
        self.idEnumerator = idEnumerator ?? JSONRPCIdEnumerator()
        self.networkService = networkService ?? JSONRPCService(url: url)
        self.handlerManager = handlerManager ?? JSONRPCHandlerManager()
    }
}

// Public Methods

extension BSCDataSeed {

    public func getLastBlockNumber(action: HandlerAction?) {
        let model = JSONRPCRequest(
            method: "eth_blockNumber",
            params: nil,
            id: idEnumerator.next()
        )
        networkService.send(request: model, handler: handler)
        if let action = action { handlerManager.add(action: action, for: model.id) }
    }

    public func getBalance(for id: String, action: HandlerAction?) {
        let model = JSONRPCRequest(
            method: "eth_getBalance",
            params: .positional([.string(id), .string("latest")]),
            id: idEnumerator.next()
        )
        networkService.send(request: model, handler: handler)
        if let action = action { handlerManager.add(action: action, for: model.id) }
    }
}

// MARK: - Private

private extension BSCDataSeed {

    func handler(id: JSONRPC.IDType, object: JSONRPCResponse?, error: Error?) {
        guard let action = handlerManager.get(by: id) else { return }
        handlerManager.remove(at: id)
        DispatchQueue.main(action(id, object, error))
    }
}
