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
    
    // store colors
    @AppStorage("bgColorRed", store: UserDefaults(suiteName: "W3SKSV7VPT.group.com.jethrohemmann.QuickLookProtein"))
    var bgColorRed: Double = 0.0
    @AppStorage("bgColorGreen", store: UserDefaults(suiteName: "W3SKSV7VPT.group.com.jethrohemmann.QuickLookProtein"))
    var bgColorGreen: Double = 0.0
    @AppStorage("bgColorBlue", store: UserDefaults(suiteName: "W3SKSV7VPT.group.com.jethrohemmann.QuickLookProtein"))
    var bgColorBlue: Double = 0.0
    @AppStorage("bgColorOpacity", store: UserDefaults(suiteName: "W3SKSV7VPT.group.com.jethrohemmann.QuickLookProtein"))
    var bgColorOpacity: Double = 0.0
    
    var bgColor: Color {
        get {
            Color(.sRGB, red: bgColorRed, green: bgColorGreen, blue: bgColorBlue, opacity: bgColorOpacity)
        }
        set {
            bgColorRed = newValue.components.red
            bgColorGreen = newValue.components.green
            bgColorBlue = newValue.components.blue
            bgColorOpacity = newValue.components.opacity
        }
    }
    
}

extension Color {
    var components: (red: Double, green: Double, blue: Double, opacity: Double) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var opacity: CGFloat = 0
        NSColor(self).getRed(&red, green: &green, blue: &blue, alpha: &opacity)
        return (Double(red), Double(green), Double(blue), Double(opacity))
    }
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
