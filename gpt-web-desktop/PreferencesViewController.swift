//
//  PreferencesViewController.swift
//  gpt-web-desktop
//
//  Created by Kuang Jiang on 12/2/23.
//

import Cocoa

// MARK: ChatBot Setup

struct ChatBot{
    var name: String
    var data: String
}

var chatGPT = ChatBot(name:"ChatGPT", data:"https://www.chatgpt.com/")
var claude = ChatBot(name:"Claude", data:"https://claude.ai/login?returnTo=%2F")
// var google = ChatBot(name:"Google", data:"https://bard.google.com")  // Not Tested
var bing = ChatBot(name:"Bing", data:"https://www.bing.com/search?form=MY0291&OCID=MY0291&q=Bing+AI&showconv=1")
var phind = ChatBot(name:"Phind", data:"https://www.phind.com/agent?home=true")
var playground = ChatBot(name:"Playground", data:"https://playgroundai.com")  // Picture
// var canva = ChatBot(name:"Canva", data:"https://www.canva.com/")  // Image
var wyyx = ChatBot(name:"文心一言", data:"https://yiyan.baidu.com")
var tyqw = ChatBot(name:"通义千问", data:"https://qianwen.aliyun.com")
var poe = ChatBot(name:"POE", data:"https://poe.com")  // A combination of chatbots
// var notion = ChatBot(name:"Notion", data:"www.notion.so")  // Note

var targetWebsite: String?

// MARK: Preference View Controller

class PreferencesViewController: NSViewController {
    
    @IBOutlet weak var preferenceTabs: NSTabView!
    
    @IBOutlet weak var websiteComboBox: NSComboBox!
    
    @IBOutlet weak var helpButton: NSButton!
    
    @IBOutlet weak var setUnsetFloatingButton: NSButtonCell!
    
    @IBOutlet weak var enableShortcutCheckbox: NSButton!
    @IBOutlet weak var customShortcutField: NSTextField!
    @IBOutlet weak var customizeShortcutButton: NSButton!
    
    @IBOutlet weak var saveButton: NSButton!
    @IBOutlet weak var saveAndOpenButton: NSButton!
    
    var preferencesWindowController: NSWindowController?
    
    // Add website options
    let websiteOptions = ["ChatGPT", "Claude", "Bing", "文心一言", "通义千问",
                          "Playground", "POE"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        websiteComboBox.addItems(withObjectValues: websiteOptions)
        
        // Load saved preference or set a default value
        if let selectedWebsite = UserDefaults.standard.string(forKey: "SelectedWebsite") {
            websiteComboBox.stringValue = selectedWebsite
        } else {
            // Set a default website
            websiteComboBox.stringValue = websiteOptions.first ?? ""
        }
        
        // Update Global Shortcut UI based on whether the shortcut is enabled
        if GlobalShortcutManager.shared.enabled == true {
            enableShortcutCheckbox.state = .on
        } else {
            enableShortcutCheckbox.state = .off
        }
        updateShortcutUI()
    }
    
    //MARK: Chat Bot Preference
    
    func convertWebsiteNameToURL(_ websiteName: String) -> String {
        switch websiteName {
        case chatGPT.name:
            return chatGPT.data
        case claude.name:
            return claude.data
            //        case google.name:
            //            return google.data
        case bing.name:
            return bing.data
        case phind.name:
            return phind.data
        case playground.name:
            return playground.data
        case wyyx.name:
            return wyyx.data
        case tyqw.name:
            return tyqw.data
        case poe.name:
            return poe.data
        default:
            return chatGPT.data
        }
    }
    
    // MARK: Save Preference Button
    @IBAction func websiteComboBoxDidChange(_ sender: Any) {
        saveButton.isEnabled = !websiteComboBox.stringValue.isEmpty
        saveAndOpenButton.isEnabled = !websiteComboBox.stringValue.isEmpty
    }
    
