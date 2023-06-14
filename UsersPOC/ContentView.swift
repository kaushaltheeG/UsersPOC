//
//  ContentView.swift
//  UsersPOC
//
//  Created by Kaushal Kumbagowdana on 6/13/23.
//

import SwiftUI

enum AppState {
    case production
    case testing
}

struct ContentView: View {
    @State private var showAlert: Bool = false
    @State private var userService: UserServiceProtocol
    
    init(appState: AppState) {
        self._userService = State(initialValue: MockUserService(testResponse: nil))
        if appState == AppState.testing {
            _userService = State(initialValue: MockUserService(testResponse: nil))
        } else if appState == AppState.production {
            _userService = State(initialValue: UserService(urlString: "https://jsonplaceholder.typicode.com/users"))
        }
        print(userService)
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                NavigationLink(destination: UsersIndexView(userService: userService), label: {
                    Text("Chat with User")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: 300)
                        .foregroundColor(.purple)
                        .background(Color.purple.opacity(0.5))
                        .cornerRadius(30)
                        .accessibilityIdentifier("navigationToUsersIndex")
                })
                
                Button(action: {
                    showAlert.toggle()
                }, label: {
                    Text("Show Alert!")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: 300)
                        .foregroundColor(.red)
                        .background(Color.red.opacity(0.4))
                        .cornerRadius(30)
                })
                .accessibilityIdentifier("showAlertButton")
                .alert(isPresented: $showAlert, content: {
                    return Alert(title: Text("Alert!!!"))
                })
            }
            .padding()
            .navigationTitle("Chat Bot Home")
        }
        
        
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(appState: AppState.testing)
    }
}
