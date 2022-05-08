//
//  DoctorDetailsView.swift
//  emr-ios-project
//
//  Created by Malay Joshi on 4/29/22.
//

import SwiftUI

struct DoctorDetailsView: View {
    @State var fullName:String = ""
    @State var clinicName:String = ""
    @State var qualification:String = ""
    
    @State var errorMessage:String = ""
    @State var successMessage:String = ""
    var id:Int
    @State var selection:String? = nil
    
    var body: some View {
        
        VStack{
            NavigationLink(destination: LoginView(), tag: "login", selection: $selection ){
            }
            
            Form{
                Section(header:Text("Add Details")){
                    
                    TextField("Full Name",text: $fullName).textInputAutocapitalization(.never)
                    
                    TextField("Clinic Name",text: $clinicName).textInputAutocapitalization(.never)
                    
                    TextField("qualifications",text: $qualification)
                    HStack{
                            Spacer()
                        Button(action: { addDetails() }){
                            Text("Add Details")
                        }
                        Spacer()
                    }
                    
                }
            }
            
            Text(errorMessage).padding().foregroundColor(.red)
            Text(successMessage).padding().foregroundColor(.green)
            
        }.navigationBarBackButtonHidden(true)
        
    }
    
    func addDetails(){
        
        if !fullName.isEmpty && !clinicName.isEmpty && !qualification.isEmpty {
            let details = AddDoctorDetails(fullName: fullName, clinic: clinicName, qualification: qualification)
            print("http://localhost:8080/api/doctor-add/\(id)")
            let url = URL(string: "http://localhost:8080/api/doctor-add/\(id)")
            guard let requestUrl = url else { fatalError() }
            var request = URLRequest(url: requestUrl)
            request.httpMethod = "POST"
            // Set HTTP Request Header
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let encoder = JSONEncoder()
            //Like this
                encoder.dateEncodingStrategy = .iso8601
            let jsonData = try? encoder.encode(details)
            
            request.httpBody = jsonData
                let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                    
                    if let error = error {
                        print("Error took place \(error)")
                        return
                    }
                    guard let data = data else {return}
                    do{
                        let response = try JSONDecoder().decode(RegisterResponse.self, from: data)
                        print(response.message!)
                        successMessage = "Profile added!"
                        selection = "login"
                    }catch let err{
                        errorMessage = "Already registered"
                        print(err.localizedDescription)
                        print(err)
                   }
             
            }
            task.resume()
            
            
        }
        
    }
    
}

struct DoctorDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DoctorDetailsView(id:1)
    }
}
