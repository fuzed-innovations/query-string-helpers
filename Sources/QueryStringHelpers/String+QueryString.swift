//
//  String+QueryString.swift
//  QueryStringHelpers
//

import Foundation
    
extension String {
    
    public var queryParameters: [String: String] {
        
        guard let startOfQS = self.range(of: "?")?.upperBound else {
            return [:]
        }
        
        let queryString = self.substring(from: startOfQS)
        let queryComponents = queryString.components(separatedBy: "&")
        
        var answer: [String: String] = [:]
        queryComponents.forEach {
            
            if let rangeOfFirstEqual = $0.range(of: "=") {
                
                let key = $0.substring(to: rangeOfFirstEqual.lowerBound).decodedFromURLQuery()
                let value = $0.substring(from: rangeOfFirstEqual.upperBound).decodedFromURLQuery()
                
                answer[key] = value
                
            } else {
                let key = $0.decodedFromURLQuery()
                answer[key] = ""
            }
        }
        
        return answer
    }
    
    public func adding(queryParameters: [String: String],
                       spacesMode: URLQuerySpaceEncodingMode = .plus,
                       emptyParameterMode: URLQueryStringEmptyParameterMode = .equals) -> String {
        
        // Mutable copy
        var result = self
        
        // Merge current and new query parameter dictionaries
        var merged = self.queryParameters
        queryParameters.keys.forEach {
            merged[$0] = queryParameters[$0]
        }
        
        // Remove old query string if exists
        if let index = self.index(of: "?") {
            result = self.substring(to: index)
        }
        
        // Add new query string from merge
        result += merged.queryString(spacesMode: spacesMode,
                                     emptyParameterMode: emptyParameterMode)
        
        return result
    }
}
