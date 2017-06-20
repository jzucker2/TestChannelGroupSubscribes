//
//  ViewController.swift
//  TestChannelGroup
//
//  Created by Jordan Zucker on 6/20/17.
//  Copyright © 2017 Stanera. All rights reserved.
//

import UIKit
import PubNub

class ViewController: UIViewController {
    
    @IBOutlet var publishButton: UIButton!
//    @IBOutlet var consoleTextView: UITextView!
    @IBOutlet var statusTextView: UITextView!
    @IBOutlet var messageTextView: UITextView!
    
//    var currentConsoleText = ""
    var currentMessageText = ""
    var currentStatusText = ""
    
    enum ConsoleType {
        case status
        case message
        
        func textView(for vc: ViewController) -> UITextView {
            switch self {
            case .message:
                return vc.messageTextView
            case .status:
                return vc.statusTextView
            }
        }
        
        func currentText(for vc: ViewController) -> String {
            switch self {
            case .message:
                return vc.currentMessageText
            case .status:
                return vc.currentStatusText
            }
        }
        
        func setCurrentText(for vc: ViewController, with text: String) {
            switch self {
            case .message:
                vc.currentMessageText = text
            case .status:
                vc.currentStatusText = text
            }
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        publishButton.addTarget(self, action: #selector(publishButtonTapped(sender:)), for: .touchUpInside)
//        consoleTextView.delegate = self
//        consoleTextView.isEditable = false
//        consoleTextView.text = currentConsoleText
        messageTextView.delegate = self
        statusTextView.delegate = self
        messageTextView.isEditable = false
        statusTextView.isEditable = false
        statusTextView.text = currentStatusText
        messageTextView.text = currentMessageText
        Network.shared.client.addListener(self)
        Network.shared.client.subscribeToChannelGroups([Network.shared.client.uuid()], withPresence: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    lazy var timeFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .medium
        return dateFormatter
    } ()
    
    // MARK: - Actions
    
    func publishButtonTapped(sender: UIButton) {
//        Network.shared.endpointPostPublish(to: "Test", with: "Hello, world!")
        let channel = "Test"
        let currentTimeString = timeFormatter.string(from: Date())
        let message = "Hello, world! \(currentTimeString)"
        Network.shared.endpointPostPublish(to: channel, with: message) { (result) -> (Void) in
            let text = "Publish to \(channel) with \(message) and " + (result ?? "No result!")
//            self.addToConsole(with: text)
            self.addToConsole(for: .message, with: text)
        }
    }
    
    func addToConsole(for type: ConsoleType, with text: String?) {
        guard let actualText = text else {
            return
        }
        let updateTextView: (String) -> (Void) = {
            let originalText = type.currentText(for: self)
            let updatedText = "\($0)\n".appending(originalText)
            type.setCurrentText(for: self, with: updatedText)
            let currentTextView = type.textView(for: self)
            currentTextView.text = updatedText
            currentTextView.setNeedsLayout()
        }
        DispatchQueue.main.async {
            updateTextView(actualText)
        }
//        DispatchQueue.main.async {
//            self.currentConsoleText = "\(actualText)\n".appending(self.currentConsoleText)
//            self.consoleTextView.text = self.currentConsoleText
//            self.consoleTextView.setNeedsLayout()
//        }
    }


}

extension ViewController: PNObjectEventListener {
    
    func client(_ client: PubNub, didReceive status: PNStatus) {
        let text = "Status: \(status.debugDescription)"
//        addToConsole(with: text)
        addToConsole(for: .status, with: text)
    }
    
    func client(_ client: PubNub, didReceiveMessage message: PNMessageResult) {
        let text = "Status: \(message.debugDescription)"
//        addToConsole(with: text)
        addToConsole(for: .message, with: text)
    }
    
    func client(_ client: PubNub, didReceivePresenceEvent event: PNPresenceEventResult) {
        let text = "Status: \(event.debugDescription)"
//        addToConsole(with: text)
        addToConsole(for: .status, with: text)
    }
    
}

extension ViewController: UITextViewDelegate {
    
    
}

