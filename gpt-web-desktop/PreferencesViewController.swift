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
var wyyx = ChatBot(name:"文言一心", data:"https://yiyan.baidu.com")
var google = ChatBot(name:"Google", data:"https://www.google.com")

var targetWebsite: String?

class PreferencesViewController: NSViewController {

    @IBOutlet weak var websiteComboBox: NSComboBox!
    
    var preferencesWindowController: NSWindowController?

    // Add website options
    let websiteOptions = ["ChatGPT", "文言一心", "Google"]

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

    @IBAction func savePreferences(_ sender: Any) {
        // Convert Name to URL
        let targetURL: String?
        switch websiteComboBox.stringValue{
        case chatGPT.name:
            targetURL = chatGPT.data
        case wyyx.name:
            targetURL = wyyx.data
        case google.name:
            targetURL = google.data
        default:
            targetURL = chatGPT.data
        }
        
        // Save the selected website to UserDefaults
        UserDefaults.standard.set(targetURL, forKey: "SelectedWebsite")
        
        // Update the selected website in the existing window controller
        targetWebsite = targetURL
    }
    
    @IBAction func showPreferencesWindow(_ sender: Any) {
        if preferencesWindowController == nil {
            let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
            preferencesWindowController = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("PreferencesWindowController")) as? NSWindowController
        }

        preferencesWindowController?.showWindow(sender)
    }
}

