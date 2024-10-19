//
//  PreviewViewController.swift
//  QLExtension
//
//  Created by Jethro Hemmann on 15.08.21.
//

import Cocoa
import Quartz
import WebKit
import SwiftUI

class PreviewViewController: NSViewController, QLPreviewingController, WKNavigationDelegate, WKUIDelegate {
    
    var webView: WKWebView?
    
    @StateObject private var userSettings = SettingsStorage()
    
    override var nibName: NSNib.Name? {
        return NSNib.Name("PreviewViewController")
    }
    
    override func loadView() {
        super.loadView()
        // Do any additional setup after loading the view.
        
        // define webkit view
        let webConfiguration = WKWebViewConfiguration()
        let webView: WKWebView
        webView = WKWebView(frame: view.bounds, configuration: webConfiguration)
        webView.autoresizingMask = [.height, .width]
        webView.setValue(false, forKeyPath: "drawsBackground")
        
        
        webView.navigationDelegate = self
        webView.uiDelegate = self
        self.view.addSubview(webView)
        self.webView = webView
    }
    
    
    /*
     * Implement this method and set QLSupportsSearchableItems to YES in the Info.plist of the extension if you support CoreSpotlight.
     *
     func preparePreviewOfSearchableItem(identifier: String, queryString: String?, completionHandler handler: @escaping (Error?) -> Void) {
     // Perform any setup necessary in order to prepare the view.
     
     // Call the completion handler so Quick Look knows that the preview is fully loaded.
     // Quick Look will display a loading spinner while the completion handler is not called.
     handler(nil)
     }
     */
    
    
    func preparePreviewOfFile(at url: URL, completionHandler handler: @escaping (Error?) -> Void) {
        
        // Add the supported content types to the QLSupportedContentTypes array in the Info.plist of the extension.
        
        // Perform any setup necessary in order to prepare the view.
        
        // Call the completion handler so Quick Look knows that the preview is fully loaded.
        // Quick Look will display a loading spinner while the completion handler is not called.
        
        let htmlPath = Bundle.main.path(forResource: "3Dmol_viewer", ofType: "html")
        let fileExtension = url.pathExtension.lowercased()
        var atomStyle: Settings.AtomStyle
        
        if fileExtension == "pdb" {
            atomStyle = userSettings.atomStylePDB
        }
        else if fileExtension == "cif" {
            atomStyle = userSettings.atomStyleCIF
        }
        else if fileExtension == "sdf" {
            atomStyle = userSettings.atomStyleSDF
        }
        else {
            atomStyle = userSettings.atomStylePDB // use PDB style as default
        }
        
        let html = prepare3DmolHTML(htmlPath: htmlPath!, pdbPath: url.path, dataFormat: fileExtension, atomStyle: atomStyle, rotationSpeed: userSettings.rotationSpeed, bgColor: userSettings.bgColor)
        
        let baseUrl = URL(fileURLWithPath: htmlPath!)
        self.webView?.loadHTMLString(html, baseURL: baseUrl)
        
        handler(nil)
    }
    
}
