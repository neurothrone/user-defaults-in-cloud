//
//  ContentView.swift
//  NSUbiquitousKeyValueStoreSandbox
//
//  Created by Zaid Neurothrone on 2022-12-18.
//

import SwiftUI

struct ContentView: View {
  @StateObject private var cloudUserDefaults: CloudUserDefaults = .shared
  
  var body: some View {
    VStack {
      Text("Select a Weekly Goal")
      
      Picker("Weekly Goal", selection: $cloudUserDefaults.weeklyGoal) {
        ForEach(WeeklyGoal.allCases) { goal in
          Text(goal.label)
        }
      }
#if os(watchOS)
      .pickerStyle(.navigationLink)
#endif
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
