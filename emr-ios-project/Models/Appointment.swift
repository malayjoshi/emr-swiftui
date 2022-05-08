//
//  Appointment.swift
//  emr-ios-project
//
//  Created by Malay Joshi on 4/30/22.
//

import Foundation

struct Appointment:Decodable {
    var patientId:Int
    var id:Int
    var time:String
    var fullName:String
    var sex:String
    var dob:String
}
