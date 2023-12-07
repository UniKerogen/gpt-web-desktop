//
//  HelpViewController.swift
//  gpt-web-desktop
//
//  Created by Kuang Jiang on 12/4/23.
//

import Cocoa
import Down

class HelpViewController: NSViewController {
    
    var helpWindowController: NSWindowController?
    
    @IBOutlet weak var tipTabView: NSTabView!
    
    @IBOutlet weak var basicTextView: NSScrollView!
    
    @IBOutlet weak var chattingTab: NSScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Additional setup code if needed
        
        // Paragraph Style
        // Create a paragraph style with line spacing
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.2

        // Create attributes with the paragraph style
        let body: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: 14),
            .paragraphStyle: paragraphStyle
        ]
        let title: [NSAttributedString.Key: Any] = [
            .font: NSFont.boldSystemFont(ofSize: 18),
            .paragraphStyle: paragraphStyle
        ]
        let label1: [NSAttributedString.Key: Any] = [
            .font: NSFont.boldSystemFont(ofSize: 16),
            .paragraphStyle: paragraphStyle
        ]
        let goodExample: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: 12),
            .paragraphStyle: paragraphStyle,
            .underlineStyle: NSUnderlineStyle.single.rawValue,  // Underline
            .obliqueness: 0.2  // Italic
        ]
        let badExample: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: 14),
            .paragraphStyle: paragraphStyle,
            .obliqueness: 0.2  // Italic
        ]
        let exampleBody: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: 14),
            .paragraphStyle: paragraphStyle
        ]
        
        
        // MARK: Basic Tab
        setupTextViewFromFile(fileName: "basicTab", ofType: "rtf", scrollView: basicTextView)
        //setupMarkdownViewFromFile(fileName: "basicTab", scrollView: basicTextView)
        
        // MARK: Chatting Tab
        let chattingString = NSMutableAttributedString()
        chattingString.append(NSAttributedString(string: "Back-Step Prompting",
                                                 attributes: title))
        chattingString.append(NSAttributedString(string: "\nThis is regular text with a different font.\n",
                                                 attributes: body))
        chattingString.append(NSAttributedString(string: "1. Initial Guidance\n",
                                                 attributes: label1))
        chattingString.append(NSAttributedString(string: "    Start with clear and specific instructions for the model's response\n",
                                                 attributes: body))
        displayText(textString: chattingString, scrollView: chattingTab)
        
    }
    
    func displayText(textString: NSMutableAttributedString, scrollView: NSScrollView) {
        let textView = NSTextView()
        textView.textStorage?.setAttributedString(textString)
        
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
    }
    
    func setupTextViewFromFile(fileName: String, ofType: String, scrollView: NSScrollView) {
        // Load the content from the specified RTF file and convert it to plain text
        if let path = Bundle.main.path(forResource: fileName, ofType: ofType) {
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
    
    func setupMarkdownViewFromFile(fileName: String, scrollView: NSScrollView) {
        // Load the content from the specified Markdown file
        if let markdownURL = Bundle.main.url(forResource: fileName, withExtension: "md"),
           let markdownString = try? String(contentsOf: markdownURL) {

            // Convert Markdown text to an attributed string
            let down = Down(markdownString: markdownString)
            let attributedString = try? down.toAttributedString()

            // Create a text view and set its attributed string
            let textView = NSTextView()
            textView.textStorage?.setAttributedString(attributedString ?? NSAttributedString())

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
        }
    }
}
