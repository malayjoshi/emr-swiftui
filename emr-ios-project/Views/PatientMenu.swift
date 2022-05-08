//
//  PatientMenu.swift
//  emr-ios-project
//
//  Created by Malay Joshi on 5/2/22.
//

import SwiftUI

struct PatientMenu: View {
    @State var selection:String? = nil
    
    var body: some View {
        HStack{
            
            NavigationLink(destination: LoginView(), tag: "login", selection: $selection){
            }
            
            NavigationLink(destination: PatientHomeView(), tag: "patient-home", selection: $selection){
            }
            
            Menu("Menu"){
                Button("Home",action: {selection = "patient-home"})
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

struct PatientMenu_Previews: PreviewProvider {
    static var previews: some View {
        PatientMenu()
    }
}
