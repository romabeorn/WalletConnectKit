//
//  JSONRPCIdEnumeratorProtocol.swift
//  WalletConnectKit
//
//  Created by Overcout on 27.12.2021.
//

import Foundation

/// Request ID Enumerator
public protocol JSONRPCIdEnumeratorProtocol {
    
    /// Next ID
    /// - Returns: ID
    func next() -> JSONRPC.IDType
}
