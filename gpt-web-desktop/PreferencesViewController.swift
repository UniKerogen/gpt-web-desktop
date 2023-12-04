//
//  PreferencesViewController.swift
//  gpt-web-desktop
//
//  Created by Kuang Jiang on 12/2/23.
//

import Cocoa

struct ChatBot{
    var name: String
    var data: String
}

var chatGPT = ChatBot(name:"ChatGPT", data:"https://www.chatgpt.com/")
var claude = ChatBot(name:"Claude", data:"https://claude.ai/login?returnTo=%2F")
var google = ChatBot(name:"Google", data:"https://bard.google.com")
var bing = ChatBot(name:"Bing", data:"https://www.bing.com/search?form=MY0291&OCID=MY0291&q=Bing+AI&showconv=1")
var playground = ChatBot(name:"Playground", data:"https://playgroundai.com")  // Picture
var canva = ChatBot(name:"Canva", data:"https://www.canva.com/")  // Image
var wyyx = ChatBot(name:"问言一心", data:"https://yiyan.baidu.com")
var tyqw = ChatBot(name:"通义千问", data:"https://qianwen.aliyun.com")
var poe = ChatBot(name:"POE", data:"https://poe.com")  // A combination of chatbots
var notion = ChatBot(name:"Notion", data:"www.notion.so")  // Note

var targetWebsite: String?

class PreferencesViewController: NSViewController {

    @IBOutlet weak var websiteComboBox: NSComboBox!
    
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
    
    func convertWebsiteNameToURL(_ websiteName: String) -> String {
        switch websiteName {
        case chatGPT.name:
            return chatGPT.data
        case wyyx.name:
            return wyyx.data
        case google.name:
            return google.data
        case bing.name:
            return bing.data
        default:
            return chatGPT.data
        }
    }

    @IBAction func savePreferences(_ sender: Any) {
        // Convert Name to URL
        targetWebsite = convertWebsiteNameToURL(websiteComboBox.stringValue)
        
        // Save the selected website to UserDefaults
        UserDefaults.standard.set(websiteComboBox.stringValue, forKey: "SelectedWebsite")
    }
    
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
    
    @IBAction func showPreferencesWindow(_ sender: Any) {
        if preferencesWindowController == nil {
            let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
            preferencesWindowController = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("PreferencesWindowController")) as? NSWindowController
        }

        preferencesWindowController?.showWindow(sender)
    }
}

