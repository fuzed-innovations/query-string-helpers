//
//  Dictionary+QueryString.swift
//  QueryStringHelpers
//

import Foundation

extension Dictionary where Key == String, Value == String {
    
    public func queryString(spacesMode: URLQuerySpaceEncodingMode = .plus) -> String {
        
        guard self.keys.count > 0 else { return "" }
        
        return "?" + self.keys.sorted().reduce("") { existingQs, key -> String in
            
            var reducing = existingQs
            
            if !existingQs.characters.isEmpty {
                reducing += "&"
            }
            
            reducing += key.encodedForURLQuery(spacesMode: spacesMode)
            
            if let val = self[key] {
                reducing += "=" + val.encodedForURLQuery(spacesMode: spacesMode)
            }
            
            return reducing
        }
    }
}
