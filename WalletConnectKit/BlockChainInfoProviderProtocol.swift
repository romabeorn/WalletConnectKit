//
//  BlockChainInfoProviderProtocol.swift
//  WalletConnectKit
//
//  Created by Overcout on 24.12.2021.
//

/// Block Chain Info Provider
protocol BlockChainInfoProviderProtocol {
    
    /// Get Info by Chain ID
    func getBlockChainInfo(chainId: String)
    
    /// Get Info by Network ID
    func getBlockChainInfo(networkId: String)
    
    /// Get Info by Chain and Network IDs
    func getBlockChainInfo(chainId: String, networkId: String)
}
