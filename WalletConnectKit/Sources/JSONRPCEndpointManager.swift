//
//  JSONRPCEndpointManager.swift
//  WalletConnectKit
//
//  Created by Overcout on 27.12.2021.
//

import Foundation

/// Endpoint Manager
public final class JSONRPCEndpointManager {

    // MARK: - Init

    public init() {}

    public var regexEndpointMap: [String: JSONRPCEndpointProtocol.Type] = [
        "https://bsc-dataseed[0-9].binance.org": BSCDataSeed.self,
        "https://mainnet.infura.io/v3*": MainNetInfuraIoV3.self
    ]

    public func getEndpoint(for rpc: String) -> JSONRPCEndpointProtocol.Type? {
        let types = regexEndpointMap.compactMap { rpc ~= $0.key ? $0.value : nil }
        return types.first
    }
}
