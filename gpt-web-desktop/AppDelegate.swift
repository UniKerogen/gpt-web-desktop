//
//  AppDelegate.swift
//  gpt-web-desktop
//
//  Created by Kuang Jiang on 11/30/23.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    var myWindow: NSWindow!
    var preferencesViewController: PreferencesViewController!


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Add any additional setup code here.
        showMainWindow()
        
        // Create the preferences view controller
        preferencesViewController = PreferencesViewController()

        // Create a Preferences menu item
        let preferencesMenuItem = NSMenuItem(title: "Preferences", action: #selector(showPreferencesPanel(_:)), keyEquivalent: ",")
        preferencesMenuItem.target = self

        // Find the app name menu item
        if let appMenuItem = getAppNameMenuItem() {
            // Create a submenu for Preferences under the app name
            let preferencesMenu = NSMenu(title: "Preferences")
            
            // Add items to the submenu in the desired order
            preferencesMenu.addItem(withTitle: "About", action: #selector(about(_:)), keyEquivalent: "")
            preferencesMenu.addItem(NSMenuItem.separator())
            preferencesMenu.addItem(withTitle: "Preferences", action: #selector(showPreferencesPanel(_:)), keyEquivalent: ",")
            preferencesMenu.addItem(NSMenuItem.separator())
            preferencesMenu.addItem(withTitle: "Hide", action: #selector(NSApplication.hide(_:)), keyEquivalent: "h")
            preferencesMenu.addItem(withTitle: "Hide Others", action: #selector(NSApplication.hideOtherApplications(_:)), keyEquivalent: "h")
            preferencesMenu.addItem(withTitle: "Show All", action: #selector(NSApplication.unhideAllApplications(_:)), keyEquivalent: "")
            preferencesMenu.addItem(NSMenuItem.separator())
            preferencesMenu.addItem(withTitle: "Quit", action: #selector(quit(_:)), keyEquivalent: "q")

            appMenuItem.submenu = preferencesMenu
        }
    }

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

    private func showMainWindow() {
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        if let viewController = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("MainViewController")) as? NSViewController {
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
    
    // Function to handle right-click menu item action
    @objc func openNewWindow(_ sender: Any?) {
        showMainWindow()
    }
    
    func applicationDockMenu(_ sender: NSApplication) -> NSMenu? {
        // Create a custom right-click menu
        let menu = NSMenu()

        // Add menu item to open a new window
        let openNewWindowItem = NSMenuItem(title: "Open New Window", action: #selector(openNewWindow(_:)), keyEquivalent: "")
        menu.addItem(openNewWindowItem)

        return menu
    }
    
    @IBAction func quit(_ sender: Any) {
        NSApp.terminate(sender)
    }
    
    @objc func about(_ sender: Any) {
        let appInfo: [String: Any] = [
            "ApplicationName": "ChatGPT Web Viewer",
            "ApplicationVersion": "1.0",
            "ApplicationCopyright": "© 2023 Kuang Jiang",
            "ApplicationDescription": "A Simple Web Viewer for web-based interaction with ChatGPT."
        ]

        NSApp.orderFrontStandardAboutPanel(appInfo)
    }
    
    // Preference Menu
    private func getAppNameMenuItem() -> NSMenuItem? {
        if let mainMenu = NSApp.mainMenu {
            for menuItem in mainMenu.items {
                if menuItem.title == "ChatGPT" {
                    return menuItem
                }
            }
        }
        return nil
    }
    
    @objc func showPreferencesPanel(_ sender: Any) {
        guard preferencesViewController != nil else {
            return
        }

        let preferencesPanel = NSPanel(contentViewController: preferencesViewController)
        preferencesPanel.title = "Preferences"
        preferencesPanel.makeKeyAndOrderFront(nil)
    }
}

