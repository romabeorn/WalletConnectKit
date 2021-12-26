//
//  JSONRPCRequest.swift
//  WalletConnectKit
//
//  Created by Overcout on 26.12.2021.
//

import Foundation

public struct JSONRPCRequest: Hashable, Codable {

    public var jsonrpc = "2.0"
    public var method: String
    public var params: Params?
    public var id: JSONRPC.IDType

    public init(method: String, params: Params?, id: JSONRPC.IDType) {
        self.method = method
        self.params = params
        self.id = id
    }

    public enum Params: Hashable, Codable {

        case positional([JSONRPC.ValueType])
        case named([String: JSONRPC.ValueType])

        public init(from decoder: Decoder) throws {
            if let keyedContainer = try? decoder.container(keyedBy: JSONRPC.KeyType.self) {
                var result = [String: JSONRPC.ValueType]()
                for key in keyedContainer.allKeys {
                    result[key.stringValue] = try keyedContainer.decode(JSONRPC.ValueType.self, forKey: key)
                }
                self = .named(result)
            } else if var unkeyedContainer = try? decoder.unkeyedContainer() {
                var result = [JSONRPC.ValueType]()
                while !unkeyedContainer.isAtEnd {
                    let value = try unkeyedContainer.decode(JSONRPC.ValueType.self)
                    result.append(value)
                }
                self = .positional(result)
            } else {
                let context = DecodingError.Context(codingPath: decoder.codingPath,
                                                    debugDescription: "Did not match any container")
                throw DecodingError.typeMismatch(Params.self, context)
            }
        }

        public func encode(to encoder: Encoder) throws {
            switch self {
            case .named(let object):
                var container = encoder.container(keyedBy: JSONRPC.KeyType.self)
                for (key, value) in object {
                    try container.encode(value, forKey: JSONRPC.KeyType(stringValue: key)!)
                }
            case .positional(let array):
                var container = encoder.unkeyedContainer()
                for value in array {
                    try container.encode(value)
                }
            }
        }
    }
}

public extension JSONRPCRequest {

    func request(url: URL) -> URLRequest? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys]
        var request = URLRequest(url: url)
        request.setValue("application/json-rpc", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        guard let data = try? encoder.encode(self) else { return nil }
        request.httpBody = data
        return request
    }
}
