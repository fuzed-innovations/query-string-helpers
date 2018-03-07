//
//  QueryStringHelpersTests.swift
//  QueryStringHelpersTests
//

import XCTest
@testable import QueryStringHelpers

class QueryStringHelpersTests: XCTestCase {
    
    let restrictedQueryCharacters = (unencoded: ":/?#[]@\"!$&'()*+,;= ",
                                     encodedSpacePlus: "%3A%2F%3F%23%5B%5D%40%22%21%24%26%27%28%29%2A%2B%2C%3B%3D+",
                                     encodedSpacePercent: "%3A%2F%3F%23%5B%5D%40%22%21%24%26%27%28%29%2A%2B%2C%3B%3D%20")
    
    let allowedQueryCharacterSample = "aAzZ09~_-."
    
    func testStringEncoding() {
        
        // Test Allowed Characters
        XCTAssertEqual(allowedQueryCharacterSample.encodedForURLQuery(spacesMode: .plus),
                       allowedQueryCharacterSample)
        XCTAssertEqual(allowedQueryCharacterSample.encodedForURLQuery(spacesMode: .percent),
                       allowedQueryCharacterSample)
        
        // Test Restricted Characters
        XCTAssertEqual(restrictedQueryCharacters.unencoded.encodedForURLQuery(spacesMode: .plus),
                       restrictedQueryCharacters.encodedSpacePlus)
        XCTAssertEqual(restrictedQueryCharacters.unencoded.encodedForURLQuery(spacesMode: .percent),
                       restrictedQueryCharacters.encodedSpacePercent)
        
        // Test Combination Of Characters
        XCTAssertEqual("\(allowedQueryCharacterSample)\(restrictedQueryCharacters.unencoded)".encodedForURLQuery(spacesMode: .plus),
                       "\(allowedQueryCharacterSample)\(restrictedQueryCharacters.encodedSpacePlus)")
        XCTAssertEqual("\(allowedQueryCharacterSample)\(restrictedQueryCharacters.unencoded)".encodedForURLQuery(spacesMode: .percent),
                       "\(allowedQueryCharacterSample)\(restrictedQueryCharacters.encodedSpacePercent)")
    }
    
    func testStringDecoding() {
        
        // Test Allowed Characters
        XCTAssertEqual(allowedQueryCharacterSample.decodedFromURLQuery(),
                       allowedQueryCharacterSample)
        
        // Test Restricted Characters
        XCTAssertEqual(restrictedQueryCharacters.encodedSpacePlus.decodedFromURLQuery(),
                       restrictedQueryCharacters.unencoded)
        XCTAssertEqual(restrictedQueryCharacters.encodedSpacePercent.decodedFromURLQuery(),
                       restrictedQueryCharacters.unencoded)
        
        // Test Combination Of Characters
        XCTAssertEqual((restrictedQueryCharacters.encodedSpacePlus + restrictedQueryCharacters.encodedSpacePercent + allowedQueryCharacterSample).decodedFromURLQuery(),
                       restrictedQueryCharacters.unencoded         + restrictedQueryCharacters.unencoded           + allowedQueryCharacterSample)
        
    }
    
