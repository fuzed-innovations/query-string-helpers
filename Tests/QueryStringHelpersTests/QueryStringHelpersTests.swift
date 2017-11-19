import XCTest
@testable import QueryStringHelpers

class QueryStringHelpersTests: XCTestCase {
    
    func testQueryStringGeneration() {
        
        // Test empty dictionary
        XCTAssertEqual([:].queryString, "")
        
        // Test single query parameter no value
        XCTAssertEqual(["a": ""].queryString, "?a=") // is this expected?
        
        // Test single query parameter
        XCTAssertEqual(["a": "test"].queryString, "?a=test")
        
        // Test two query parameters in alphabetical order
        XCTAssertEqual(["a": "test", "b": "testagain"].queryString, "?a=test&b=testagain")
        
        // Test two query parameters are ordered into alphabetical order
        XCTAssertEqual(["b": "testagain", "a": "test",].queryString, "?a=test&b=testagain")
        
        // Test URL Encoding of keys - improve with more special characters
        ///!! - improve with more special characters
        XCTAssertEqual(["key with spaces & special characters": "test"].queryString,
                       "?key%20with%20spaces%20%26%20special%20characters=test")
        
        // Test URL Encoding of values
        ///!! - improve with more special characters
        XCTAssertEqual(["test": "value with spaces & special characters"].queryString,
                       "?test=value%20with%20spaces%20%26%20special%20characters=test")
        
    }
    
    func testQueryStringResolution() {
        
        // Test single parameter no value
        XCTAssertEqual("?a".queryParameters, ["a": ""])
        XCTAssertEqual("?a=".queryParameters, ["a": ""])
        
        // Test parameters with value
        XCTAssertEqual("?a=test".queryParameters, ["a": "test"])
        
        // Test parameters with no value in middle of query stirng
        XCTAssertEqual("?a=test&b&c=test".queryParameters, ["a": "test", "b": "", "c": "test"])
        XCTAssertEqual("?a=test&b=&c=test".queryParameters, ["a": "test", "b": "", "c": "test"])
        
        // Test URL Encoded key
        ///!! TODO
        
        // Test URL Encoded value
        ///!! TODO
        
        // Test duplicate keys takes first value?
        ///!! Is this the correct handling?
        XCTAssertEqual("?a=test&a=testtwo".queryParameters, ["a": "test"])
        
        // Test QS at end of URL
        XCTAssertEqual("https://www.google.com?a=test".queryParameters, ["a": "test"])
        XCTAssertEqual("https://www.google.com?a=test&b=test".queryParameters, ["a": "test", "b": "test"])
        
        // Test QS with no ?
        XCTAssertEqual("a=test".queryParameters, ["a": "test"])
        
        // Test QS starting with &
        XCTAssertEqual("stringwithnoqueryparameters".queryParameters, [:])
        
        // Test QS starting with &
        XCTAssertEqual("&a=test".queryParameters, ["a": "test"])
        
    }


    static var allTests = [
        ("testQueryStringGeneration", testQueryStringGeneration),
        ("testQueryStringResolution", testQueryStringResolution)
    ]
}
