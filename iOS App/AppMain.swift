//
//  AppMain.swift
//  NSUbiquitousKeyValueStoreSandbox
//
//  Created by Zaid Neurothrone on 2022-12-18.
//

import SwiftUI

@main
struct AppMain: App {
  init() {
    CloudUserDefaults.shared.setUp()
  }
  
  var body: some Scene {
    WindowGroup {
      ContentView()
    }
  }
}
