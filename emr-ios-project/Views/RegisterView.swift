//
//  RegisterView.swift
//  emr-ios-project
//
//  Created by Malay Joshi on 4/28/22.
//

import SwiftUI



struct RegisterView: View {
    
    @State var email:String = ""
    @State var password:String = ""
    @State var confPassword:String = ""
    @State var errorMessage:String? = ""
    @State var type = "patient"
    var types = ["patient","doctor"]
    @State var id = 0
    @State var selection:String? = nil
    
    var body: some View {
        VStack{
            NavigationLink(destination: LoginView(), tag: "login", selection: $selection ){
            }
            
            NavigationLink(destination: PatientDetailsView(id:id), tag: "patient-profile", selection: $selection ){
            }
            
            NavigationLink(destination: DoctorDetailsView(id:id), tag: "doctor-profile", selection: $selection ){
            }
            
            Text("Register").padding()
            TextField("Email", text: $email).padding().textInputAutocapitalization(.never)
            
            SecureField("Password", text: $password).padding()
            
            SecureField("Confirm password", text: $confPassword).padding()
            
            HStack{
                Text("Select User:")
                
                Picker("User", selection: $type) {
                    ForEach(types, id: \.self) {
                        Text($0)
                    }
                }
            }.padding()
            
            Text(errorMessage!).foregroundColor(.red)
            Group{
                Button(action: { signUp() }){
                    Text("Sign Up")
                }.padding()
                
                Button(action: { selection = "login" }){
                    Text("Login")
                }.padding()
               
            }
            
            
        }.navigationBarBackButtonHidden(true)
    }
    
    func signUp(){
        if !email.isEmpty && !password.isEmpty && !confPassword.isEmpty &&  password == confPassword{
            
            let cred:Credentials = Credentials(email: email, password: password)
            
            
            let url = URL(string: "http://localhost:8080/api/register")
            guard let requestUrl = url else { fatalError() }
            var request = URLRequest(url: requestUrl)
            request.httpMethod = "POST"
            // Set HTTP Request Header
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let jsonData = try? JSONEncoder().encode(cred)
            
            request.httpBody = jsonData
                let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                    
                    if let error = error {
                        print("Error took place \(error)")
                        return
                    }
                    guard let data = data else {return}
                    do{
                        let response = try JSONDecoder().decode(RegisterResponse.self, from: data)
                        if response.id == nil {
                            errorMessage = response.message
                        }else{
                                
                            id = response.id!
                            if type == "patient" {
                                selection = "patient-profile"
                            }
                            if type == "doctor" {
                                selection = "doctor-profile"
                            }
                            
                            
                        }
                        
                    }catch let err{
                        print(err.localizedDescription)
                        print(err)
                   }
             
            }
            task.resume()
            
        }
        
        
        
    }
    
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
