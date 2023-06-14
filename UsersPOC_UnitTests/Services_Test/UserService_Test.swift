//
//  UserService_Test.swift
//  UsersPOC_UnitTests
//
//  Created by Kaushal Kumbagowdana on 6/13/23.
//

import XCTest
@testable import UsersPOC
import Combine

final class UserService_Test: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_UserService_init_ShouldFailSettingURL() {
        // Given
        let invalidURL = "this is not a url"
        
        // When
        let userService = UserService(urlString: invalidURL)
        
        // Then
        XCTAssertNil(userService.url)
    }
    
    func test_UserService_init_ShouldSetURL() {
        // Given
        let validURL = "https://jsonplaceholder.typicode.com/users"
        
        // When
        let userService = UserService(urlString: validURL)
        
        // Then
        XCTAssertNotNil(userService.url)
    }
    
    func test_MockUserService_getUser_FailDueToResponseError() {
        // Given
        let failResponse = MockUserService.MockResult(data: [UserModel(id: 2, name: "fake", username: "faile", email: "faile")], response: MockUserService.MockStatusCode(statusCode: 400))
        var cancelables = Set<AnyCancellable>()
        let expectation = XCTestExpectation(description: "Should Have Pushed Newtwork Response Error")
        
        // When
        let mockUserService = MockUserService(testResponse: failResponse)
        mockUserService.getUsers()
            .sink(receiveCompletion: { completion in
                // Then
                switch completion {
                case .failure(let error):
                    XCTAssertNotNil(error)
                    XCTAssertEqual(error as? NetworkError, NetworkError.responseError)
                default:
                    XCTFail("Should not have finished || FAIlED")
                }
                expectation.fulfill()
                
            }, receiveValue: { _ in
                XCTFail("Should not recieved value || FAIlED")
                expectation.fulfill()
            })
            .store(in: &cancelables)
        
        wait(for: [expectation], timeout: 5)
    }
    
    func test_MockUserService_getUser_GetPublisherWithValidResponse() {
        // Given
        var cancelables = Set<AnyCancellable>()
        let expectation = XCTestExpectation(description: "Should Have Passed With Vaild Response")
        
        // When
        let mockUserService = MockUserService(testResponse: nil)
        mockUserService.getUsers()
            .sink(receiveCompletion: { completion in
                // Then
                switch completion {
                case .failure(_):
                    XCTFail("Should not have failed || FAIlED")
                case .finished:
                    let withinFinished = true
                    XCTAssertTrue(withinFinished)
                }
                expectation.fulfill()
            }, receiveValue: { value in
                XCTAssertNotNil(value)
                expectation.fulfill()
            })
            .store(in: &cancelables)
        
        wait(for: [expectation], timeout: 5)
    }


}
