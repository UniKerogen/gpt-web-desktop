//
//  AppDelegate.swift
//  gpt-web-desktop
//
//  Created by Kuang Jiang on 11/30/23.
//

import Cocoa

var tempTargetWebsite: String?

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var myWindow: NSWindow!
    
    var preferencesWindowController: NSWindowController?
    var preferenceWindow: NSWindow!
    
    var helpWindowController: NSWindowController?
    var helpWindow: NSWindow?
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Add any additional setup code here.
        showMainWindow()
        registerShortcut()
    }
    
    // MARK: Window Behavior
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application.
    }
    
    func applicationDidBecomeActive(_ notification: Notification) {
        // Check if a window is already open
        if NSApp.windows.isEmpty {
            // If no window is open, create and show a new window
            showMainWindow()
        }
    }
    
    func showMainWindow() {
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        if let viewController = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("MainApp")) as? NSViewController {
            myWindow = NSWindow(contentViewController: viewController)
            
            // Set the default size of the window
            let defaultSize = NSSize(width: 400, height: 900)
            myWindow.setContentSize(defaultSize)
            
            // Position the window at the far right side and center on the horizontal axis
            if let mainScreen = NSScreen.main {
                let screenFrame = mainScreen.visibleFrame
                let windowRect = NSRect(x: screenFrame.maxX - defaultSize.width, y: screenFrame.midY - defaultSize.height / 2, width: defaultSize.width, height: defaultSize.height)
                myWindow.setFrame(windowRect, display: true)
            }
            
            myWindow.makeKeyAndOrderFront(nil)
        }
    }
    
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        // If no window is open, create a new window
        if !flag {
            showMainWindow()
        }
        return true
    }
    
    // MARK: Help Window
    
    @objc func openHelpView() {
        // Create helpWindowController only if it doesn't exist
        helpWindowController = helpWindowController ?? {
            let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)

            guard let helpViewController = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("HelpWindowController")) as? HelpViewController else {
                return nil
            }

            let controller = NSWindowController(window: nil)
            controller.contentViewController = helpViewController
            controller.window?.title = "Tips"

            // Disable resizing for helpWindow
            controller.window?.styleMask.remove(.resizable)

            return controller
        }()

        // Ensure helpWindowController is not nil
        guard let windowController = helpWindowController else {
            return
        }

        if windowController.window == nil {
            // If the window is nil, create a default one
            windowController.window = NSWindow(contentViewController: windowController.contentViewController!)
            windowController.window?.title = "Tips"

            // Disable resizing for helpWindow
            windowController.window?.styleMask.remove(.resizable)
        }

        windowController.showWindow(nil)
    }
    
    // MARK: Dock Menu
    
    // Function to handle right-click menu item action
    @objc func openNewWindow(_ sender: Any?) {
        showMainWindow()
    }
    
    func applicationDockMenu(_ sender: NSApplication) -> NSMenu? {
        // Create a custom right-click menu
        let menu = NSMenu()
        
        // Open New Window
        let openNewWindowItem = NSMenuItem(title: "Open New Window", action: #selector(openNewWindow(_:)), keyEquivalent: "")
        menu.addItem(openNewWindowItem)
        // Separator
        menu.addItem(NSMenuItem.separator())
        // Single Use Menu
        let openBot1Item = NSMenuItem(title: "Open ChatGPT...", action: #selector(openChatGPT), keyEquivalent: "")
        menu.addItem(openBot1Item)
        let openBot2Item = NSMenuItem(title: "Open Bing...", action: #selector(openBing), keyEquivalent: "")
        menu.addItem(openBot2Item)
        let openBot3Item = NSMenuItem(title: "Open 通义千问...", action: #selector(opentyqw), keyEquivalent: "")
        menu.addItem(openBot3Item)
        // Separator
        menu.addItem(NSMenuItem.separator())
        // Help
        let openHelpViewItem = NSMenuItem(title: "Tips...", action: #selector(openHelpView), keyEquivalent: "")
        menu.addItem(openHelpViewItem)
        
        return menu
    }
    
    // MARK: Single Use Window
    @objc func openChatGPT() {
        openTempWindow(target: chatGPT.data)
    }
    
    @objc func openClaude() {
        openTempWindow(target: claude.data)
    }
    
    @objc func openBard() {
        openTempWindow(target: google.data)
    }
    
    @objc func openBing() {
        openTempWindow(target: bing.data)
    }
    
    @objc func opentyqw() {
        openTempWindow(target: tyqw.data)
    }
    
    private func openTempWindow(target: String) {
        // Set temp value of website
        tempTargetWebsite = targetWebsite
        targetWebsite = target
        showMainWindow()
        
        // Reset temp value
        targetWebsite = tempTargetWebsite
        tempTargetWebsite = nil
    }
    
    // MARK: Application Exit
    
    @IBAction func quit(_ sender: Any) {
        NSApp.terminate(sender)
    }
    
    // MARK: About Panel
    
    @IBAction func aboutPanel(_ sender: Any) {
        let appInfo: [String: Any] = [
                    "ApplicationName": "ChatGPT Web Viewer",
                    "ApplicationVersion": "2.0",
                    "ApplicationCopyright": "© 2023 Kuang Jiang",
                    "ApplicationDescription": "Bring some GPT right to the desktop."
                ]
                
                NSApp.orderFrontStandardAboutPanel(appInfo)
    }
    
    // MARK: Preference Panel
    
    @IBAction func showPreferencesPanel(_ sender: Any) {
        if preferencesWindowController == nil {
            let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
            if let preferencesViewController = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("PreferencesWindowController")) as? NSViewController{
                preferenceWindow = NSWindow(contentViewController: preferencesViewController)
                
                preferenceWindow.title = "Settings"
                
                preferenceWindow.makeKeyAndOrderFront(nil)
            }
        }
        
        preferencesWindowController?.showWindow(sender)
    }
    
    // MARK: Clear History
    // Function to clear browsing history
    func clearWebViewHistory() {
        if let viewController = NSApp.mainWindow?.contentViewController as? MyViewController {
            viewController.clearWebViewHistory()
        }
    }
    
    @IBAction func clearHistoryClicked(_ sender: Any) {
        clearWebViewHistory()
        showMainWindow()
    }
    
    // MARK: Shortcut for Window within the App
    func registerShortcut() {
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { (event) -> NSEvent? in
            if event.modifierFlags.contains(.command) && event.characters?.lowercased() == "n" {
                self.showMainWindow()
                return nil
            }
            return event
        }
    }
}

