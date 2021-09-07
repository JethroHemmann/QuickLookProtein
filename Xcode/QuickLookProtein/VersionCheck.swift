//
//  VersionCheck.swift
//  QuickLookProtein
//
//  Created by Jethro Hemmann on 05.09.21.
//

import Foundation

func getNewestVersion() -> (major: Int, minor: Int)? {
    let url = URL(string: "https://github.com/JethroHemmann/QuickLookProtein/blob/main/VERSION?raw=true")!
    
    do {
        var data = try String(contentsOf: url)
        if data.contains("MOST_RECENT_VERSION") {
            data = data.replacingOccurrences(of: "MOST_RECENT_VERSION ", with: "")
            let versionArr = data.split(separator: ".")
            if versionArr.count < 2 {
                return nil
            }
            let major = Int(versionArr[0])
            let minor = Int(versionArr[1])
            if (major == nil) || (minor == nil) {
                return nil
            }
            else {
                return (major: major!, minor: minor!)
            }
        }
        else {
            return nil
        }
        
    } catch {
        return nil
    }
}

func newerVersion(installedVersion: (major: Int, minor: Int), mostRecentVersion: (major: Int, minor: Int)) -> Bool {
    if installedVersion.major < mostRecentVersion.major {
        return true
    }
    else if installedVersion.major == mostRecentVersion.major {
        if installedVersion.minor < mostRecentVersion.minor {
            return true
        }
        else {
            return false
        }
    }
    else {
        return false
    }
}
