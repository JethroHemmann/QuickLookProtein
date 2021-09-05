//
//  SharedFunctions.swift
//  QuickLookProtein
//
//  Created by Jethro Hemmann on 22.08.21.
//

import Foundation
import SwiftUI

func prepare3DmolHTML(htmlPath: String, pdbPath: String, dataFormat: String, atomStyle: Settings.AtomStyle, rotationSpeed: Settings.RotationSpeed, bgColor: Color) -> String {
    var html: String

    do {
        html = try String(contentsOfFile: htmlPath, encoding: .utf8)
        
        var pdb = try String(contentsOfFile: pdbPath)
        
        // prevent some HTML/JS injection attacks
        pdb = pdb.replacingOccurrences(of: "`", with: "")
        pdb = pdb.replacingOccurrences(of: "\"", with: "")
        pdb = pdb.replacingOccurrences(of: "'", with: "")
        pdb = pdb.replacingOccurrences(of: "//", with: "")
        pdb = pdb.replacingOccurrences(of: "/*", with: "")
        pdb = pdb.replacingOccurrences(of: "*/", with: "")

        
        html = html.replacingOccurrences(of: "{PDB_DATA}", with: pdb)
    }
    catch {
        html = "Error while loading HTML or PDB"
    }

    html = html.replacingOccurrences(of: "{ATOM_STYLE}", with: String(describing: atomStyle))
    html = html.replacingOccurrences(of: "{BG_COLOR}", with: convertColorToRGB(color: bgColor).rgbHex)
    html = html.replacingOccurrences(of: "{BG_ALPHA}", with: convertColorToRGB(color: bgColor).alpha)
    html = html.replacingOccurrences(of: "{ROTATION_SPEED}", with: String(rotationSpeed.rotationSpeedNumber()))
    html = html.replacingOccurrences(of: "{DATA_FORMAT}", with: dataFormat)
    
    return html
}


// https://gist.github.com/gobijan/d724de27e2aff8131676
func convertColorToRGB(color: Color) -> (rgbHex: String, alpha: String) {
    let nsColor: NSColor = NSColor(color)
    
    // convert to CIColor to prevent crash when using colors of a different color space
    // https://stackoverflow.com/questions/15682923/convert-nscolor-to-rgb
    let ciColor: CIColor = CIColor(color: nsColor)!
    
    let rInt = Int((ciColor.red * 255.99999))
    let gInt = Int((ciColor.green * 255.99999))
    let bInt = Int((ciColor.blue * 255.99999))
    
    let alpha = ciColor.alpha
    
    // Convert the numbers to hex strings
    let rHex = String(format:"%02X", rInt)
    let gHex = String(format:"%02X", gInt)
    let bHex = String(format:"%02X", bInt)
    
    let hexColor = rHex+gHex+bHex
    
    return (hexColor, "\(alpha)")
}


// Allow Color to be stored using @AppStorage
// https://medium.com/geekculture/using-appstorage-with-swiftui-colors-and-some-nskeyedarchiver-magic-a38038383c5e
extension Color: RawRepresentable {

    public init?(rawValue: String) {
        
        guard let data = Data(base64Encoded: rawValue) else {
            self = .black
            return
        }
        
        do {
            let color = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? NSColor ?? .black
            self = Color(color)
        } catch{
            self = .black
        }
        
    }

    public var rawValue: String {
        
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: NSColor(self), requiringSecureCoding: false) as Data
            return data.base64EncodedString()
            
        } catch{
            return ""
        }
        
    }

}
