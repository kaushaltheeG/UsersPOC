//
//  UserModel.swift
//  UsersPOC
//
//  Created by Kaushal Kumbagowdana on 6/13/23.
//

import Foundation

struct UserModel: Codable, Identifiable {
    var id: Int
    var name: String
    var username: String
    var email: String
}
