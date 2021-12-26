//
//  JSONRPCHandlerManager.swift
//  WalletConnectKit
//
//  Created by Overcout on 26.12.2021.
//

import Foundation

public final class JSONRPCHandlerManager {

    // MARK: - Private Properties

    private var handlers: [JSONRPC.IDType: HandlerAction] = [:]

    private var lock = DispatchSemaphore(value: 1)
}

extension JSONRPCHandlerManager: JSONRPCHandlerManagerProtocol {
    
    // MARK: - JSONRPCHandlerManagerProtocol

    public func add(action: @escaping HandlerAction, for id: JSONRPC.IDType) {
        lock.wait()
        handlers[id] = action
        lock.signal()
    }
    
    public func remove(at id: JSONRPC.IDType) {
        lock.wait()
        handlers.removeValue(forKey: id)
        lock.signal()
    }
    
    public func get(by id: JSONRPC.IDType) -> HandlerAction? {
        defer { lock.signal() }
        lock.wait()
        return handlers[id]
    }
}
