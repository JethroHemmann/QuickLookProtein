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
    
    @State private var customStyle: String = ""
    
    var body: some View {
        let htmlPath = Bundle.main.path(forResource: "3Dmol_viewer", ofType: "html")
        let pdbPath = Bundle.main.path(forResource: "6S6Y_1dimer", ofType: "pdb")
        
        let html = prepare3DmolHTML(htmlPath: htmlPath!, pdbPath: pdbPath!, atomStyle: atomStyle, rotationSpeed: rotationSpeed, bgColor: bgColor)
        let baseUrl = URL(fileURLWithPath: htmlPath!)
        
        HStack {
            VStack {
                Text("Settings")
                    .font(.title)
                
                Form {
                    Picker("Atom style:", selection: $atomStyle) {
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
                    Text("Developed in 2021 by Jethro Hemmann (j.hemmann@gmail.com).")
                        .fixedSize(horizontal: false, vertical: true)
                    Link("http://www.github.com/xxx", destination: URL(string: "github.com")!)
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

