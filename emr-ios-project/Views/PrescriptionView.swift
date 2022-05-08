//
//  PrescriptionView.swift
//  emr-ios-project
//
//  Created by Malay Joshi on 4/30/22.
//

import SwiftUI

struct PrescriptionView: View {
    var appt:Appointment
    var durationTypes = ["DAYS","WEEKS","MONTHS","YEARS"]
    @State var data:VisitData = VisitData(patientId: 0, bp1: 0, bp2: 0, pulse: 0, height: 0,weight: 0, temp: 0, spo2: 0, advice: "", complaints: [], tests: [], medicines: [], diagnosis: [] )
    
    @State var list:[Generic] = []
    @State var success:String = ""
    @State var error:String = ""
    
    var body: some View {
        VStack{
            
            Text("ID: \(appt.patientId)")
                Text("Name - \(appt.fullName)")
                Form {
                    
                    Section(header: Text("Vitals")){
                        HStack{
                            Text("BP")
                            Spacer()
                            TextField("",value:$data.bp1,formatter: NumberFormatter()).keyboardType(UIKeyboardType.decimalPad).frame(width: 50).border(.black, width: 1)
                            Text(" / ")
                            TextField("",value:$data.bp2,formatter: NumberFormatter()).keyboardType(UIKeyboardType.decimalPad).frame(width: 50).border(.black, width: 1)
                        }
                        HStack{
                            Text("Pulse")
                            Spacer()
                            TextField("",value:$data.pulse,formatter: NumberFormatter()).keyboardType(UIKeyboardType.decimalPad).frame(width: 50).border(.black, width: 1)
                            
                        }
                        HStack{
                            Text("Height")
                            
                            TextField("",value:$data.height,formatter: NumberFormatter()).keyboardType(UIKeyboardType.decimalPad).frame(width: 50).border(.black, width: 1)
                            Spacer()
                            
                            Text("Weight")
                            
                            TextField("",value:$data.weight,formatter: NumberFormatter()).keyboardType(UIKeyboardType.decimalPad).frame(width: 50).border(.black, width: 1)
                        }
                        HStack{
                            Text("Temp")
                            Spacer()
                            TextField("",value:$data.temp,formatter: NumberFormatter()).keyboardType(UIKeyboardType.decimalPad).frame(width: 50).border(.black, width: 1)
                        }
                        HStack{
                            Text("SPO2")
                            Spacer()
                            TextField("",value:$data.spo2,formatter: NumberFormatter()).keyboardType(UIKeyboardType.decimalPad).frame(width: 50).border(.black, width: 1)
                        }
                        
                        
                    }
                    
                    Section(header: Text("Complaints")){
                        
                    
                        ForEach($data.complaints, id: \.id){
                            $complaint in
                            DisclosureGroup(complaint.term, isExpanded: $complaint.reveal) {
                                TextField("Type here ...",text: $complaint.term).onChange(of: complaint.term ){
                                    term in
                                    
                                    if !term.isEmpty {
                                        let parameters = [
                                            "term": term,
                                            "type": "complaint"
                                        ]
                                        var uRLComponents = URLComponents(string: "http://localhost:8080/api/terms")!
                                        uRLComponents.queryItems = parameters.map({ (key, value) -> URLQueryItem in
                                            URLQueryItem(name: key, value: String(value))
                                        })
                                        
                                        let url = URL(string: uRLComponents.url!.absoluteString)
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
                                                    
                                                    let response = try decoder.decode([Generic].self, from: data)
                                                    print(response.count)
                                                    list = response
                                                }catch let err{
                                                    print(err.localizedDescription)
                                                    print(err)
                                                    
                                               }
                                         
                                        }
                                        task.resume()
                                        
                                    }else{
                                        list = []
                                    }
                                    
                                }
                                
                                List{
                                    ForEach(list,id:\.id){
                                        item in
                                        Button(action: { complaint.term = item.word }){
                                            Text(item.word)
                                        }
                                    }
                                }
                                
                    }
                            
                            
                }
                        Button(action: { data.complaints.append(Generic1(term:"")) }){
                            Text("Add")
                        }
            }
                    
            
                
                    Section(header: Text("Diagnosis")){
                        
                    
                        ForEach($data.diagnosis, id: \.id){
                            $diag in
                            DisclosureGroup(diag.term, isExpanded: $diag.reveal) {
                                HStack{
                                    Text("Duration")
                                    TextField("",value:$diag.duration,formatter: NumberFormatter()).keyboardType(UIKeyboardType.decimalPad)
                                    Spacer()
                                    Picker("", selection: $diag.durationType) {
                                        ForEach(durationTypes, id: \.self) {
                                            Text($0)
                                        }
                                    }
                                }
                                    
                                    
                                    TextField("Type here ...",text: $diag.term).onChange(of: diag.term ){
                                        term in
                                        
                                        if !term.isEmpty {
                                            
                                            let parameters = [
                                                "term": term,
                                                "type": "diagnosis"
                                            ]
                                            var uRLComponents = URLComponents(string: "http://localhost:8080/api/terms")!
                                            uRLComponents.queryItems = parameters.map({ (key, value) -> URLQueryItem in
                                                URLQueryItem(name: key, value: String(value))
                                            })
                                            
                                            let url = URL(string: uRLComponents.url!.absoluteString)
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
                                                        
                                                        let response = try decoder.decode([Generic].self, from: data)
                                                        print(response.count)
                                                        list = response
                                                    }catch let err{
                                                        print(err.localizedDescription)
                                                        print(err)
                                                        
                                                   }
                                             
                                            }
                                            task.resume()
                                            
                                        }else{
                                            list = []
                                        }
                                        
                                    }
                                    
                                    
                                        
                                    
                                
                                List{
                                    ForEach(list,id:\.id){
                                        item in
                                        Button(action: { diag.term = item.word }){
                                            Text(item.word)
                                        }
                                    }
                                }
                                
                                
                    }
                            
                            
                }
                        Button(action: { data.diagnosis.append(Generic2(term:"",duration: 0, durationType: "DAYS")) }){
                            Text("Add")
                        }
            }
                    
                    
                    
                        Section(header: Text("Medicines")){
                            
                        
                            ForEach($data.medicines, id: \.id){
                                $med in
                                DisclosureGroup(med.term, isExpanded: $med.reveal) {
                                    HStack{
                                        Text("Duration")
                                        TextField("",value:$med.duration,formatter: NumberFormatter()).keyboardType(UIKeyboardType.decimalPad)
                                        Spacer()
                                        Picker("", selection: $med.durationType) {
                                            ForEach(durationTypes, id: \.self) {
                                                Text($0)
                                            }
                                        }
                                    }
                                        
                                        
                                        TextField("Type here ...",text: $med.term).onChange(of: med.term ){
                                            term in
                                            
                                            if !term.isEmpty {
                                                
                                                let parameters = [
                                                    "term": term,
                                                    "type": "medicine"
                                                ]
                                                var uRLComponents = URLComponents(string: "http://localhost:8080/api/terms")!
                                                uRLComponents.queryItems = parameters.map({ (key, value) -> URLQueryItem in
                                                    URLQueryItem(name: key, value: String(value))
                                                })
                                                
                                                let url = URL(string: uRLComponents.url!.absoluteString)
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
                                                            
                                                            let response = try decoder.decode([Generic].self, from: data)
                                                            print(response.count)
                                                            list = response
                                                        }catch let err{
                                                            print(err.localizedDescription)
                                                            print(err)
                                                            
                                                       }
                                                 
                                                }
                                                task.resume()
                                                
                                            }else{
                                                list = []
                                            }
                                            
                                        }
                                        
                                        
                                            
                                        
                                    
                                    List{
                                        ForEach(list,id:\.id){
                                            item in
                                            Button(action: { med.term = item.word }){
                                                Text(item.word)
                                            }
                                        }
                                    }
                                    
                                    
                        }
                                
                                
                    }
                            Button(action: { data.medicines.append(Generic2(term:"",duration: 0, durationType: "DAYS")) }){
                                Text("Add")
                            }
                }
                    
                    
                    
                    
                    Section(header: Text("Tests required")){
                        
                    
                        ForEach($data.tests, id: \.id){
                            $test in
                            DisclosureGroup(test.term, isExpanded: $test.reveal) {
                                TextField("Type here ...",text: $test.term).onChange(of: test.term ){
                                    term in
                                    
                                    if !term.isEmpty {
                                        
                                        let parameters = [
                                            "term": term,
                                            "type": "test"
                                        ]
                                        var uRLComponents = URLComponents(string: "http://localhost:8080/api/terms")!
                                        uRLComponents.queryItems = parameters.map({ (key, value) -> URLQueryItem in
                                            URLQueryItem(name: key, value: String(value))
                                        })
                                        
                                        let url = URL(string: uRLComponents.url!.absoluteString)
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
                                                    
                                                    let response = try decoder.decode([Generic].self, from: data)
                                                    print(response.count)
                                                    list = response
                                                }catch let err{
                                                    print(err.localizedDescription)
                                                    print(err)
                                                    
                                               }
                                         
                                        }
                                        task.resume()
                                        
                                    }else{
                                        list = []
                                    }
                                    
                                }
                                
                                List{
                                    ForEach(list,id:\.id){
                                        item in
                                        Button(action: { test.term = item.word }){
                                            Text(item.word)
                                        }
                                    }
                                }
                                
                    }
                            
                            
                }
                        Button(action: { data.tests.append(Generic1(term:"")) }){
                            Text("Add")
                        }
            }
                    
                    Section(header: Text("Advice")){
                        TextField("Type here ...",text: $data.advice)
                    }
                    
                    
                    
                    
        }
            Text(success).foregroundColor(.green)
            Text(error).foregroundColor(.red)
            
            Button(action: { submitForm() } ){
                Text("Submit")
            }
        
    }.toolbar {
        ToolbarItem(placement: .navigationBarTrailing){
            DoctorMenu()
        }
            
    }
    }
        
        func submitForm(){
            
            error = ""
            success = ""
            
            var valid = true
            if data.bp1 < 0 || data.bp2 < 0 || data.pulse < 0 || data.height < 0 ||
                data.weight < 0 || data.temp < 0 || data.spo2 < 0 {
                valid = false
            }
            
            for comp in data.complaints {
                if comp.term.isEmpty {valid=false}
            }
            for test in data.tests {
                if test.term.isEmpty {valid=false}
            }
            for diag in data.diagnosis {
                if diag.term.isEmpty || diag.duration < 0  {valid=false}
            }
            for med in data.medicines {
                if med.term.isEmpty || med.duration < 0  {valid=false}
            }
            
            if valid {
                
                var dataCodable = VisitDataCodable(patientId: appt.patientId, bp1: data.bp1, bp2: data.bp2, pulse:data.pulse, height: data.height, weight:data.weight, temp:data.temp, spo2:data.spo2, advice:data.advice )
                
                var complaints:[Generic1Codable] = []
                var diagnosis:[Generic2Codable] = []
                var tests:[Generic1Codable] = []
                var medicines:[Generic2Codable] = []
                    
                
                for comp in data.complaints {
                    complaints.append( Generic1Codable(term: comp.term) )
                }
                for test in data.tests {
                    tests.append(Generic1Codable(term: test.term))
                }
                for diag in data.diagnosis {
                    diagnosis.append(Generic2Codable(term: diag.term, duration: diag.duration, durationType: diag.durationType))
                }
                for med in data.medicines {
                    medicines.append(Generic2Codable(term: med.term, duration: med.duration, durationType: med.durationType))
                }
                dataCodable.complaints = complaints
                dataCodable.medicines = medicines
                dataCodable.diagnosis = diagnosis
                dataCodable.tests = tests
                
                let url = URL(string: "http://localhost:8080/api/visit")
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
                let jsonData = try? encoder.encode(dataCodable)
                
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
                                success = "Data added!"
                            }
                            
                        }catch let err{
                            print(err.localizedDescription)
                            print(err)
                       }
                 
                }
                task.resume()
                
                
            }
            else{
                error = "One or more fields needs attention!"
            }
            
        }
        
        
}
    
struct PrescriptionView_Previews: PreviewProvider {
    static var previews: some View {
        PrescriptionView(appt: Appointment(patientId: 1, id: 1, time: "121212", fullName: "abc", sex: "male", dob: "21-21-12"))
    }
}

