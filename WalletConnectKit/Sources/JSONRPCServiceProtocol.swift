//
//  JSONRPCServiceProtocol.swift
//  WalletConnectKit
//
//  Created by Overcout on 27.12.2021.
//

/// JSON RPC Service Communication Protocol
public protocol JSONRPCServiceProtocol {

    /// Send request to endpoint
    func send(request model: JSONRPCRequest, handler: @escaping (JSONRPC.IDType, JSONRPCResponse?, JSONRPCError?) -> Void)
    
    /// Send response to endpoint
    func send(response: JSONRPCResponse)
}
