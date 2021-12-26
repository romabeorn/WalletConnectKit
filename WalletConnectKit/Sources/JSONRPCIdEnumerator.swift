//
//  JSONRPCIdEnumerator.swift
//  WalletConnectKit
//
//  Created by Overcout on 27.12.2021.
//

/// Default ID Enumerator
public final class JSONRPCIdEnumerator {

    // MARK: - Private Properties

    private var id: Int = 0
}

// MARK: - JSONRPCIdEnumeratorProtocol

extension JSONRPCIdEnumerator: JSONRPCIdEnumeratorProtocol {
    
    public func next() -> JSONRPC.IDType {
        id += 1
        return .int(id)
    }
}
