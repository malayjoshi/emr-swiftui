//
//  PatientHistoryView.swift
//  emr-ios-project
//
//  Created by Malay Joshi on 5/2/22.
//

import SwiftUI

struct PatientHistoryView: View {
    
    var patient:PatientModel
    @State var history:[VisitDataCodable] = []
   
    
    var body: some View {
        VStack{
            List{
                ForEach(history,id:\.id){
                    item in
                    NavigationLink(destination: HistoryView(history:item)){
                        HStack{
                            Text("RX# \(item.id ?? 0)")
                            Spacer()
                            Text("Date: \(item.date ?? "NA")")
                        }
                        
                    }
                }
            }
        }.toolbar {
            ToolbarItem(placement: .navigationBarTrailing){
                DoctorMenu()
            }
            
        }.navigationTitle(patient.givenName+" "+patient.lastName).onAppear{
           
            
            let url = URL(string: "http://localhost:8080/api/history/\(patient.id)")
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
                        
                        let response = try decoder.decode([VisitDataCodable].self, from: data)
                        history = response
                    }catch let err{
                        print(err.localizedDescription)
                        print(err)
                        
                   }
             
            }
            task.resume()
        }
        
        
    }
}

struct PatientHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        PatientHistoryView(patient: PatientModel(givenName: "abc", lastName: "name", dob: "2020-01-01", sex: "male", mobile: "67889989", id: 1))
    }
}
