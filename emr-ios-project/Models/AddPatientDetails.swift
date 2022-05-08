//
//  AddPatientDetails.swift
//  emr-ios-project
//
//  Created by Malay Joshi on 4/28/22.
//

import Foundation

struct AddPatientDetails:Codable{
    var givenName:String
    var lastName:String
    var mobile:String
    var sex:String
    var dob:Date
}
