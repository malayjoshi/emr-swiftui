//
//  AppointmentsView.swift
//  emr-ios-project
//
//  Created by Malay Joshi on 4/30/22.
//

import SwiftUI

struct AppointmentsView: View {
    
    @State var list:[Appointment] = []
    @State var selection:String? = nil
    
    var body: some View {
        VStack{
            
            NavigationLink(destination: LoginView(), tag: "login", selection: $selection){}
            
            Text("Appointments").bold().padding()
            
            List{
                ForEach(list,id:\.id){
                    appt in
                    NavigationLink(destination: PrescriptionView(appt: appt), tag: "prescription", selection: $selection){
                        Text("\(appt.fullName), \(appt.sex), DOB: \(appt.dob)")
                    }
                     
                }.onDelete{
                    indexSet in indexSet.forEach{
                        index in
                        
                        let url = URL(string: "http://localhost:8080/api/appointment/\(list[index].id)")
                        guard let requestUrl = url else { fatalError() }
                        var request = URLRequest(url: requestUrl)
                        request.httpMethod = "POST"
                        // Set HTTP Request Header
                        request.setValue("application/json", forHTTPHeaderField: "Accept")
                        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                        let token = KeychainHelper.standard.read(service: "token", account: "emr")!
                        let accessToken = String(data: token, encoding: .utf8)!
                        request.setValue( "Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
                            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                                
                                if let error = error {
                                    print("Error took place \(error)")
                                    return
                                }
                                guard let data = data else {return}
                                do{
                                    let decoder =  JSONDecoder()
                                    
                                    
                                    let response = try decoder.decode(DeleteResponse.self, from: data)
                                    
                                    if(response.deleted){
                                        list.remove(at: index)
                                    }
                                    
                                }catch let err{
                                    print(err.localizedDescription)
                                    print(err)
                                    selection = "login"
                               }
                         
                        }
                        task.resume()
                    }
                }
            }.padding()
        }.toolbar {
            ToolbarItem(placement: .navigationBarTrailing){
                DoctorMenu()
            }
            
        }.navigationBarBackButtonHidden(true).onAppear{
            getAppt()
        }
        
    }
    
    func getAppt(){
        
        let url = URL(string: "http://localhost:8080/api/appointment")
        guard let requestUrl = url else { fatalError() }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        // Set HTTP Request Header
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let token = KeychainHelper.standard.read(service: "token", account: "emr")!
        let accessToken = String(data: token, encoding: .utf8)!
        request.setValue( "Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                if let error = error {
                    print("Error took place \(error)")
                    return
                }
                guard let data = data else {return}
                do{
                    let decoder =  JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    
                    let response = try decoder.decode([Appointment].self, from: data)
                    print(response.count)
                    list = response
                }catch let err{
                    print(err.localizedDescription)
                    print(err)
                    selection = "login"
               }
         
        }
        task.resume()
        
    }
    
    
}

struct AppointmentsView_Previews: PreviewProvider {
    static var previews: some View {
        AppointmentsView()
    }
}
