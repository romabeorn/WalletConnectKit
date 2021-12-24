//
//  WalletConnectServiceDelegate.swift
//  WalletConnectKit
//
//  Created by Overcout on 24.12.2021.
//

import WalletConnectSwift

/// Service delegate protocol to extend ClientDelegate protocol. Notifies delegate about "Will" actions
protocol WalletConnectServiceDelegate: AnyObject {

    // MARK: - Connect
    
    /// Will connect to the bridge url
    func willConnect(to url: WCURL)
    
    /// Will reconnect to the bridge url
    func willReconnect(to url: WCURL)
    
    /// Will disconnect to the bridge url
    func willDisconnect(from url: WCURL)
}
