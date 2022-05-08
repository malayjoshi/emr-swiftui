//
//  PatientModel.swift
//  emr-ios-project
//
//  Created by Malay Joshi on 4/29/22.
//

import Foundation
struct PatientModel:Decodable{
    var givenName:String
    var lastName:String
    var dob:String
    var sex:String
    var mobile:String
    var email:String?
    var id:Int
}
