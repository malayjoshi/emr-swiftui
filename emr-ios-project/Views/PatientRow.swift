//
//  PatientRow.swift
//  emr-ios-project
//
//  Created by Malay Joshi on 4/29/22.
//

import SwiftUI

struct PatientRow: View {
    
    var model:PatientModel
    
    var body: some View {
        VStack(alignment:.leading){
            
                Text("Name: "+model.givenName+" "+model.lastName)
                Text("DOB: \(model.dob)")
                Text("Sex: "+model.sex)
                Text("Contact: \(model.mobile)")
            
        }
        
    }
}

struct PatientRow_Previews: PreviewProvider {
    static var previews: some View {
        PatientRow( model: PatientModel(givenName: "abc", lastName: "name", dob: "2020-01-01", sex: "male", mobile: "32312312321", id: 1) )
    }
}
