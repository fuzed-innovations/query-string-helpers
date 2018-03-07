//
//  Dictionary+QueryString.swift
//  QueryStringHelpers
//

import Foundation

extension Dictionary where Key == String, Value == String {
    
    public func queryString(spacesMode: URLQuerySpaceEncodingMode = .plus,
                            emptyParameterMode: QueryStringEmptyParameterMode = .equals) -> String {
        
        guard !self.isEmpty else { return "" }
        
        return "?" + self.keys.sorted().reduce("") { existingQs, key -> String in
            
            var reducing = existingQs
            
            if !existingQs.characters.isEmpty {
                reducing += "&"
            }
            
            reducing += key.encodedForURLQuery(spacesMode: spacesMode)
            
            if let val = self[key] {
                
                if emptyParameterMode == .equals {
                    reducing += "=" + val.encodedForURLQuery(spacesMode: spacesMode)
                } else if val.isEmpty {
                    return reducing
                } else {
                    reducing += "=" + val.encodedForURLQuery(spacesMode: spacesMode)
                }
            }
            
            return reducing
        }
    }
}
