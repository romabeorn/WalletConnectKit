//
//  ClientMetaProviderProtocol.swift
//  WalletConnectKit
//
//  Created by Overcout on 24.12.2021.
//

import Foundation

/// dApp business data provider
public protocol ClientMetaProviderProtocol {
    
    /// dApp Name
    var name: String { get }
    
    /// dApp Description
    var description: String? { get }
    
    /// dApp icons
    var icons: [URL] { get }
    
    /// dApp public web url
    var url: URL { get }
    
    /// dApp URL scheme
    var scheme: String? { get }
}
