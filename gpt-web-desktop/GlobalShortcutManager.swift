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
        case "enable":
            if customized == true {
                shortcutAction(type: "custom")
            } else {
                shortcutAction(type: "default")
            }
        case "disable":
            setCustomShortcut(with: [], key: .g)
        default:
            shortcutString = "Command + Shift + Option + G"
            setCustomShortcut(with: [.command, .shift, .option], key: .g)
        }
    }

    func setCustomShortcut(with modifiers: NSEvent.ModifierFlags, key: Key) {
        globalHotKey = HotKey(keyCombo: KeyCombo(key: key, modifiers: modifiers))
    }

    private func hotKeyFired() {
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
}
