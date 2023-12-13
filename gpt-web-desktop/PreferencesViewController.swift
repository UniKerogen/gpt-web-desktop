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
// var google = ChatBot(name:"Google", data:"https://bard.google.com")
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
}

