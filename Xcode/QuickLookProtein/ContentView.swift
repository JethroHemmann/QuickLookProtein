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
    @AppStorage("atomStyleCIF", store: UserDefaults(suiteName: "W3SKSV7VPT.group.com.jethrohemmann.QuickLookProtein"))
    private var atomStyleCIF: Settings.AtomStyle = .stick
    
    @AppStorage("atomStylePDB", store: UserDefaults(suiteName: "W3SKSV7VPT.group.com.jethrohemmann.QuickLookProtein"))
    private var atomStylePDB: Settings.AtomStyle = .cartoon
    
    @AppStorage("atomStyleSDF", store: UserDefaults(suiteName: "W3SKSV7VPT.group.com.jethrohemmann.QuickLookProtein"))
    private var atomStyleSDF: Settings.AtomStyle = .stick
    
    @AppStorage("rotationSpeed", store: UserDefaults(suiteName: "W3SKSV7VPT.group.com.jethrohemmann.QuickLookProtein"))
    private var rotationSpeed: Settings.RotationSpeed = .medium
    
    @AppStorage("bgColor", store: UserDefaults(suiteName: "W3SKSV7VPT.group.com.jethrohemmann.QuickLookProtein"))
    private var bgColor: Color = Color(.sRGB, red: 0, green: 0, blue: 0, opacity: 0)
    
    var body: some View {
        let htmlPath = Bundle.main.path(forResource: "3Dmol_viewer", ofType: "html")
        let pdbPath = Bundle.main.path(forResource: "6oc6", ofType: "pdb")
        let cifPath = Bundle.main.path(forResource: "1565673", ofType: "cif")
        let sdfPath = Bundle.main.path(forResource: "PQQ", ofType: "sdf")
        
        let htmlPDB = prepare3DmolHTML(htmlPath: htmlPath!, pdbPath: pdbPath!, dataFormat: "pdb", atomStyle: atomStylePDB, rotationSpeed: rotationSpeed, bgColor: bgColor)
        let htmlCIF = prepare3DmolHTML(htmlPath: htmlPath!, pdbPath: cifPath!, dataFormat: "cif", atomStyle: atomStyleCIF, rotationSpeed: rotationSpeed, bgColor: bgColor)
        let htmlSDF = prepare3DmolHTML(htmlPath: htmlPath!, pdbPath: sdfPath!, dataFormat: "sdf", atomStyle: atomStyleSDF, rotationSpeed: rotationSpeed, bgColor: bgColor)
        
        let baseUrl = URL(fileURLWithPath: htmlPath!)
        
        GeometryReader { geometry in
            VStack {
                HStack {
                    VStack { // settings VStack
                        Text("Settings").font(.title).padding()
                        Text("Atom display styles (for each file type)").font(.headline)
                        
                        Form {
                            Picker("PDB:", selection: $atomStylePDB) {
                                ForEach(Settings.AtomStyle.allCases) { style in
                                    Text(style.rawValue)
                                }
                            }
                            Picker("CIF:", selection: $atomStyleCIF) {
                                ForEach(Settings.AtomStyle.allCases) { style in
                                    Text(style.rawValue)
                                }
                            }
                            Picker("SDF:", selection: $atomStyleSDF) {
                                ForEach(Settings.AtomStyle.allCases) { style in
                                    Text(style.rawValue)
                                }
                            }
                        }.padding()
                        
                        Text("General display settings").font(.headline)
                        
                        Form {
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
                        }.padding()
                    } // end settings VStack
                    
                    VStack {
                        Text("About QuickLookProtein").font(.title).padding()
                        Text("Developed  2021-2022 by Jethro Hemmann.")
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
                        
                        Text("Credits 3Dmol.js").font(.title2).padding()
                        Text("The rendering of the 3D model is performed using the 3Dmol.js library developed by Nicholas Rego and David Koes.")
                            .fixedSize(horizontal: false, vertical: true)
                        Link("https://3dmol.csb.pitt.edu", destination: URL(string: "https://3dmol.csb.pitt.edu")!)
                        
                    }.padding() // end VStack About
                } // end HStack
                
                Divider()
                
                HStack {
                    // add 3dmol preview
                    VStack {
                        WebView(html: htmlPDB, baseUrl: baseUrl)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .ignoresSafeArea() // https://stackoverflow.com/questions/65333532/wkwebview-shows-white-bar-until-window-moved-resized
                        Text("PDB")
                        Group {
                            Text("XoxF from ") + Text("M. extorquens").italic() + Text(" (PDB ID: 6OC6)")
                        }.font(.caption)
                    }
                    
                    VStack {
                        WebView(html: htmlCIF, baseUrl: baseUrl)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .ignoresSafeArea()
                        Text("CIF")
                        Text("Bioinspired nonheme iron complex (COG ID: 1565673)").font(.caption)
                    }
                    
                    VStack {
                        WebView(html: htmlSDF, baseUrl: baseUrl)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .ignoresSafeArea()
                        Text("SDF")
                        Text("Pyrroloquinoline quinone (PubChem CID: 1024)").font(.caption)
                    }
                }
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
