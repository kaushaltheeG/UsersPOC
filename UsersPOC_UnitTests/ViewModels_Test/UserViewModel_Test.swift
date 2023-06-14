//
//  UserViewModel_Test.swift
//  UsersPOC_UnitTests
//
//  Created by Kaushal Kumbagowdana on 6/14/23.
//

import XCTest
@testable import UsersPOC

final class UserViewModel_Test: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_UserViewModel_fillUsersArray_IsUsersArrayFilled() throws {
        // Givem
        let usersVm = UsersViewModel(userService: MockUserService(testResponse: nil))
        
        // When
        usersVm.fillUsersArray()
        
        // Then
        XCTAssertFalse(usersVm.usersArray.isEmpty)
        XCTAssertNotNil(usersVm.usersArray.first)
    }
    
    func test_UserViewModel_fillUsersArray_IsUsersArrayFilled_stress() throws {
        // Givem
        let stressAmount = 200
        let usersArray = createUserInput(amount: stressAmount)
        let stressResponse = MockUserService.MockResult(data: usersArray, response: MockUserService.MockStatusCode(statusCode: 200))
        let usersVm = UsersViewModel(userService: MockUserService(testResponse: stressResponse))
        let testId = Int.random(in: 1..<stressAmount+1)
        
        // When
        usersVm.fillUsersArray()
            // drop the init data
        let trueArray = usersVm.usersArray.dropFirst()
        
        // Then
        XCTAssertFalse(usersVm.usersArray.isEmpty)
        XCTAssertEqual(trueArray.count, stressAmount)
        XCTAssertNotNil(usersVm.usersArray.filter{ $0.id == testId })
    }
    
    func test_UserViewModel_fillUsersArray_IsUsersShowPresent() throws {
        // Givem
        let usersVm = UsersViewModel(userService: MockUserService(testResponse: nil))
        let testId = 2
        
        // When
        usersVm.fetchUserShow(id: testId)
        
        // Then
        XCTAssertNotNil(usersVm.userShow)
        XCTAssertEqual(usersVm.userShow?.id, testId)
    }
    
    func test_UserViewModel_fillUsersArray_IsUsersShowPresent_stress() throws {
        // Givem
        let stressAmount = 50
        let usersArray = createUserInput(amount: stressAmount)
        let stressResponse = MockUserService.MockResult(data: usersArray, response: MockUserService.MockStatusCode(statusCode: 200))
        let usersVm = UsersViewModel(userService: MockUserService(testResponse: stressResponse ))
        let testId = Int.random(in: 1..<stressAmount+1)
        
        // When
        usersVm.fetchUserShow(id: testId)
        
        // Then
        XCTAssertNotNil(usersVm.userShow)
        XCTAssertEqual(usersVm.userShow?.id, testId)
    }

    // Helper
    func createUserInput(amount: Int) -> [UserModel] {
        var createdUsers: [UserModel] = []
        
        for var idx in 1...amount+1 {
            createdUsers.append(UserModel(id: idx, name: UUID().uuidString, username: UUID().uuidString, email: UUID().uuidString))
            idx += 1
        }
        
        return createdUsers
    }

}
