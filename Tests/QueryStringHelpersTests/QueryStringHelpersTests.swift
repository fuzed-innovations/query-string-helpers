import XCTest
@testable import QueryStringHelpers

class QueryStringHelpersTests: XCTestCase {
    
    let restrictedQueryKeyCharacters = (unencoded: ";/?:@&=+,$ ",
                                        encoded: "%3B%2F%3F%3A%40%26%3D%2B%2C%24%20")
    
    let restrictedQueryValueCharacters = (unencoded: ";/?:@&=+,$ ",
                                          encoded: "%3B%2F%3F%3A%40%26%3D%2B%2C%24%20")
    
    func testQueryStringGeneration() {
        
        // Test empty dictionary
        XCTAssertEqual([:].queryString, "")
        
        // Test single query parameter no value
        XCTAssertEqual(["a": ""].queryString, "?a=") // is this expected?
        
        // Test single query parameter
        XCTAssertEqual(["a": "test"].queryString, "?a=test")
        
        // Test two query parameters in alphabetical order
        XCTAssertEqual(["a": "test", "b": "testagain"].queryString,
                       "?a=test&b=testagain")
        
        // Test two query parameters are ordered into alphabetical order
        XCTAssertEqual(["b": "testagain", "a": "test",].queryString,
                       "?a=test&b=testagain")
        
        // Test URL Encoding of keys
        XCTAssertEqual(["\(restrictedQueryKeyCharacters.unencoded)": "test"].queryString,
                       "?\(restrictedQueryKeyCharacters.encoded)=test")
        
        // Test URL Encoding of values
        XCTAssertEqual(["test": "\(restrictedQueryValueCharacters.unencoded)"].queryString,
                       "?test=\(restrictedQueryValueCharacters.encoded)")
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
            XCTAssertEqual("\(base)?\(restrictedQueryKeyCharacters.encoded)=test".queryParameters,
                           [restrictedQueryKeyCharacters.unencoded: "test"])
            
            // Test URL Encoded value
            XCTAssertEqual("\(base)?test=\(restrictedQueryValueCharacters.encoded)".queryParameters,
                           ["test": restrictedQueryValueCharacters.unencoded])
            
            // Test duplicate keys - handling: LAST SET
            XCTAssertEqual("\(base)?a=test&a=testtwo".queryParameters,
                           ["a": "testtwo"])
            
            // Test QS starting with & (should not resolve)
            XCTAssertEqual("\(base)&a=test".queryParameters,
                           [:])
            
            // Test QS with no starting character (should not resolve)
            XCTAssertEqual("\(base)a=test".queryParameters,
                           [:])
            
            // Test QS spaces in different formats
            XCTAssertEqual("\(base)?a=string+with+spaces".queryParameters,
                           ["a": "string with spaces"])
            
            XCTAssertEqual("\(base)?a=string%20with%20spaces".queryParameters,
                           ["a": "string with spaces"])
            
            XCTAssertEqual("\(base)?a=string%20with+spaces".queryParameters,
                           ["a": "string with spaces"])
            
            XCTAssertEqual("\(base)?string+with+spaces=test".queryParameters,
                           ["string with spaces": "test"])
            
            XCTAssertEqual("\(base)?string%20with%20spaces=test".queryParameters,
                           ["string with spaces": "test"])
            
            XCTAssertEqual("\(base)?string%20with+spaces=test".queryParameters,
                           ["string with spaces": "test"])
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
                           "\(base)?a=testorder&b=testa=test&c=testtwo&d=test")
            
            // Test addition of empty QS - existing QS
            XCTAssertEqual("\(base)?a=test".adding(queryParameters: [:]),
                           "\(base)?a=test")
            
            // Test parameter addition with existing qs
            XCTAssertEqual("\(base)?a=test".adding(queryParameters: ["a": "overwrite"]),
                           "\(base)?a=overwrite")
            
            // Test adding with existing URL encoded Params
            XCTAssertEqual("\(base)?\(restrictedQueryKeyCharacters.encoded)=\(restrictedQueryValueCharacters.encoded)".adding(queryParameters: ["a": "overwrite"]),
                           "\(base)?\(restrictedQueryKeyCharacters.encoded)=\(restrictedQueryValueCharacters.encoded)&a=overwrite")
            
            // Test adding URL encoded Params
            XCTAssertEqual("\(base)".adding(queryParameters: [restrictedQueryKeyCharacters.unencoded: restrictedQueryValueCharacters.unencoded]),
                                            "\(base)?\(restrictedQueryKeyCharacters.encoded)=\(restrictedQueryValueCharacters.encoded)")
            
            
            // Test parameter overwriting
            XCTAssertEqual("\(base)?a=test".adding(queryParameters: ["a": "overwrite"]),
                           "\(base)?a=overwrite")
        }
        
        // Test Suite
        _testQueryAddition(base: "")
        _testQueryAddition(base: "https://www.testwebsite.com")
        _testQueryAddition(base: "https://www.testwebsite.com/test/path")
    }


    static var allTests = [
        ("testQueryStringGeneration", testQueryStringGeneration),
        ("testQueryStringResolution", testQueryStringResolution),
        ("testQueryAddition", testQueryAddition)
    ]
}
