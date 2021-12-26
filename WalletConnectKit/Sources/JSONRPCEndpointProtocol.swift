//
//  JSONRPCEndpointProtocol.swift
//  WalletConnectKit
//
//  Created by Overcout on 26.12.2021.
//

/// JSON RPC Endpoint protocol. Used to unite different JSON RPC services with different endpoint by one protocol
public protocol JSONRPCEndpointProtocol: AnyObject {

    /// JSON RPC Endpoint string
    var rpc: String { get }

    /// IDType enumerator
    var idEnumerator: JSONRPCIdEnumeratorProtocol { get }

    /// JSON RPC communication service
    var networkService: JSONRPCServiceProtocol { get }

    /// Actions handler manager. Used to store action for particular IDs from JSON RPC request models
    var handlerManager: JSONRPCHandlerManagerProtocol { get }

    func getLastBlockNumber(action: HandlerAction?)

    func getBalance(for id: String, action: HandlerAction?)
}
