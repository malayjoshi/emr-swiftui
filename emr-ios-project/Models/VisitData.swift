//
//  VisitData.swift
//  emr-ios-project
//
//  Created by Malay Joshi on 5/1/22.
//

import Foundation

struct VisitData {
    var patientId:Int
    var bp1:Int
    var bp2:Int
    var pulse:Int
    var height:Int
    var weight:Int
    var temp:Int
    var spo2:Int
    var advice:String
    var complaints:[Generic1] = []
    var tests:[Generic1] = []
    var medicines:[Generic2] = []
    var diagnosis:[Generic2] = []
}

struct Generic1{
    var id:UUID = UUID()
    var term:String
    var reveal:Bool = false
    
}

struct Generic2{
    var id:UUID = UUID()
    var term:String
    var duration:Int
    var durationType:String
    var reveal:Bool = false
   
}
