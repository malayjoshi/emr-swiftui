//
//  PatientDetailsView.swift
//  emr-ios-project
//
//  Created by Malay Joshi on 4/28/22.
//

import SwiftUI

struct PatientDetailsView: View {
    
    @State var givenName:String = ""
    @State var lastName:String = ""
    @State var sex:String = "male"
    @State var dob:Date = Date()
    @State var mobile:String = ""
    var sexes = ["male","female"]
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
                    
                    TextField("Given Name",text: $givenName).padding().textInputAutocapitalization(.never)
                    TextField("Last Name",text: $lastName).padding().textInputAutocapitalization(.never)
                    
                    Picker("Sex", selection: $sex) {
                        ForEach(sexes, id: \.self) {
                            Text($0)
                        }
                    }
                    
                    DatePicker(selection: $dob, in: ...Date(), displayedComponents: .date) {
                                    Text("Date Of Birth")
                    }
                    
                    TextField("Mobile",text: $mobile)
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
        
        if !givenName.isEmpty && !lastName.isEmpty && !mobile.isEmpty {
            let details = AddPatientDetails(givenName: givenName, lastName: lastName, mobile: mobile, sex: sex, dob: dob)
            print("http://localhost:8080/api/patient-add/\(id)")
            let url = URL(string: "http://localhost:8080/api/patient-add/\(id)")
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

struct PatientDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        PatientDetailsView(id:1)
    }
}
