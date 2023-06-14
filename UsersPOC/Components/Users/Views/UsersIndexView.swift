//
//  UsersIndexView.swift
//  UsersPOC
//
//  Created by Kaushal Kumbagowdana on 6/13/23.
//

import SwiftUI

struct UsersIndexView: View {
    @StateObject private var usersVm: UsersViewModel
    
    
    init(userService: UserServiceProtocol ) {
        print(userService)
        _usersVm = StateObject(wrappedValue: UsersViewModel(userService: userService))
    }
    
    var body: some View {
        VStack(spacing: 5) {
            ForEach(usersVm.usersArray) { user in
                UserPannelsView(name: user.name, id: user.id)
            }
        }
        .navigationTitle("Users")
        .onAppear {
            usersVm.fillUsersArray()
        }
        
    }
}

struct UsersIndexView_Previews: PreviewProvider {
    static var previews: some View {
        UsersIndexView(userService: MockUserService(testResponse: nil))
    }
}
