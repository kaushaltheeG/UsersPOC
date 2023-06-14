//
//  UsersIndexViewModel.swift
//  UsersPOC
//
//  Created by Kaushal Kumbagowdana on 6/13/23.
//

import Foundation
import Combine


class UsersViewModel: ObservableObject {
    
    @Published var usersArray: [UserModel] = []
    @Published var userShow: UserModel? = nil
    let userService: UserServiceProtocol
    private var cancelables = Set<AnyCancellable>()
    
    init(userService: UserServiceProtocol) {
        self.userService = userService
    }
    
    func fillUsersArray() {
        userService.getUsers()
            .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        print("Error within UserVM/subscriber \(error)")
                    case .finished:
                        print("Finished Users Array Flow")
                    }
                }, receiveValue: { [weak self] usersArray in
                    print(usersArray)
                    self?.usersArray = usersArray
                })
                .store(in: &cancelables)
    }
    
    func fetchUserShow(id: Int) {
        userService.getUsers()
            .receive(on: DispatchQueue.main)
            .map { users in
                // returns an array
                return users.filter { $0.id == id }
            }
            .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        print("Error within UserVM/subscriber \(error)")
                    case .finished:
                        print("Finished Users Array Flow")
                    }
                }, receiveValue: { [weak self] users in
                    print(users)
                    guard let user = users.first else {
                        print("Failed to find user")
                        return
                    }
                    self?.userShow = user
                })
                .store(in: &cancelables)
    }
}


