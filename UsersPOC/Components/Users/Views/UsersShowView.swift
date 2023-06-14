//
//  UsersShowView.swift
//  UsersPOC
//
//  Created by Kaushal Kumbagowdana on 6/13/23.
//

import SwiftUI

struct UsersShowView: View {
    @StateObject private var usersVm: UsersViewModel
    @State private var userId: Int
    @State private var name: String = ""
    @State private var username: String = ""
    @State private var email: String = ""
    
    init(userService: UserServiceProtocol , userId: Int) {
        _usersVm = StateObject(wrappedValue: UsersViewModel(userService: userService))
        self.userId = userId
    }
    
    var body: some View {
        VStack {
            HStack(spacing: 5) {
                // user's header
                VStack(spacing:5) {
                    // for Profile Icon and username
                    
                    // Profile Icon
                    Text(name.prefix(1))
                      .frame(width: 20, height: 20)
                      .foregroundColor(.white)
                      .padding(20)
                      .background(Color.green)
                      .clipShape(Circle())
                    
                    // Username
                    Text("@" + username)
                }
                .frame(maxWidth: 100)
                VStack(spacing: 5) {
                    // for name and email
                    Text(name)
                    Text(email)
                }
                .frame(maxWidth: 250)
            }
            .frame(maxWidth: 500, maxHeight: 100)
            Spacer()
            
        }
        .background(.gray)
        .onAppear {
            usersVm.fetchUserShow(id: userId)
            // failing to load actual user in production
            self.name = (usersVm.userShow?.name ?? "Place")!
            self.email = (usersVm.userShow?.email ?? "fake@email.com")!
            self.username = (usersVm.userShow?.username ?? "place__")!
        }
    }
}

struct UsersShowView_Previews: PreviewProvider {
    static var previews: some View {
        let checkingState: Bool = ProcessInfo.processInfo.arguments.contains("ProductionState") ? true : false
        let service: UserServiceProtocol = checkingState ? UserService(urlString: "https://jsonplaceholder.typicode.com/users") : MockUserService(testResponse: nil)
        UsersShowView(userService: service, userId: 1)
    }
}
