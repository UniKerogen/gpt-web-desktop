//
//  GlobalShortcutManager.swift
//  gpt-web-desktop
//
//  Created by Kuang Jiang on 12/14/23.
//

import Cocoa
import HotKey

class GlobalShortcutManager {
    static let shared = GlobalShortcutManager()

    var hotKey: HotKey?
    var shortcutModifiers: NSEvent.ModifierFlags = []
    var shortcutKey: Key = .a
    var shortcutString: String = "Not Set"
    
    private init() {
        setupGlobalShortcut()
    }

    private func setupGlobalShortcut() {
        hotKey = HotKey(key: shortcutKey, modifiers: shortcutModifiers)
        hotKey?.keyDownHandler = {
            // Handle the global shortcut activation
            self.handleGlobalShortcut()
        }
    }

    func setCustomShortcut(with modifiers: NSEvent.ModifierFlags, key: Key) {
        shortcutModifiers = modifiers
        shortcutKey = key
        
        hotKey = HotKey(key: shortcutKey, modifiers: shortcutModifiers)
        hotKey?.keyDownHandler = {
            // Handle the custom shortcut activation
            self.handleGlobalShortcut()
        }

        updateShortcutString()
    }

    private func updateShortcutString() {
        // Update the string representation of the shortcut
        let modifiersString = modifierFlagsToString(modifierFlags: shortcutModifiers)
        let keyString = "\(shortcutKey)"
        shortcutString = modifiersString.isEmpty ? "Not Set" : "\(modifiersString) + \(keyString)"
    }

    private func handleGlobalShortcut() {
        // Handle actions when the global shortcut is triggered
        // Call the showPreferencesWindow method in PreferencesViewController
        NotificationCenter.default.post(name: .showPreferencesWindow, object: nil)
    }
    
    private func modifierFlagsToString(modifierFlags: NSEvent.ModifierFlags) -> String {
        var modifiers: [String] = []
        
        if modifierFlags.contains(.command) {
            modifiers.append("⌘")
        }
        if modifierFlags.contains(.shift) {
            modifiers.append("⇧")
        }
        if modifierFlags.contains(.control) {
            modifiers.append("⌃")
        }
        if modifierFlags.contains(.option) {
            modifiers.append("⌥")
        }
        
        return modifiers.joined(separator: " ")
    }
}
