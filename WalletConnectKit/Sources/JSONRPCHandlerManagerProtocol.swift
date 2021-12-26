//
//  JSONRPCHandlerManagerProtocol.swift
//  WalletConnectKit
//
//  Created by Overcout on 27.12.2021.
//

public typealias HandlerAction = (JSONRPC.IDType, JSONRPCResponse?, Error?) -> Void

/// Action handler manager protocol. Used to store action for particular IDs from JSON RPC request models
public protocol JSONRPCHandlerManagerProtocol {
    
    /// Add Action for ID
    func add(action: @escaping HandlerAction, for id: JSONRPC.IDType)
    
    /// Remove Action by ID
    func remove(at id: JSONRPC.IDType)
    
    /// Get Action by ID
    /// - Returns: Action Handler
    func get(by id: JSONRPC.IDType) -> HandlerAction?
}
