//
//  Settings.swift
//  QuickLookProtein
//
//  Created by Jethro Hemmann on 22.08.21.
//

import Foundation
import SwiftUI

class SettingsStorage: ObservableObject {
    
    @AppStorage("atomStyleCIF", store: UserDefaults(suiteName: "W3SKSV7VPT.group.com.jethrohemmann.QuickLookProtein"))
    var atomStyleCIF: Settings.AtomStyle = .stick
    
    @AppStorage("atomStylePDB", store: UserDefaults(suiteName: "W3SKSV7VPT.group.com.jethrohemmann.QuickLookProtein"))
    var atomStylePDB: Settings.AtomStyle = .cartoon
    
    @AppStorage("atomStyleSDF", store: UserDefaults(suiteName: "W3SKSV7VPT.group.com.jethrohemmann.QuickLookProtein"))
    var atomStyleSDF: Settings.AtomStyle = .stick
    
    @AppStorage("rotationSpeed", store: UserDefaults(suiteName: "W3SKSV7VPT.group.com.jethrohemmann.QuickLookProtein"))
    var rotationSpeed: Settings.RotationSpeed = .medium
    
    @AppStorage("bgColor", store: UserDefaults(suiteName: "W3SKSV7VPT.group.com.jethrohemmann.QuickLookProtein"))
    var bgColor: Color = Color(.sRGB, red: 0, green: 0, blue: 0, opacity: 0)
    
}

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
