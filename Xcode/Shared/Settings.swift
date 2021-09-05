//
//  Settings.swift
//  QuickLookProtein
//
//  Created by Jethro Hemmann on 22.08.21.
//

import Foundation

struct Settings {
    enum AtomStyle: String, CaseIterable, Identifiable {
        case cartoon = "Cartoon"
        case line = "Line"
        case stick = "Stick"
        case sphere = "Sphere"
        
        var id: AtomStyle {
            return self
        }
    }
        
    enum RotationSpeed: String, CaseIterable, Identifiable {
        case noRotation = "No rotation"
        case slow = "Slow"
        case medium = "Medium"
        case fast = "Fast"
        
        var id: RotationSpeed {
            return self
        }
        
        func rotationSpeedNumber() -> Float {
            switch self {
            case .slow: return 0.5
            case .medium: return 1
            case .fast: return 2
            case .noRotation: return 0
            }
        }
    }
}
