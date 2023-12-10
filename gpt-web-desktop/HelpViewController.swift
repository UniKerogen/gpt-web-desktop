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
    @IBOutlet weak var codingTab: NSScrollView!
    @IBOutlet weak var writingTab: NSScrollView!
    @IBOutlet weak var renderingTab: NSScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Additional setup code if needed
        
        // MARK: Paragraph Style
        // Create a paragraph style with line spacing
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.2
        
        // Italic Font Set
        let baseFont = NSFont.systemFont(ofSize: 12)
        let slantedFont = NSFontManager.shared.convert(baseFont, toHaveTrait: .italicFontMask)

        // Create attributes with the paragraph style
        let body: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: 14),
            .paragraphStyle: paragraphStyle
        ]
        let boldbody: [NSAttributedString.Key: Any] = [
            .font: NSFont.boldSystemFont(ofSize: 14),
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
            .font: slantedFont,
            .paragraphStyle: paragraphStyle,
            .underlineStyle: NSUnderlineStyle.single.rawValue,  // Underline
        ]
        let badExample: [NSAttributedString.Key: Any] = [
            .font: slantedFont,
            .paragraphStyle: paragraphStyle,  // Italic
        ]
        let exampleBody: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: 12),
            .paragraphStyle: paragraphStyle
        ]
        
        
        // MARK: Basic Tab
        setupTextViewFromFile(fileName: "basicTab", ofType: "rtf", scrollView: basicTextView)
        //setupMarkdownViewFromFile(fileName: "basicTab", scrollView: basicTextView)
        
        // MARK: Chatting Tab
        let chattingString = NSMutableAttributedString()
        chattingString.append(NSAttributedString(string: "Back-Step Prompting\n",
                                                 attributes: title))
        chattingString.append(NSAttributedString(string: "\n", attributes: body))
        chattingString.append(NSAttributedString(string: "    EXAMPLE TOPIC",
                                                 attributes: goodExample))
        chattingString.append(NSAttributedString(string: ": Describe a futuristic city.\n",
                                                attributes: exampleBody))
        chattingString.append(NSAttributedString(string: "\n", attributes: body))
        chattingString.append(NSAttributedString(string: "1. Initial Guidance\n",
                                                 attributes: label1))
        chattingString.append(NSAttributedString(string: "    Start with clear and specific instructions for the model's response\n",
                                                 attributes: body))
        chattingString.append(NSAttributedString(string: "\n", attributes: body))
        chattingString.append(NSAttributedString(string: "    User",
                                                 attributes: goodExample))
        chattingString.append(NSAttributedString(string: ": Describe a futuristic city with advanced technology and sustainable features.\n",
                                                attributes: exampleBody))
        chattingString.append(NSAttributedString(string: "\n", attributes: body))
        chattingString.append(NSAttributedString(string: "2. Significant Support\n",
                                                 attributes: label1))
        chattingString.append(NSAttributedString(string: "    Initially, provide more explicit guidance to shape the response\n",
                                                 attributes: body))
        chattingString.append(NSAttributedString(string: "\n", attributes: body))
        chattingString.append(NSAttributedString(string: "    Assistant",
                                                attributes: badExample))
        chattingString.append(NSAttributedString(string: ": In this futuristic city, envision towering skyscrapers equipped with smart\n",
                                                attributes: exampleBody))
        chattingString.append(NSAttributedString(string: "                     infrastructure, renewable energy sources, and advanced public transportation\n",
                                                attributes: exampleBody))
        chattingString.append(NSAttributedString(string: "                     systems that prioritize sustainability.\n",
                                                attributes: exampleBody))
        chattingString.append(NSAttributedString(string: "\n", attributes: body))
        chattingString.append(NSAttributedString(string: "3. Gradual Reduction\n",
                                                 attributes: label1))
        chattingString.append(NSAttributedString(string: "    Begin to reduce the level of guidance and let the model generate more\n    independently\n",
                                                 attributes: body))
        chattingString.append(NSAttributedString(string: "\n", attributes: body))
        chattingString.append(NSAttributedString(string: "    Assistant",
                                                attributes: badExample))
        chattingString.append(NSAttributedString(string: ": Picture a cityscape with towering skyscrapers seamlessly integrated with\n",
                                                attributes: exampleBody))
        chattingString.append(NSAttributedString(string: "                     smart infrastructure, renewable energy sources, and advanced public\n",
                                                attributes: exampleBody))
        chattingString.append(NSAttributedString(string: "                     transportation for a sustainable and efficient urban environment.\n",
                                                attributes: exampleBody))
        chattingString.append(NSAttributedString(string: "\n", attributes: body))
        chattingString.append(NSAttributedString(string: "4. Probing Questions\n",
                                                 attributes: label1))
        chattingString.append(NSAttributedString(string: "    Instead of giving direct instructions, ask questions to encourage the model to think and elaborate\n",
                                                 attributes: body))
        chattingString.append(NSAttributedString(string: "\n", attributes: body))
        chattingString.append(NSAttributedString(string: "    User",
                                                 attributes: goodExample))
        chattingString.append(NSAttributedString(string: ": How is technology integrated into everyday life in this city?\n",
                                                attributes: exampleBody))
        chattingString.append(NSAttributedString(string: "    Assistant",
                                                attributes: badExample))
        chattingString.append(NSAttributedString(string: ": Technology seamlessly integrates into daily life through smart homes,\n",
                                                attributes: exampleBody))
        chattingString.append(NSAttributedString(string: "                     AI-driven services, and augmented reality experiences. What specific aspects\n",
                                                attributes: exampleBody))
        chattingString.append(NSAttributedString(string: "                     of daily life would you like more details on?\n",
                                                attributes: exampleBody))
        chattingString.append(NSAttributedString(string: "\n", attributes: body))
        chattingString.append(NSAttributedString(string: "5. Increased Independence\n",
                                                 attributes: label1))
        chattingString.append(NSAttributedString(string: "    Allow the model to generate responses with less explicit guidance\n",
                                                 attributes: body))
        chattingString.append(NSAttributedString(string: "\n", attributes: body))
        chattingString.append(NSAttributedString(string: "    User",
                                                 attributes: goodExample))
        chattingString.append(NSAttributedString(string: ": Describe the transportation system in this futuristic city.\n",
                                                attributes: exampleBody))
        chattingString.append(NSAttributedString(string: "    Assistant",
                                                attributes: badExample))
        chattingString.append(NSAttributedString(string: ": The city boasts a sophisticated transportation network with electric and\n",
                                                attributes: exampleBody))
        chattingString.append(NSAttributedString(string: "                     autonomous vehicles, hyperloop systems, and eco-friendly public transport\n",
                                                attributes: exampleBody))
        chattingString.append(NSAttributedString(string: "                     options to minimize environmental impact.\n",
                                                attributes: exampleBody))
        chattingString.append(NSAttributedString(string: "\n", attributes: body))
        chattingString.append(NSAttributedString(string: "6. Positive Reinforcement\n",
                                                 attributes: label1))
        chattingString.append(NSAttributedString(string: "    Provide positive feedback when the model generates appropriate and contextually relevant responses\n",
                                                 attributes: body))
        chattingString.append(NSAttributedString(string: "\n", attributes: body))
        chattingString.append(NSAttributedString(string: "\n", attributes: body))
        chattingString.append(NSAttributedString(string: "    User",
                                                 attributes: goodExample))
        chattingString.append(NSAttributedString(string: ": Excellent details! Now, what about green spaces and environmental initiatives\n              in this city?\n",
                                                attributes: exampleBody))
        chattingString.append(NSAttributedString(string: "    Assistant",
                                                attributes: badExample))
        chattingString.append(NSAttributedString(string: ": The city prioritizes green spaces, featuring vertical gardens, urban parks,\n",
                                                attributes: exampleBody))
        chattingString.append(NSAttributedString(string: "                     and innovative environmental initiatives such as vertical farming and waste\n",
                                                attributes: exampleBody))
        chattingString.append(NSAttributedString(string: "                     recycling programs.\n",
                                                attributes: exampleBody))
        chattingString.append(NSAttributedString(string: "\n", attributes: body))
        chattingString.append(NSAttributedString(string: "7. Monitor and Adjust\n",
                                                 attributes: label1))
        chattingString.append(NSAttributedString(string: "    Allow the model to generate responses with less explicit guidance\n",
                                                 attributes: body))
        displayText(textString: chattingString, scrollView: chattingTab)
        
        // MARK: Coding Tab
        let codingString = NSMutableAttributedString()
        codingString.append(NSAttributedString(string:"When crafting a message to ChatGPT regarding designing and writing code for\na program, it's important to be clear and provide as much relevant information\nas possible.\n", attributes: body))
        codingString.append(NSAttributedString(string: "\n", attributes: body))
        codingString.append(NSAttributedString(string: "Program Purpose:\n", attributes: label1))
        codingString.append(NSAttributedString(string: "    [Provide a concise description of the program's main purpose and functionality.]\n",
                                               attributes: exampleBody))
        codingString.append(NSAttributedString(string: "\n", attributes: body))
        codingString.append(NSAttributedString(string: "Key Features:\n", attributes: label1))
        codingString.append(NSAttributedString(string: "    [List the key features or functionalities you envision for the program.]\n",
                                               attributes: exampleBody))
        codingString.append(NSAttributedString(string: "\n", attributes: body))
        codingString.append(NSAttributedString(string: "Technical Requirements:\n", attributes: label1))
        codingString.append(NSAttributedString(string: "    [Specify any technical requirements, such as programming language preference,\n",
                                               attributes: exampleBody))
        codingString.append(NSAttributedString(string: "    platform compatibility (e.g., macOS, iOS, Windows), and any specific frameworks or\n",
                                               attributes: exampleBody))
        codingString.append(NSAttributedString(string: "    libraries you intend to use.]\n",
                                               attributes: exampleBody))
        codingString.append(NSAttributedString(string: "\n", attributes: body))
        codingString.append(NSAttributedString(string: "Design Considerations:\n", attributes: label1))
        codingString.append(NSAttributedString(string: "    [Highlight any design preferences or considerations you have for the program's user\n",
                                               attributes: exampleBody))
        codingString.append(NSAttributedString(string: "    interface or overall architecture.]\n",
                                               attributes: exampleBody))
        codingString.append(NSAttributedString(string: "\n", attributes: body))
        codingString.append(NSAttributedString(string: "Additional Information:\n", attributes: label1))
        codingString.append(NSAttributedString(string: "    [Include any additional details that you think may be relevant or helpful for\n",
                                               attributes: exampleBody))
        codingString.append(NSAttributedString(string: "    understanding the project.]\n",
                                               attributes: exampleBody))
        displayText(textString: codingString, scrollView: codingTab)
        
        // MARK: Rendering
        let renderingString = NSMutableAttributedString()
        renderingString.append(NSAttributedString(string:"Information needed to generate diagrams\n", attributes: body))
        displayText(textString: renderingString, scrollView: renderingTab)
        
        
        // MARK: Writing
        let writingString = NSMutableAttributedString()
        writingString.append(NSAttributedString(string:"So examples on information needed by GPTs for generating paragraphs", attributes: body))
        writingString.append(NSAttributedString(string: "\n\n", attributes: body))
        writingString.append(NSAttributedString(string:"--- Cover Letter ---", attributes: title))
        writingString.append(NSAttributedString(string: "\n", attributes: body))
        writingString.append(NSAttributedString(string: "1. Position Information:\n", attributes: label1))
        writingString.append(NSAttributedString(string: "Job Title: ", attributes: boldbody))
        writingString.append(NSAttributedString(string: " [Specify the job title of the position you're applying for.]\n", attributes: body))
        writingString.append(NSAttributedString(string: "Company Name: ", attributes: boldbody))
        writingString.append(NSAttributedString(string: " [Provide the name of the company you're applying to.]\n", attributes: body))
        writingString.append(NSAttributedString(string: "Job Reference Number (if applicable): ", attributes: boldbody))
        writingString.append(NSAttributedString(string: " [Include any reference number\n                                                                        mentioned in the job posting.]\n\n", attributes: body))
        writingString.append(NSAttributedString(string: "2. Your Personal Information:\n", attributes: label1))
        writingString.append(NSAttributedString(string: "Your Full Name: ", attributes: boldbody))
        writingString.append(NSAttributedString(string: " [Provide your full name as you want it to appear in the cover\n                               letter.]\n", attributes: body))
        writingString.append(NSAttributedString(string: "Contact Information: ", attributes: boldbody))
        writingString.append(NSAttributedString(string: " [Include your phone number and professional email\n                                         address.]\n", attributes: body))
        displayText(textString: writingString, scrollView: writingTab)

    }
    
    // MARK: Display String to TextView
    
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
        
        // Hide vertical scroller
        scrollView.hasVerticalScroller = false
        
        // Hide horizontal scroller
        scrollView.hasHorizontalScroller = false
        
        // Appearance Adjustment
        textView.appearance = tipTabView.effectiveAppearance
        textView.backgroundColor = NSColor.clear
        
        // Fine-tune appearance for dark mode
        if NSApp.effectiveAppearance.name == .darkAqua {
            textView.textColor = NSColor.white
        }
    }
    
    // MARK: Load TextView from RTF file
    
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
    
    // MARK: Load TextView from MD file
    
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
