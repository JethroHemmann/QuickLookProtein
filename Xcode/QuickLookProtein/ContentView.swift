//
//  ContentView.swift
//  QuickLookProtein
//
//  Created by Jethro Hemmann on 15.08.21.
//

import SwiftUI
import WebKit

struct ContentView: View {
    
    // Get/store settings
    @AppStorage("atomStyle", store: UserDefaults(suiteName: "W3SKSV7VPT.group.com.jethrohemmann.QuickLookProtein"))
    private var atomStyle: Settings.AtomStyle = .cartoon
    
    @AppStorage("rotationSpeed", store: UserDefaults(suiteName: "W3SKSV7VPT.group.com.jethrohemmann.QuickLookProtein"))
    private var rotationSpeed: Settings.RotationSpeed = .medium
    
    @AppStorage("bgColor", store: UserDefaults(suiteName: "W3SKSV7VPT.group.com.jethrohemmann.QuickLookProtein"))
    private var bgColor: Color = Color(.sRGB, red: 0, green: 0, blue: 0, opacity: 0)
        
    var body: some View {
        let htmlPath = Bundle.main.path(forResource: "3Dmol_viewer", ofType: "html")
        let pdbPath = Bundle.main.path(forResource: "6S6Y_1heterotetramer", ofType: "pdb")
        
        let html = prepare3DmolHTML(htmlPath: htmlPath!, pdbPath: pdbPath!, dataFormat: "pdb", atomStyle: atomStyle, rotationSpeed: rotationSpeed, bgColor: bgColor)
        let baseUrl = URL(fileURLWithPath: htmlPath!)
        
        HStack {
            VStack {
                Text("Settings")
                    .font(.title)
                
                Form {
                    Picker("Atom display style:", selection: $atomStyle) {
                        ForEach(Settings.AtomStyle.allCases) { style in
                            Text(style.rawValue)
                        }
                    }
                    
                    Picker("Rotation speed:", selection: $rotationSpeed) {
                        ForEach(Settings.RotationSpeed.allCases) { speed in
                            Text(String(speed.rawValue))
                        }
                    }
                    
                    HStack {
                        ColorPicker("Background color:", selection: $bgColor, supportsOpacity: true)
                            .help("#" + convertColorToRGB(color: bgColor).rgbHex + ", alpha: " + convertColorToRGB(color: bgColor).alpha)
                        Button(action: resetColor) {
                            Text("Reset color to transparent")
                        }
                    }
                    
//                    HStack {
//                        Text("Custom 3Dmol style:")
//                        TextField("{cartoon: {tubes: true}}", text: $customStyle)
//                            .disableAutocorrection(true)
//                    }
                }
                .padding()
                
                Divider()
                
                VStack {
                    Text("About QuickLookProtein")
                        .font(.title)
                    Text("Developed in 2021 by Jethro Hemmann.")
                    Link("https://github.com/JethroHemmann/QuickLookProtein", destination: URL(string: "https://github.com/JethroHemmann/QuickLookProtein")!)
                    
                    if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                        Text("Installed version: " + appVersion)
                        let appVersionArr = appVersion.split(separator: ".")
                        let appMajor = Int(appVersionArr[0])!
                        let appMinor = Int(appVersionArr[1])!

                        if let mostRecentVersion = getNewestVersion() {
                            if newerVersion(installedVersion: (major: appMajor, minor: appMinor), mostRecentVersion: mostRecentVersion) {
                                HStack {
                                    Text("There is a new version \(mostRecentVersion.major).\(mostRecentVersion.minor) available.")
                                    Link("Update now", destination: URL(string: "https://github.com/JethroHemmann/QuickLookProtein/releases")!)
                                }
                            }
                            else {
                                Text("No newer version is currently available online.")
                            }
                        }
                        else {
                            Text("Error while checking online for most recent version.")
                        }
                    }
                    
                }
                .padding()
                VStack {
                    Text("Credits 3Dmol.js")
                        .font(.title2)
                    Text("The rendering of the 3D model is performed using the 3Dmol.js library developed by Nicholas Rego and David Koes.")
                        .fixedSize(horizontal: false, vertical: true)
                    Link("https://3dmol.csb.pitt.edu", destination: URL(string: "https://3dmol.csb.pitt.edu")!)
                }
                .padding()
            }
            
            VStack {
                // add 3dmol preview
                WebView(html: html, baseUrl: baseUrl)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea() // https://stackoverflow.com/questions/65333532/wkwebview-shows-white-bar-until-window-moved-resized
                Group {
                    Text("Formyltransferase/hydrolase complex from ") + Text("Methylorubrum extorquens").italic()
                    Text("PDB ID: 6S6Y")
                }
                .font(.caption)
            }
        }
    }
    
    func resetColor() {
        bgColor = Color(.sRGB, red: 0, green: 0, blue: 0, opacity: 0)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


// https://stackoverflow.com/questions/60945972/why-does-my-wkwebview-not-show-up-in-a-swiftui-view
struct WebView: NSViewRepresentable {
    
    let view: WKWebView = WKWebView()
    
    var html: String
    var baseUrl: URL
    
    
    func makeNSView(context: Context) -> WKWebView {
        self.view.setValue(false, forKeyPath: "drawsBackground") // to allow transparent background
        return view
    }
    
    func updateNSView(_ view: WKWebView, context: Context) {
        view.loadHTMLString(html, baseURL: baseUrl)
    }
    
}
