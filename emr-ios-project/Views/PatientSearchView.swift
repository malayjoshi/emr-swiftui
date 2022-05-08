//
//  PatientSearchView.swift
//  emr-ios-project
//
//  Created by Malay Joshi on 4/29/22.
//

import SwiftUI

struct PatientSearchView: View {
    @State private var term = ""
    
    @State var patients:[PatientModel] = []
    
    var body: some View {
        VStack{
            Form{
                Section(header: Text("Search for patients")){
                    
                    TextField("Search",text: $term).onChange(of: term ){
                        Void in
                        if !term.isEmpty {
                            
                            print("http://localhost:8080/api/patient?term=\(term)")
                            let url = URL(string: "http://localhost:8080/api/patient?term=\(term)")
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
                                        
                                        let response = try decoder.decode([PatientModel].self, from: data)
                                        print(response.count)
                                        patients = response
                                    }catch let err{
                                        print(err.localizedDescription)
                                        print(err)
                                        
                                   }
                             
                            }
                            task.resume()
                            
                        }else{
                            patients = []
                        }
                    }
                    
                    
                }
                
                Section(header:Text("") ){
                    ForEach(patients, id:\.id){
                        patient in NavigationLink(destination: PatientView(patient: patient)){
                            PatientRow(model: patient)
                        }
                }
                }
            }
            
            
    }.toolbar {
        ToolbarItem(placement: .navigationBarTrailing){
            DoctorMenu()
        }
        
    }.navigationBarBackButtonHidden(true)
    
    }
    
}

struct PatientSearchView_Previews: PreviewProvider {
    static var previews: some View {
        PatientSearchView()
    }
}
