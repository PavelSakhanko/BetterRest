//
//  ContentView.swift
//  BetterRest
//
//  Created by Pavel Sakhanko on 17.01.21.
//

import SwiftUI
import CoreML

struct ContentView: View {
    
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1...40
    @State private var currentCoffeeValue = 1
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false

    var body: some View {
        NavigationView {
            Form {
                Section(header:
                        Text("When do you want to wake up?")
                ) {
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .datePickerStyle(WheelDatePickerStyle())
                }
                
                Section(header:
                    Text("Desired amount of sleep")
                ) {
                    Stepper(value: $sleepAmount, in: 4...12, step: 0.25) {
                        Text("\(sleepAmount, specifier: "%g") hours")
                    }
                }
                
                Section(header:
                    Text("Daily coffee intake")
                ) {
                    Picker(selection: $currentCoffeeValue, label: Text("Number of coffee cup")) {
                        ForEach(0 ..< coffeeAmount.count) { number in
                            Text("\(number) \(number == 1 ? "cup" : "cups")")
                        }
                    }
                }
                
                Section(header:
                    Text("Your ideal bedtime is:")
                        .font(.headline)
                ) {
                    calculateBedtime()
                        .font(.largeTitle)
                        .foregroundColor(.red)
                }
            }
        }
    }

    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }

    func calculateBedtime() -> Text {
        let model = try? SleepCalculator(configuration: MLModelConfiguration())

        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60
        
        var returnValue = ""
        
        do {
            let prediction = try model?.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(currentCoffeeValue))

            let sleepTime = wakeUp - prediction!.actualSleep

            let formatter = DateFormatter()
            formatter.timeStyle = .short
            returnValue = formatter.string(from: sleepTime)
        } catch {
            returnValue = "Sorry, there was a problem calculating your bedtime."
        }
        return Text(returnValue)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
