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
var google = ChatBot(name:"Google", data:"https://bard.google.com")
var bing = ChatBot(name:"Bing", data:"https://www.bing.com/search?form=MY0291&OCID=MY0291&q=Bing+AI&showconv=1")
var phind = ChatBot(name:"Phind", data:"https://www.phind.com/agent?home=true")
var playground = ChatBot(name:"Playground", data:"https://playgroundai.com")  // Picture
var canva = ChatBot(name:"Canva", data:"https://www.canva.com/")  // Image
var wyyx = ChatBot(name:"问言一心", data:"https://yiyan.baidu.com")
var tyqw = ChatBot(name:"通义千问", data:"https://qianwen.aliyun.com")
var poe = ChatBot(name:"POE", data:"https://poe.com")  // A combination of chatbots
var notion = ChatBot(name:"Notion", data:"www.notion.so")  // Note

var targetWebsite: String?

// MARK: Preference View Controller

class PreferencesViewController: NSViewController {

    @IBOutlet weak var preferenceTabs: NSTabView!
    
    @IBOutlet weak var websiteComboBox: NSComboBox!
    
    @IBOutlet weak var helpButton: NSButton!
    
    var preferencesWindowController: NSWindowController?

    // Add website options
    let websiteOptions = ["ChatGPT", "Claude", "Google", "Bing", "文言一心", "通义千问",
    "Playground", "Canva", "POE", "Notion"]

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
        case google.name:
            return google.data
        case bing.name:
            return bing.data
        case phind.name:
            return phind.data
        case playground.name:
            return playground.data
        case canva.name:
            return canva.data
        case wyyx.name:
            return wyyx.data
        case tyqw.name:
            return tyqw.data
        case poe.name:
            return poe.data
        case notion.name:
            return notion.data
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
            appDelegate.showMainWindow()
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
        alert.messageText = "Help Information"
        alert.informativeText = """
        All changed settings will be applied in new window.
        """
        alert.alertStyle = .informational
        
        alert.beginSheetModal(for: view.window!) { _ in
            // Code to execute after the alert is dismissed
        }
    }
    
    // MARK: Window Behavior
    @IBAction func toggleAlwaysOnTop(_ sender: NSButton) {
        if let appDelegate = NSApplication.shared.delegate as? AppDelegate,
           let myWindow = appDelegate.myWindow {
            
            // Check if the button is checked
            if sender.state == .on {
                // Set the window level to be always on top
                myWindow.level = .floating
            } else {
                // Set the window level back to normal
                myWindow.level = .normal
            }
        }
    }
}

