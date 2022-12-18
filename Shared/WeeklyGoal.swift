//
//  WeeklyGoal.swift
//  NSUbiquitousKeyValueStoreSandbox
//
//  Created by Zaid Neurothrone on 2022-12-18.
//

import Foundation

enum WeeklyGoal: Int {
  case easy = 12,
       normal = 16,
       hard = 24
}

extension WeeklyGoal: Identifiable, CaseIterable {
  var id: Self { self }
  
  var label: String {
    switch self {
    case .easy:
      return "Easy"
    case .normal:
      return "Normal"
    case .hard:
      return "Hard"
    }
  }
}
