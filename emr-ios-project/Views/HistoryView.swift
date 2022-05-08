//
//  HistoryView.swift
//  emr-ios-project
//
//  Created by Malay Joshi on 5/2/22.
//

import SwiftUI

struct HistoryView: View {
    var history:VisitDataCodable
    
    var body: some View {
        VStack{
            Form{
                Section(header: Text("Vitals")){
                        
                    
                    Text("BP: \(history.bp1!) / \(history.bp2!)")
                    Text("Pulse: \(history.pulse!)")
                    Text("SPO2: \(history.spo2!)")
                    Text("Temp: \(history.temp!)")
                    Text("Height: \(history.height!), Weight: \(history.weight!)").padding()
                    
                }
                
                Section(header: Text("Complaints")){
                    
                    ForEach(history.complaints, id:\.id){
                        comp in Text(comp.term)
                    }
                }
                
                Section(header: Text("Diagnosis")){
                    
                    ForEach(history.diagnosis, id:\.id){
                        diag in
                        Text("\(diag.term), Duration: \(diag.duration) \(diag.durationType)" )
                    }.padding()
                }
                
                Section(header: Text("Medicines")){
                    ForEach(history.medicines, id:\.id){
                        med in
                        Text("\(med.term), Duration: \(med.duration) \(med.durationType)" )
                    }
                }
                    
                Section(header: Text("Tests") ){
                    ForEach(history.tests, id:\.id){
                        test in Text(test.term)
                    }
                }
                    
                Section(header: Text("Advice")){
                    Text("\(history.advice ?? "")")
                }
                
            }
            
            
        }.toolbar {
            ToolbarItem(placement: .navigationBarTrailing){
                DoctorMenu()
            }
        }
    }

}