    func testQueryStringGeneration() {
        
        // Test empty dictionary
        XCTAssertEqual([:].queryString(), "")
        
        // Test single query parameter no value
        XCTAssertEqual([allowedQueryCharacterSample: ""].queryString(), "?\(allowedQueryCharacterSample)=") // is this expected?
        
        // Test single query parameter
        XCTAssertEqual([allowedQueryCharacterSample: "test"].queryString(), "?\(allowedQueryCharacterSample)=test")
        
        // Test two query parameters in alphabetical order
        XCTAssertEqual(["a": "test", "b": "testagain"].queryString(),
                       "?a=test&b=testagain")
        
        // Test two query parameters are ordered into alphabetical order
        XCTAssertEqual(["b": "testagain", "a": "test",].queryString(),
                       "?a=test&b=testagain")
        
        // Test emptyParameterMode, with and without non-empty values
        XCTAssertEqual(["a": ""].queryString(emptyParameterMode: .equals),
                       "?a=")
        XCTAssertEqual(["a": "", "b": ""].queryString(emptyParameterMode: .equals),
                       "?a=&b=")
        XCTAssertEqual(["a": "", "b": "test"].queryString(emptyParameterMode: .equals),
                       "?a=&b=test")
        XCTAssertEqual(["a": ""].queryString(emptyParameterMode: .noEquals),
                       "?a")
        XCTAssertEqual(["a": "", "b": ""].queryString(emptyParameterMode: .noEquals),
                       "?a&b")
        XCTAssertEqual(["a": "", "b": "test"].queryString(emptyParameterMode: .noEquals),
                       "?a&b=test")
        
        // Test URL Encoding of keys
        XCTAssertEqual(["\(restrictedQueryCharacters.unencoded)": "test"].queryString(spacesMode: .plus),
                       "?\(restrictedQueryCharacters.encodedSpacePlus)=test")
        XCTAssertEqual(["\(restrictedQueryCharacters.unencoded)": "test"].queryString(spacesMode: .percent),
                       "?\(restrictedQueryCharacters.encodedSpacePercent)=test")
        
        // Test URL Encoding of values
        XCTAssertEqual(["test": "\(restrictedQueryCharacters.unencoded)"].queryString(spacesMode: .plus),
                       "?test=\(restrictedQueryCharacters.encodedSpacePlus)")
        XCTAssertEqual(["test": "\(restrictedQueryCharacters.unencoded)"].queryString(spacesMode: .percent),
                       "?test=\(restrictedQueryCharacters.encodedSpacePercent)")
    }
    
    func testQueryStringResolution() {
        
        func _testQueryStringResolution(base: String) {
            
            // Test single parameter no value
            XCTAssertEqual("\(base)?a".queryParameters,
                           ["a": ""])
            
            XCTAssertEqual("\(base)?a=".queryParameters,
                           ["a": ""])
            
            // Test parameters with value
            XCTAssertEqual("\(base)?a=test".queryParameters,
                           ["a": "test"])
            
            // Test parameters with no value in middle of query stirng
            XCTAssertEqual("\(base)?a=test&b&c=test".queryParameters,
                           ["a": "test", "b": "", "c": "test"])
            
            XCTAssertEqual("\(base)?a=test&b=&c=test".queryParameters,
                           ["a": "test", "b": "", "c": "test"])
            
            // Test URL Encoded key
            XCTAssertEqual("\(base)?\(restrictedQueryCharacters.encodedSpacePlus)=test".queryParameters,
                           [restrictedQueryCharacters.unencoded: "test"])
            
            XCTAssertEqual("\(base)?\(restrictedQueryCharacters.encodedSpacePercent)=test".queryParameters,
                           [restrictedQueryCharacters.unencoded: "test"])
            
            // Test URL Encoded value
            XCTAssertEqual("\(base)?test=\(restrictedQueryCharacters.encodedSpacePlus)".queryParameters,
                           ["test": restrictedQueryCharacters.unencoded])
            
            XCTAssertEqual("\(base)?test=\(restrictedQueryCharacters.encodedSpacePercent)".queryParameters,
                           ["test": restrictedQueryCharacters.unencoded])
            
            // Test duplicate keys - handling: LAST SET
            XCTAssertEqual("\(base)?a=test&a=testtwo".queryParameters,
                           ["a": "testtwo"])
            
            // Test QS starting with & (should not resolve)
            XCTAssertEqual("\(base)&a=test".queryParameters,
                           [:])
            
            // Test QS with no starting character (should not resolve)
            XCTAssertEqual("\(base)a=test".queryParameters,
                           [:])
        }
        
        
        // Test Suite
        _testQueryStringResolution(base: "")
        _testQueryStringResolution(base: "https://www.testwesbite.com")
        _testQueryStringResolution(base: "https://www.testwebsite.com/test/path")
    }
    
