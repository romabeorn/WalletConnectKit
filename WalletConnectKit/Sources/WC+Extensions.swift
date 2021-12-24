//
//  WC+Extensions.swift
//  WalletConnectKit
//
//  Created by Overcout on 24.12.2021.
//

import WalletConnectSwift

public extension WCURL {

    var partiallyPercentEncodedStr: String {
        let params = "bridge=\(bridgeURL.absoluteString)&key=\(key)"
            .addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? ""
        return "wc:\(topic)@\(version)?\(params))"
    }

    var fullyPercentEncodedStr: String {
        absoluteString.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? ""
    }
    
    var formattedString: String {
        let bridge = bridgeURL.absoluteString
        return "wc:\(topic)@\(version)?bridge=\(bridge)&key=\(key)"
    }
}
