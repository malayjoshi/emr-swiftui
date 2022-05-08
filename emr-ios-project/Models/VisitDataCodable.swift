//
//  VisitDataCodable.swift
//  emr-ios-project
//
//  Created by Malay Joshi on 5/1/22.
//

import Foundation

struct VisitDataCodable: Codable  {
    var id:Int?
    var patientId:Int
    var givenName:String?
    var lastName:String?
    var bp1:Int?
    var bp2:Int?
    var pulse:Int?
    var height:Int?
    var weight:Int?
    var temp:Int?
    var spo2:Int?
    var advice:String?
    var date:String?
    var complaints:[Generic1Codable] = []
    var tests:[Generic1Codable] = []
    var medicines:[Generic2Codable] = []
    var diagnosis:[Generic2Codable] = []
}

struct Generic1Codable: Codable{
    var id:Int?
    var term:String
    
    
}

struct Generic2Codable: Codable{
    var id:Int?
    var term:String
    var duration:Int
    var durationType:String
    
   
}