    @IBAction func savePreferences(_ sender: Any) {
        // Convert Name to URL
        targetWebsite = convertWebsiteNameToURL(websiteComboBox.stringValue)
        
        // Save the selected website to UserDefaults
        UserDefaults.standard.set(websiteComboBox.stringValue, forKey: "SelectedWebsite")
    }
    
    // MARK: Save And Open New Window Button
    
    @IBAction func saveAndOpenNewWindow(_ sender: Any) {
        // Convert Name to URL
        targetWebsite = convertWebsiteNameToURL(websiteComboBox.stringValue)
        
        // Save the selected website to UserDefaults
        UserDefaults.standard.set(websiteComboBox.stringValue, forKey: "SelectedWebsite")
        
        // Show New Window
        if let appDelegate = NSApplication.shared.delegate as? AppDelegate {
            appDelegate.showMainWindow(windowLevel: false)
        }
    }
    
    // MARK: Show Preferences Window
    
    @IBAction func showPreferencesWindow(_ sender: Any) {
        if preferencesWindowController == nil {
            let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
            preferencesWindowController = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("PreferencesWindowController")) as? NSWindowController
        }
        preferencesWindowController?.showWindow(sender)
    }
    
    //MARK: Help Button

    @IBAction func showTooltip(_ sender: Any) {
        let alert = NSAlert()
        
        let messageText = "Help of Settings..."
        
        alert.messageText = messageText
        alert.informativeText = "\n\n\n\n\n\n\n\n"
        alert.alertStyle = .informational
        
        // Create an NSTextView for customizing the text alignment
        let textView = NSTextView(frame: NSRect(x: 0, y: 0, width: 300, height: 100))
        textView.isEditable = false
        // Set the background color to match the alert's background color
        textView.backgroundColor = NSColor.clear
        
        // Set text color for both light and dark mode
        textView.textColor = NSColor.textColor
        
        // Set the appearance to match the alert's appearance
        textView.appearance = alert.window.appearance
        
        // Set left alignment for the text view
        textView.alignment = .left
        
        // Paragraph Style
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.2
        let boldbody: [NSAttributedString.Key: Any] = [
            .font: NSFont.boldSystemFont(ofSize: 12),
            .paragraphStyle: paragraphStyle,
            .foregroundColor: NSColor.textColor
        ]
        let body: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: 12),
            .paragraphStyle: paragraphStyle,
            .foregroundColor: NSColor.textColor
        ]
        let italicbody: [NSAttributedString.Key: Any] = [
            .font: NSFontManager.shared.convert(NSFont.systemFont(ofSize: 12), toHaveTrait: .italicFontMask),
            .paragraphStyle: paragraphStyle,
            .foregroundColor: NSColor.textColor
        ]
        
        let informativeText = NSMutableAttributedString()
        informativeText.append(NSAttributedString(string:"ChatBot Settings:\n", attributes: boldbody))
        informativeText.append(NSAttributedString(string:"All changed settings will be applied in the new window.\n", attributes: body))
        informativeText.append(NSAttributedString(string:"\n", attributes: body))
        informativeText.append(NSAttributedString(string:"Floating Window Settings:\n", attributes: boldbody))
        informativeText.append(NSAttributedString(string:"Newest Window: ", attributes: italicbody))
        informativeText.append(NSAttributedString(string:"The most currently opened window, if it is closed then it is unsetable.\n", attributes: body))
        informativeText.append(NSAttributedString(string:"Always-Floating Window: ", attributes: italicbody))
        informativeText.append(NSAttributedString(string:"This window will always be floating and excluded from the most current window.\n", attributes: body))
        informativeText.append(NSAttributedString(string:"\n", attributes: body))
        informativeText.append(NSAttributedString(string:"Key Binding Settings:\n", attributes: boldbody))
        informativeText.append(NSAttributedString(string:"--- Please Wait to be Implemented ---\n", attributes: body))
        
        // Apply the attributed text to the text view
        textView.textStorage?.setAttributedString(informativeText)
        
        // Add the text view as an accessory view to the alert
        alert.accessoryView = textView
        
        // Adjust the positioning of the text view within the alert
        textView.frame.origin.y = -50
        
        alert.beginSheetModal(for: view.window!) { _ in
            // Code to execute after the alert is dismissed
        }
    }


    // MARK: Floating Newest Window

    @IBAction func toggleAlwaysOnTop(_ sender: Any) {
        if let appDelegate = NSApp.delegate as? AppDelegate {
            if let activeWindow = appDelegate.activeWindow {
                if activeWindow.level == .normal {
                    activeWindow.level = .floating
                } else {
                    activeWindow.level = .normal
                }
            }
        }
        // Gray Out if No Newest Window
        setUnsetFloatingButton.isEnabled = (NSApp.delegate as? AppDelegate)?.activeWindow != nil
    }
    
    // MARK: New Always Floating Window
    @IBAction func openNewFloatingWindow(_ sender: Any) {
        // Show New Window
        if let appDelegate = NSApplication.shared.delegate as? AppDelegate {
            appDelegate.showMainWindow(windowLevel: true)
        }
    }

    // MARK: Global Short Cut
    
    func updateShortcutUI() {
        if enableShortcutCheckbox.state == .on {
            customShortcutField.isEnabled = true
            customizeShortcutButton.isEnabled = true
        } else {
            customShortcutField.isEnabled = false
            customizeShortcutButton.isEnabled = false
        }
        
        // Use the stored string representation of the shortcut
        customShortcutField.stringValue = GlobalShortcutManager.shared.shortcutString ?? "⌘ ⇧ ⌥ G"
        customShortcutField.isEditable = false
        customShortcutField.backgroundColor = NSColor.clear
    }
    
    @IBAction func customizeShortcut(_ sender: Any) {
        // Record a combination of key press and set it to the new shortcut
        print("Trying to set custom shortcut")
        
        // Make the view the first responder to capture key events
        view.window?.makeFirstResponder(self)
        
        // Create a new window or alert to instruct the user to press a key combination
        let alert = NSAlert()
        alert.messageText = "Press the desired key combination"
        alert.addButton(withTitle: "OK")
        // Display the alert as a sheet
        alert.beginSheetModal(for: view.window!) { response in
            if response == NSApplication.ModalResponse.OK {
                GlobalShortcutManager.shared.shortcutAction(type: "custom")
            }
        }
    }
    
    override var acceptsFirstResponder: Bool {
        return true
    }
    
    // Override keyDown to capture key events
    override func keyDown(with event: NSEvent) {
        // Check if the event contains a valid key code
        print("Key Down Detected")
        if let characters = event.charactersIgnoringModifiers, !characters.isEmpty {
            // Build the shortcut string based on the pressed keys
            let modifierFlags = event.modifierFlags
            var shortcut = ""

            if modifierFlags.contains(.command) {
                shortcut += "⌘ "
            }
            if modifierFlags.contains(.shift) {
                shortcut += "⇧ "
            }
            if modifierFlags.contains(.option) {
                shortcut += "⌥ "
            }
            if modifierFlags.contains(.control) {
                shortcut += "⌃ "
            }

            shortcut += characters.uppercased()

            // Store the custom shortcut
            GlobalShortcutManager.shared.shortcutString = shortcut

            // Dismiss the alert if it's currently presented
            NSApp.stopModal(withCode: NSApplication.ModalResponse.OK)
        }
    }
    
    @IBAction func enableShortcutCheckboxClicked(_ sender: NSButton) {
        if sender.state == .on {
            // Enable the global shortcut
            GlobalShortcutManager.shared.shortcutAction(type: "enable")
        } else {
            // Disable the global shortcut
            GlobalShortcutManager.shared.shortcutAction(type: "disable")
        }
    }
}
