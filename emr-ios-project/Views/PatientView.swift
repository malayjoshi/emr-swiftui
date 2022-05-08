//
//  PatientView.swift
//  emr-ios-project
//
//  Created by Malay Joshi on 4/29/22.
//

import SwiftUI

struct PatientView: View {
    var patient:PatientModel
    @State var time = Date.now
    @State var errorMessage = ""
    @State var selection:String? = nil
    @State var successMessage = ""
    
    var body: some View {
        VStack{
            
            NavigationLink(destination: LoginView(), tag: "login", selection: $selection ){
            }
            NavigationLink(destination: PatientHistoryView(patient:patient), tag: "history", selection: $selection ){
            }
            
            Group{
                GroupBox{
                    HStack{
                        Text("ID: \(patient.id)").padding()
                        Spacer()
                        Text("Name: \(patient.givenName) \(patient.lastName)").padding()
                    }
                    HStack{
                        Text("DOB: \(patient.dob)").padding()
                        Spacer()
                        Text("Sex: \(patient.sex)").padding()
                    }
                    
                    
                }
                
                Form{
                    Section(header:Text("Add appointment")){
                        
                        DatePicker("Pick a time ",selection: $time)
                        HStack{
                            Spacer()
                            
                            Button(action:{addAppointment()}){
                                Text("Add Appointment")
                            }
                            
                            Spacer()
                        }
                        
                    }
                    
                    Section{
                        HStack{
                                Spacer()
                            Button(action:{ selection = "history" }){
                                Text("View History")
                            }
                            Spacer()
                        }
                        
                    }
                }
               
                

            }
            
            
            Text(errorMessage).foregroundColor(.red).padding()
            
            Text(successMessage).foregroundColor(.green).padding()
            
            
        }.toolbar {
            ToolbarItem(placement: .navigationBarTrailing){
                DoctorMenu()
            }
            
        }
    }
    
    func addAppointment(){
        errorMessage = ""
        successMessage = ""
        let dto = AddAppointment(patientId: patient.id, time: time)
        
        let url = URL(string: "http://localhost:8080/api/appointment")
        guard let requestUrl = url else { fatalError() }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        // Set HTTP Request Header
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let token = KeychainHelper.standard.read(service: "token", account: "emr")!
        let accessToken = String(data: token, encoding: .utf8)!
        request.setValue( "Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let jsonData = try? encoder.encode(dto)
        
        request.httpBody = jsonData
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                if let error = error {
                    print("Error took place \(error)")
                    return
                }
                guard let data = data else {return}
                do{
                    let response = try JSONDecoder().decode(ProfileAddedResponse.self, from: data)
                    if response.added {
                        successMessage = "Appointment added!"
                    }
                    
                }catch let err{
                    errorMessage = "There is a conflict of time!"
                    print(err.localizedDescription)
                    print(err)
               }
         
        }
        task.resume()
    }
    
}

struct PatientView_Previews: PreviewProvider {
    
    static var previews: some View {
        PatientView(patient: PatientModel(givenName: "abc", lastName: "abc", dob: "2020-10-01", sex: "male", mobile: "47383545", id: 1))
    }
}
