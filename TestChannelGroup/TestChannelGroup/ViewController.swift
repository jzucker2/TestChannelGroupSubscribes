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
    @IBOutlet var consoleTextView: UITextView!
    
    var currentConsoleText = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        publishButton.addTarget(self, action: #selector(publishButtonTapped(sender:)), for: .touchUpInside)
        consoleTextView.delegate = self
        consoleTextView.isEditable = false
        consoleTextView.text = currentConsoleText
        Network.shared.client.addListener(self)
        Network.shared.client.subscribeToChannelGroups([Network.shared.client.uuid()], withPresence: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    
    func publishButtonTapped(sender: UIButton) {
//        Network.shared.endpointPostPublish(to: "Test", with: "Hello, world!")
        let channel = "Test"
        let message = "Hello, world!"
        Network.shared.endpointPostPublish(to: channel, with: message) { (result) -> (Void) in
            let text = "Publish to \(channel) with \(message) and " + (result ?? "No result!")
            self.addToConsole(with: text)
        }
    }
    
    func addToConsole(with text: String?) {
        guard let actualText = text else {
            return
        }
        DispatchQueue.main.async {
            self.currentConsoleText = "\(actualText)\n".appending(self.currentConsoleText)
            self.consoleTextView.text = self.currentConsoleText
            self.consoleTextView.setNeedsLayout()
        }
    }


}

extension ViewController: PNObjectEventListener {
    
    func client(_ client: PubNub, didReceive status: PNStatus) {
        let text = "Status: \(status.debugDescription)"
        addToConsole(with: text)
    }
    
    func client(_ client: PubNub, didReceiveMessage message: PNMessageResult) {
        let text = "Status: \(message.debugDescription)"
        addToConsole(with: text)
    }
    
    func client(_ client: PubNub, didReceivePresenceEvent event: PNPresenceEventResult) {
        let text = "Status: \(event.debugDescription)"
        addToConsole(with: text)
    }
    
}

extension ViewController: UITextViewDelegate {
    
    
}

