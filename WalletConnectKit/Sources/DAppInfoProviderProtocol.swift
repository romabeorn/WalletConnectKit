//
//  DAppInfoProviderProtocol.swift
//  WalletConnectKit
//
//  Created by Overcout on 24.12.2021.
//

/// dApp technical data provider
public protocol DAppInfoProviderProtocol {
    
    var peerId: String { get }
    
    var chainId: Int? { get }
    
    var approved: Bool? { get }
}
