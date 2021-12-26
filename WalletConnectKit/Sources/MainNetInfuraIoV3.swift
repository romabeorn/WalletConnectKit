//
//  MainNetInfuraIoV3.swift
//  WalletConnectKit
//
//  Created by Overcout on 26.12.2021.
//

import Foundation

/// MainNetInfuraIoV3 JSON RPC endpoint service
public final class MainNetInfuraIoV3: JSONRPCEndpointProtocol {

    // MARK: - MainNetInfuraIoV3 Properties

    public let rpc: String = "https://mainnet.infura.io/v3/${INFURA_API_KEY}"
    
    public let idEnumerator: JSONRPCIdEnumeratorProtocol

    public let networkService: JSONRPCServiceProtocol
    
    public let handlerManager: JSONRPCHandlerManagerProtocol

    // MARK: - Private Properties

    private let apiKey: String

    // MARK: - Init
    
    /// Main Net Infura 3 version service initialiser
    ///
    /// - Parameters:
    ///   - infuraApiKey: infuraApiKey: API Key
    ///   - handlerManager: Handler Manager
    public init(infuraApiKey: String,
                idEnumerator: JSONRPCIdEnumeratorProtocol? = nil,
                networkService: JSONRPCServiceProtocol? = nil,
                handlerManager: JSONRPCHandlerManagerProtocol? = nil) {
        let url = URL(string: rpc.replacingOccurrences(of: "${INFURA_API_KEY}", with: infuraApiKey))!
        self.apiKey = infuraApiKey
        self.idEnumerator = idEnumerator ?? JSONRPCIdEnumerator()
        self.networkService = networkService ?? JSONRPCService(url: url)
        self.handlerManager = handlerManager ?? JSONRPCHandlerManager()
    }
}

// Public Methods

extension MainNetInfuraIoV3 {

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

private extension MainNetInfuraIoV3 {

    func handler(id: JSONRPC.IDType, object: JSONRPCResponse?, error: Error?) {
        guard let action = handlerManager.get(by: id) else { return }
        handlerManager.remove(at: id)
        DispatchQueue.main(action(id, object, error))
    }
}
