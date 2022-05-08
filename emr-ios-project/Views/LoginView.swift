//
//  LoginView.swift
//  emr-ios-project
//
//  Created by Malay Joshi on 4/28/22.
//

import SwiftUI

struct LoginView: View {
    
    @State var email:String = ""
    @State var password:String = ""
    @State var errorMessage:String = ""
    @State var selection:String? = nil
   
    
    let defaults = UserDefaults.standard
    
    var body: some View {
        
            
            VStack{
                NavigationLink(destination: RegisterView(), tag: "register", selection: $selection ){
                }
                NavigationLink(destination: AppointmentsView() , tag: "doctor-home", selection: $selection ){
                }
                
                NavigationLink(destination: PatientHomeView(), tag: "patient-home", selection: $selection ){
                }
                Text("Login").bold().padding()
                
                TextField("Email",text: $email).padding().textInputAutocapitalization(.never)
                
                SecureField("Password",text: $password).padding()
                
                Text(errorMessage).padding().foregroundColor(.red)
                
                
                Button(action: { login() }){
                    Text("Sign In")
                }.padding()
                
                Button(action: { selection = "register" }){
                    Text("Register")
                }.padding()
            }.navigationBarBackButtonHidden(true)
            
        
    }
    
    func login(){
        if !email.isEmpty && !password.isEmpty {
            let cred:Credentials = Credentials(email: email, password: password)
            
            
            let url = URL(string: "http://localhost:8080/api/authenticate")
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
                        let response = try JSONDecoder().decode(AuthResponse.self, from: data)
                        
                        let token = Data(response.jwt.utf8)
                        
                        KeychainHelper.standard.save(token, service: "token", account: "emr")
                        
                        KeychainHelper.standard.save(Data(response.name.utf8), service: "name", account: "emr")
                        
                        if response.type == "doctor" {
                            selection = "doctor-home"
                        }
                        if response.type == "patient" {
                            selection = "patient-home"
                        }
                        
                        print(response.jwt)
                    }catch let err{
                        errorMessage = "Invalid credentials"
                        print(err.localizedDescription)
                        print(err)
                   }
             
            }
            task.resume()
        }
    }
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
