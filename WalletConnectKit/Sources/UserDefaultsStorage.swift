//
//  UserDefaultsStorage.swift
//  WalletConnectKit
//
//  Created by Overcout on 24.12.2021.
//

import Foundation
import WalletConnectSwift

public enum UserDefaultsStorageError: Error {

    case getAll
    case getCurrent
    case setCurrent
    case append
    case remove
}

public final class UserDefaultsStorage {
    
    // MARK: - Private Properties
    
    @Defaults<Data>(key: .sessionCurrent) private var sessionCurrent
    @Defaults<[Data]>(key: .sessions) private var sessions

    public init() {}
}

// MARK: - SessionStorageProtocol

extension UserDefaultsStorage: SessionStorageProtocol {

    public func getAllSessions() throws -> [Session] {
        sessions?.compactMap { try? JSONDecoder().decode(Session.self, from: $0) } ?? []
    }
    
    public func getCurrentSession() throws -> Session? {
        guard let data = sessionCurrent else { return nil }
        do {
            return try JSONDecoder().decode(Session.self, from: data)
        } catch {
            throw UserDefaultsStorageError.getCurrent
        }
    }
    
    public func setCurrent(session: Session?) throws {
        do {
            if let session = session {
                sessionCurrent = try JSONEncoder().encode(session)
            } else {
                sessionCurrent = nil
            }
        } catch {
            throw UserDefaultsStorageError.setCurrent
        }
    }
    
    public func updateCurrent(session: Session) throws {
        do {
            if let current = try getCurrentSession() {
                try remove(session: current)
                try append(session: session)
                try setCurrent(session: session)
            } else {
                try append(session: session)
            }
        }
    }
    
    public func append(session: Session) throws {
        do {
            var sessions = sessions ?? []
            let data = try JSONEncoder().encode(session)
            if sessions.contains(data) { return }
            sessions.append(data)
            self.sessions = sessions
        } catch {
            throw UserDefaultsStorageError.append
        }
    }
    
    public func remove(session: Session) throws {
        do {
            var sessions = sessions ?? []
            let data = try JSONEncoder().encode(session)
            sessions.removeAll { $0 == data }
            self.sessions = sessions
        } catch {
            throw UserDefaultsStorageError.remove
        }
    }
    
    public func removeAllSessions() throws {
        sessions = []
        sessionCurrent = nil
    }
}
