//
//  String+Encoding.swift
//  QueryStringHelpers
//

import Foundation

public enum URLQuerySpaceEncodingMode {
    case plus
    case percent
}

extension String {
    
    public func encodedForURLQuery(spacesMode: URLQuerySpaceEncodingMode) -> String {
        
        let urlQueryAllowed = [
            CharacterSet(charactersIn: "a"..."z"),
            CharacterSet(charactersIn: "A"..."Z"),
            CharacterSet(charactersIn: ".-~_")
            ].reduce(CharacterSet()) { combined, next -> CharacterSet in
                return combined.union(next)
        }
        
        switch spacesMode {
        case .plus:
            let allowedCharacters = urlQueryAllowed.union(CharacterSet(charactersIn: " "))
            let encoded = self.addingPercentEncoding(withAllowedCharacters: allowedCharacters) ?? ""
            return encoded.replacingOccurrences(of: " ", with: "+")
        case .percent:
            return self.addingPercentEncoding(withAllowedCharacters: urlQueryAllowed) ?? ""
        }
    }
    
    public func decodedFromURLQuery() -> String {
        return self.replacingOccurrences(of: "+", with: " ").removingPercentEncoding ?? ""
    }
}
