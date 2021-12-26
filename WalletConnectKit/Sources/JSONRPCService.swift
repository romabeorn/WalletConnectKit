//
//  JSONRPCService.swift
//  WalletConnectKit
//
//  Created by Overcout on 26.12.2021.
//

import Foundation

/// Default JSON RPC Service
public final class JSONRPCService {

    // MARK: - Private Properties

    private var url: URL

    // MARK: - Private Init
    
    /// JSON RPC Service initialiser
    /// - Parameter url: Endpoint URL
    public init(url: URL) {
        self.url = url
    }
}

// MARK: - JSONRPCServiceProtocol

extension JSONRPCService: JSONRPCServiceProtocol {
    
    public func send(request model: JSONRPCRequest, handler: @escaping (JSONRPC.IDType, JSONRPCResponse?, JSONRPCError?) -> Void) {
        guard let request = model.request(url: url) else {
            handler(model.id, nil, .encodeFailed)
            return
        }
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil, let data = data else { return }
            let decoder = JSONDecoder()
            guard let response = try? decoder.decode(JSONRPCResponse.self, from: data) else {
                handler(model.id, nil, .decodeFailed)
                return
            }
            handler(response.id, response, nil)
        }.resume()
    }
    
    public func send(response: JSONRPCResponse) {
        guard let request = response.response(url: url) else { return }
        URLSession.shared.dataTask(with: request).resume()
    }
}
