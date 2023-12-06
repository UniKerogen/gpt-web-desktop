//
//  HelpViewController.swift
//  gpt-web-desktop
//
//  Created by Kuang Jiang on 12/4/23.
//

import Cocoa

class HelpViewController: NSViewController {
    
    var helpWindowController: NSWindowController?
    
    @IBOutlet weak var tipTabView: NSTabView!
    
    @IBOutlet weak var basicTextView: NSScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Additional setup code if needed
        // MARK: Basic Tab
        setupTextViewFromFile(fileName: "basicTab", scrollView: basicTextView)
    }
    
    func setupTextViewFromFile(fileName: String, scrollView: NSScrollView) {
        // Load the content from the specified RTF file and convert it to plain text
        if let path = Bundle.main.path(forResource: fileName, ofType: "rtf") {
            do {
                let attributedString = try NSAttributedString(url: URL(fileURLWithPath: path), options: [:], documentAttributes: nil)
                
                // Create a text view and set its attributed string
                let textView = NSTextView()
                textView.textStorage?.setAttributedString(attributedString)
                
                // Disable text input
                textView.isEditable = false
                
                // Enable auto-wrapping
                textView.textContainer?.widthTracksTextView = true
                textView.textContainer?.heightTracksTextView = true
                
                // Set up the scroll view with the text view as the document view
                scrollView.documentView = textView
                
                // Appearance Adjustment
                textView.appearance = tipTabView.effectiveAppearance
                textView.backgroundColor = NSColor.clear
                
                // Fine-tune appearance for dark mode
                if NSApp.effectiveAppearance.name == .darkAqua {
                    textView.textColor = NSColor.white
                }
                
            } catch {
                print("Error loading RTF file: \(error)")
            }
        }
    }
}
