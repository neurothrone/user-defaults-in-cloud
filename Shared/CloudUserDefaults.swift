//
//  CloudUserDefaults.swift
//  NSUbiquitousKeyValueStoreSandbox
//
//  Created by Zaid Neurothrone on 2022-12-18.
//

import Foundation
import SwiftUI

let weeklyGoalKey = "weeklyGoal"

final class CloudUserDefaults: ObservableObject {
  static var shared: CloudUserDefaults = .init()
  
  @AppStorage(weeklyGoalKey) var weeklyGoal: WeeklyGoal = .easy {
    willSet {
      objectWillChange.send()
    }
    didSet {
      NSUbiquitousKeyValueStore.default.set(weeklyGoal.rawValue, forKey: weeklyGoalKey)
    }
  }
  
  private var keyStore: NSUbiquitousKeyValueStore = .default
  
  private init() {}
  
  //MARK: - Setup
  
  func setUp() {
    UserDefaults.standard.register(defaults: [weeklyGoalKey: WeeklyGoal.easy.rawValue])
    
    registerToEvents()
    
    if NSUbiquitousKeyValueStore.default.synchronize() == false {
        fatalError("❌ -> This app was not built with the proper entitlement requests.")
    }
  }
  
  func registerToEvents() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(ubiquitousKeyValueStoreDidChange(_:)),
      name: NSUbiquitousKeyValueStore.didChangeExternallyNotification,
      object: NSUbiquitousKeyValueStore.default)
  }
  
  //MARK: - Persistence
  
  func deleteAllSettings() {
    keyStore.removeObject(forKey: weeklyGoalKey)
  }
  
  @objc
  func ubiquitousKeyValueStoreDidChange(_ notification: Notification) {
    guard let userInfo = notification.userInfo else { return }
    
    guard let reasonForChange = userInfo[NSUbiquitousKeyValueStoreChangeReasonKey] as? Int else { return }
    
    guard let keys = userInfo[NSUbiquitousKeyValueStoreChangedKeysKey] as? [String] else { return }
    
    // Check if any of the keys we care about were updated, and if so use the new value stored under that key.
    guard keys.contains(weeklyGoalKey) else { return }
    
    if reasonForChange == NSUbiquitousKeyValueStoreAccountChange {
      // User changed account, so fall back to UserDefaults
      return
    }
    
    // Replace the "weeklyGoal" with the value from the cloud, but *only* if it's a value we know how to interpret. It is important to validate any value that comes in through iCloud, because it could have been generated by a different version of your app.
    let weeklyGoalRawValue = keyStore.longLong(forKey: "weeklyGoal")
    if let weeklyGoal = WeeklyGoal(rawValue: Int(weeklyGoalRawValue)) {
      
      DispatchQueue.main.async {
        self.weeklyGoal = weeklyGoal
        print("✅ -> WeeklyGoal was updated on iCloud. Updating the weeklyGoal of this Device")
      }
      
      return
    }
  }
}
