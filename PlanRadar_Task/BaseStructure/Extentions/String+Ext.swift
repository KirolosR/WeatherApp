//
//  String+Ext.swift
//  PlanRadar_Task
//
//  Created by Kirolos Ramses on 22/10/2025.
//

import SwiftUI

public extension String {
    
    var toInt: Int {
        return Int(self) ?? 0
    }
    
    var localizedStringKey: LocalizedStringKey {
        .init(self)
    }
    
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    var toURL: URL? {
        return URL(string: self)
    }
    
    static var na: String {
        "N/A"
    }
    
    func replaceEmpty() -> String {
        if self.isEmpty {
            return "N/A"
        }
        
        return self
    }
    
    func removingSuffix(_ suffix: String) -> String {
        if self.hasSuffix(suffix) {
            return String(self.dropLast(suffix.count))
        } else {
            return self
        }
    }
    
    mutating func removeSuffix(_ suffix: String) {
        if self.hasSuffix(suffix) {
            self.removeLast(suffix.count)
        }
    }
    
    func ensureHTTPS() -> String {
        if self.lowercased().hasPrefix("https://") {
            return self
        } else if self.lowercased().hasPrefix("http://") {
            return "https://" + self.dropFirst(7) // Remove "http://" and add "https://"
        } else {
            return "https://" + self
        }
    }
    
    /// Replaces all occurrences of strings from a specified array with a given replacement.
    /// - Parameters:
    ///   - targets: The array of target strings to be replaced.
    ///   - replacement: The replacement string.
    /// - Returns: A new string with all occurrences of the target strings replaced.
    func replacingOccurrences(of targets: [String], with replacement: String) -> String {
        var modifiedString = self
        for target in targets {
            modifiedString = modifiedString.replacingOccurrences(of: target, with: replacement)
        }
        return modifiedString
    }
    
    
    func isVersion(lessThan otherVersion: String) -> Bool {
        let currentComponents = self.components(separatedBy: ".")
        let otherComponents = otherVersion.components(separatedBy: ".")
        
        let maxLength = max(currentComponents.count, otherComponents.count)
        
        for i in 0..<maxLength {
            let currentComponent = i < currentComponents.count ? Int(currentComponents[i]) ?? 0 : 0
            let otherComponent = i < otherComponents.count ? Int(otherComponents[i]) ?? 0 : 0
            
            if currentComponent < otherComponent {
                return true // Current version is less than the other version
            } else if currentComponent > otherComponent {
                return false // Current version is greater than the other version
            }
        }
        
        return false // Versions are equal
    }
}
