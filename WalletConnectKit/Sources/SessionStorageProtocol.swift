//
//  SessionStorageProtocol.swift
//  WalletConnectKit
//
//  Created by Overcout on 24.12.2021.
//

import WalletConnectSwift

/// Storage protocol. Service communicates with the storage in different ways using this protocol.
public protocol SessionStorageProtocol {
    
    /// Get list of entire stored sessions
    func getAllSessions() throws -> [Session]
    
    /// Get current session from the storage
    func getCurrentSession() throws -> Session?
    
    /// Set active (actual) session to the storage
    func setCurrent(session: Session?) throws
    
    /// Update current session with new data from new session
    func updateCurrent(session: Session) throws
    
    /// Append sessions to the list of sessions
    func append(session: Session) throws

    /// Remove session from the list of sessions
    func remove(session: Session) throws

    /// Erase sessions data including current
    func removeAllSessions() throws
}