    func testQueryAddition() {
        
        func _testQueryAddition(base: String) {
            
            // Test addition of empty QS - no existing QS
            XCTAssertEqual("\(base)".adding(queryParameters: [:]),
                           "\(base)")
            
            // Test parameter addition with no existing qs
            XCTAssertEqual("\(base)".adding(queryParameters: ["a":"test"]),
                           "\(base)?a=test")
            
            // Test alphabetical parameter addition with no existing qs
            XCTAssertEqual("\(base)".adding(queryParameters: ["d": "test", "c": "testtwo"]),
                           "\(base)?c=testtwo&d=test")
            
            // Test alphabetical parameter addition with an existing qs
            XCTAssertEqual("\(base)?a=test".adding(queryParameters: ["d": "test", "c": "testtwo"]),
                           "\(base)?a=test&c=testtwo&d=test")
            
            // Test alphabetical parameter addition with an existing non-alphabetical qs
            XCTAssertEqual("\(base)?b=test&a=testorder".adding(queryParameters: ["d": "test", "c": "testtwo"]),
                           "\(base)?a=testorder&b=test&c=testtwo&d=test")
            
            // Test addition of empty QS - existing QS
            XCTAssertEqual("\(base)?a=test".adding(queryParameters: [:]),
                           "\(base)?a=test")
            
            // Test parameter addition with existing qs
            XCTAssertEqual("\(base)?a=test".adding(queryParameters: ["a": "overwrite"]),
                           "\(base)?a=overwrite")
            
            // Test adding with existing URL encoded Params
            XCTAssertEqual("\(base)?\(restrictedQueryCharacters.encodedSpacePlus)=\(restrictedQueryCharacters.encodedSpacePlus)".adding(queryParameters: ["a": "overwrite"]),
                           "\(base)?\(restrictedQueryCharacters.encodedSpacePlus)=\(restrictedQueryCharacters.encodedSpacePlus)&a=overwrite")
            
            // Test adding URL encoded Params
            XCTAssertEqual("\(base)".adding(queryParameters: [restrictedQueryCharacters.unencoded: restrictedQueryCharacters.unencoded]),
                                            "\(base)?\(restrictedQueryCharacters.encodedSpacePlus)=\(restrictedQueryCharacters.encodedSpacePlus)")
            
            
            // Test parameter overwriting
            XCTAssertEqual("\(base)?a=test".adding(queryParameters: ["a": "overwrite"]),
                           "\(base)?a=overwrite")
            
            // Test emptyParameterMode, with and without non-empty values
            XCTAssertEqual("\(base)?a".adding(queryParameters: ["b": ""], emptyParameterMode: .equals),
                           "\(base)?a=&b=")
            XCTAssertEqual("\(base)?a=".adding(queryParameters: ["b": ""], emptyParameterMode: .equals),
                           "\(base)?a=&b=")
            XCTAssertEqual("\(base)?a=test".adding(queryParameters: ["b": ""], emptyParameterMode: .equals),
                           "\(base)?a=test&b=")
            XCTAssertEqual("\(base)?a=test".adding(queryParameters: ["b": "", "c": ""], emptyParameterMode: .equals),
                           "\(base)?a=test&b=&c=")
            XCTAssertEqual("\(base)?a=test".adding(queryParameters: ["b": "", "c": "test"], emptyParameterMode: .equals),
                           "\(base)?a=test&b=&c=test")
            
            XCTAssertEqual("\(base)?a".adding(queryParameters: ["b": ""], emptyParameterMode: .noEquals),
                           "\(base)?a&b")
            XCTAssertEqual("\(base)?a=".adding(queryParameters: ["b": ""], emptyParameterMode: .noEquals),
                           "\(base)?a&b")
            XCTAssertEqual("\(base)?a=test".adding(queryParameters: ["b": ""], emptyParameterMode: .noEquals),
                           "\(base)?a=test&b")
            XCTAssertEqual("\(base)?a=test".adding(queryParameters: ["b": "", "c": ""], emptyParameterMode: .noEquals),
                           "\(base)?a=test&b&c")
            XCTAssertEqual("\(base)?a=test".adding(queryParameters: ["b": "", "c": "test"], emptyParameterMode: .noEquals),
                           "\(base)?a=test&b&c=test")
        }
        
        // Test Suite
        _testQueryAddition(base: "")
        _testQueryAddition(base: "https://www.testwebsite.com")
        _testQueryAddition(base: "https://www.testwebsite.com/test/path")
    }


    static var allTests = [
        ("testStringEncoding", testStringEncoding),
        ("testStringDecoding", testStringDecoding),
        ("testQueryStringGeneration", testQueryStringGeneration),
        ("testQueryStringResolution", testQueryStringResolution),
        ("testQueryAddition", testQueryAddition)
    ]
}
