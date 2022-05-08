//
//  PatientHomeView.swift
//  emr-ios-project
//
//  Created by Malay Joshi on 4/29/22.
//

import SwiftUI

struct PatientHomeView: View {
    
    @State var visit:VisitDataCodable = VisitDataCodable(id: 0, patientId: 0, givenName: "", lastName: "", bp1: 0, bp2: 0, pulse: 0, height: 0, weight: 0, temp: 0, spo2: 0, advice: "", date: "", complaints: [], tests: [], medicines: [], diagnosis: [])
    
    var body: some View {
        VStack{
            
            ScrollView{
                
                GroupBox(label: Text("Vitals as of \(visit.date ?? "")")
                ){
                    
                    HStack{
                        Text("Pulse: \(visit.pulse!)")
                        Spacer()
                        Text("SPO2: \(visit.spo2!)")
                    }
                    
                    
                    
                    HStack{
                        Text("Temp: \(visit.temp!)")
                        Spacer()
                        Text("Height: \(visit.height!), Weight: \(visit.weight!)")
                        
                    }
                    
                }.cornerRadius(10)
                
                GroupBox(label: Text("Current Prescriptions") ){
                    ForEach(visit.medicines, id:\.id){
                        med in
                        HStack{
                            Text("\(med.term)" )
                            
                            Spacer()
                            
                            Text("Days Left: \(med.duration) \(med.durationType)" )
                        }
                        
                    }
                }.cornerRadius(10)
                
                GroupBox(label: Text("Recommended Tests")){
                    ForEach(visit.tests, id:\.id){
                        test in
                        HStack{
                            Text(test.term)
                            Spacer()
                        }
                         
                        
                    }
                }.cornerRadius(10)
                
                GroupBox(label:Text("Advice")){
                    HStack{
                        
                        Text("\(visit.advice ?? "")")
                        Spacer()
                    }
                }.cornerRadius(10)
                
                
            }
            
            
            
        }.toolbar {
            ToolbarItem(placement: .navigationBarTrailing){
                PatientMenu()
            }
            
        }.navigationBarBackButtonHidden(true).onAppear{
            
            let url = URL(string: "http://localhost:8080/api/history/medicines-adjusted-history")
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
                        
                        let response = try decoder.decode(VisitDataCodable.self, from: data)
                        visit = response
                    }catch let err{
                        print(err.localizedDescription)
                        print(err)
                        
                   }
             
            }
            task.resume()
        
        }.navigationTitle("Hello, \(visit.givenName ?? "") \(visit.lastName ?? "")")
        
        


            
    }
    
    
}

