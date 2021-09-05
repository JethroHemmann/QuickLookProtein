//
//  QuickLookProteinApp.swift
//  QuickLookProtein
//
//  Created by Jethro Hemmann on 15.08.21.
//

import SwiftUI

@main
struct QuickLookProteinApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(width: 1000, height: 500)
                .onAppear {
                    NSWindow.allowsAutomaticWindowTabbing = false
                }
        }
        .commands {
            CommandGroup(replacing: .newItem, addition: {}) // remove File -> New Window from menu
        }
    }
}
