//
//  DoctorView.swift
//  emr-ios-project
//
//  Created by Malay Joshi on 4/28/22.
//

import SwiftUI

struct DoctorMenu: View {
    
    @State var selection:String? = nil
    
    var body: some View {
        HStack{
            
            NavigationLink(destination: LoginView(), tag: "login", selection: $selection){
            }
            
            NavigationLink(destination: AppointmentsView(), tag: "doctor-home", selection: $selection){
            }
            
            NavigationLink(destination: PatientSearchView(), tag: "patient-search", selection: $selection){
            }
            
            Menu("Menu"){
                Button("Appointments",action: {selection = "doctor-home"})
                Button("Search Patients",action: {selection = "patient-search"})
                Button("Logout",action: {logout()})
            }
            
        }
        
        
    }
    
    func logout(){
        KeychainHelper.standard.delete(service: "token", account: "emr")
        KeychainHelper.standard.delete(service: "name", account: "emr")
        selection = "login"
        
    }
    
}

struct DoctorView_Previews: PreviewProvider {
    static var previews: some View {
        DoctorMenu()
    }
}
