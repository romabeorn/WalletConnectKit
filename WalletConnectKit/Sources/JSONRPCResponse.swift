//
//  JSONRPCResponse.swift
//  WalletConnectKit
//
//  Created by Overcout on 26.12.2021.
//

import Foundation

public struct JSONRPCResponse: Hashable, Codable {

    // MARK: - Public Properties

    public var jsonrpc = "2.0"

    public var result: Payload

    public var id: JSONRPC.IDType

    public init(result: Payload, id: JSONRPC.IDType) {
        self.result = result
        self.id = id
    }

    public enum Payload: Hashable, Codable {

        case value(JSONRPC.ValueType)
        case error(ErrorPayload)

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let error = try? container.decode(ErrorPayload.self) {
                self = .error(error)
            } else if let value = try? container.decode(JSONRPC.ValueType.self) {
                self = .value(value)
            } else if container.decodeNil() {
                self = .value(.null)
            } else {
                let context = DecodingError.Context(codingPath: decoder.codingPath,
                                                    debugDescription: "Payload is neither error, nor JSON value")
                throw DecodingError.typeMismatch(JSONRPC.ValueType.self, context)
            }
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            switch self {
            case .value(let value):
                try container.encode(value)
            case .error(let value):
                try container.encode(value)
            }
        }

        public struct ErrorPayload: Hashable, Codable {

            public var code: Int
            public var message: String
            public var data: JSONRPC.ValueType?

            public init(code: Int, message: String, data: JSONRPC.ValueType?) {
                self.code = code
                self.message = message
                self.data = data
            }
        }
    }
}

public extension JSONRPCResponse {

    func response(url: URL) -> URLRequest? {
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

