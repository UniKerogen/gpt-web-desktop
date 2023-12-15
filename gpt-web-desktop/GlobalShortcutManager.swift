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
    
    var shortcutString: String?
    var enabled: Bool?
    var customized: Bool? = false
    
    private var globalHotKey: HotKey? {
        didSet {
            guard let hotKey = globalHotKey else { return }
            hotKey.keyDownHandler = { [weak self] in
                self?.hotKeyFired()
            }
        }
    }

    private init() {}
    
    func shortcutAction(type: String){
        switch type{
        case "custom":
            // do something
            print("Try to set custom shortcut")
            customized = true
            enabled = true
            if let (modifier, key) = self.parseShortcut(shortcutString ?? "⌘ ⇧ ⌥ G"){
                setCustomShortcut(with: modifier, key: key)
            } else {
                print("Invalid Input")
            }
        case "enable":
            if customized == true {
                shortcutAction(type: "custom")
            } else {
                shortcutAction(type: "default")
            }
        case "disable":
            setCustomShortcut(with: [], key: .g)
            enabled = false
        default:
            shortcutString = "⌘ ⇧ ⌥ G"
            setCustomShortcut(with: [.command, .shift, .option], key: .g)
            enabled = true
        }
    }

    func setCustomShortcut(with modifiers: NSEvent.ModifierFlags, key: Key) {
        globalHotKey = HotKey(keyCombo: KeyCombo(key: key, modifiers: modifiers))
    }

    private func hotKeyFired() {
        // Active App
        NSApp.activate(ignoringOtherApps: true)
        // Access the AppDelegate
        guard let appDelegate = NSApp.delegate as? AppDelegate else {
            return
        }

        // Check if the activeWindow exists
        if let activeWindow = appDelegate.activeWindow {
            // Activate the existing window
            activeWindow.makeKeyAndOrderFront(nil)
        } else {
            // Open a new window using the showMainWindow function in AppDelegate
            appDelegate.showMainWindow(windowLevel: false)
        }
    }
    
    func parseShortcut(_ shortcut: String) -> (modifierFlags: NSEvent.ModifierFlags, key: Key)? {
        var modifierFlags: NSEvent.ModifierFlags = []
        var key: Key?

        // Sample Input: "⌘ ⇧ ⌥ G"
        for char in shortcut.trimmingCharacters(in: .whitespaces) {
            switch char {
            case "⌘":
                modifierFlags.insert(.command)
            case "⇧":
                modifierFlags.insert(.shift)
            case "⌥":
                modifierFlags.insert(.option)
            case "⌃":
                modifierFlags.insert(.control)
            default:
                if let specialKey = Key(string: char.uppercased()) {
                    key = specialKey
                }
            }
        }

        // Ensure both modifierFlags and key are set before returning
        guard let validKey = key else { return nil }

        return (modifierFlags, validKey)
    }
}
