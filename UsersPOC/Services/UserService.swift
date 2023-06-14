//
//  UserService.swift
//  UsersPOC
//
//  Created by Kaushal Kumbagowdana on 6/13/23.
//

import Foundation
import Combine

protocol UserServiceProtocol {
    func getUsers() -> AnyPublisher<[UserModel], Error>
}


class UserService: UserServiceProtocol {
    
    var url: URL
    
    init(urlString: String) {
        guard let url = URL(string: urlString) else {
            // better error handling needed
            print(NetworkError.invalidURL)
            self.url = URL(string: "bad")!
            return
        }
        self.url = url
    }
    
    func getUsers() -> AnyPublisher<[UserModel], Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode >= 200, httpResponse.statusCode < 300 else {
                    throw NetworkError.responseError
                }
                return data
            }
            .decode(type: [UserModel].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
}

class MockUserService: UserServiceProtocol {
    
    var testResponse: MockSuccessResult
    
    init(testResponse: MockSuccessResult?) {
        self.testResponse = testResponse ?? MockSuccessResult(data: [
            UserModel(id: 1, name: "Mock One", username: "mock_one", email: "mock1@gmail.com"),
            UserModel(id: 2, name: "Mock Two", username: "mock_two", email: "mock2@gmail.com")
        ], response: MockStatusCode(statusCode: 200))
    }
    
    func getUsers() -> AnyPublisher<[UserModel], Error> {
        Just(testResponse)
            .tryMap { dataAndresponse in
                print(dataAndresponse.response)
                let httpResponse: MockStatusCode = dataAndresponse.response
                print(httpResponse.statusCode)
                if httpResponse.statusCode < 200, httpResponse.statusCode > 299 {
                    throw NetworkError.responseError
                }
                return dataAndresponse.data
            }
            .eraseToAnyPublisher()
    }
}

extension MockUserService {
    struct MockSuccessResult {
        var data: [UserModel]
        var response: MockStatusCode
    }
    
    struct MockStatusCode {
        var statusCode: Int
    }
}

