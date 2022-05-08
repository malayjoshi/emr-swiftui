//
//  AuthResponse.swift
//  emr-ios-project
//
//  Created by Malay Joshi on 4/28/22.
//

import Foundation

struct AuthResponse: Decodable {
    var jwt:String
    var name:String
    var type:String
}
