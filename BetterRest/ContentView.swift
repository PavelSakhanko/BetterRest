//
//  ContentView.swift
//  BetterRest
//
//  Created by Pavel Sakhanko on 17.01.21.
//

import SwiftUI

struct ContentView: View {
    
    @State private var wakeUp = Date()
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    var body: some View {
        NavigationView {
            VStack {
                Text("When do you want to wake up?")
                    .font(.headline)
                DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                
                Text("Desired amount of sleep")
                    .font(.headline)
                Stepper(value: $sleepAmount, in: 4...12, step: 0.25) {
                    Text("\(sleepAmount, specifier: "%g") hours")
                }
                
                Text("Daily coffee intake")
                    .font(.headline)
                Stepper(value: $coffeeAmount, in: 1...20) {
                    Text("\(coffeeAmount) \(coffeeAmount == 1 ? "cup" : "cups")")
                }
            }
            .navigationBarItems(trailing:
                Button(action: calculateBedtime) {
                    Text("Calculate")
                }
            )
        }
    }
    func calculateBedtime() {
        print("Calculate")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
