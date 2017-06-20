//
//  Network.swift
//  TestChannelGroup
//
//  Created by Jordan Zucker on 6/20/17.
//  Copyright © 2017 Stanera. All rights reserved.
//

import UIKit
import PubNub

class Network: NSObject {
    
    static let shared = Network()
    
    let client: PubNub
    
    override required init() {
        let config = PNConfiguration(publishKey: "pub-c-9d718298-ebb9-4e82-92c3-5cb856682288", subscribeKey: "sub-c-7c127a94-55e2-11e7-bc9c-0619f8945a4f")
        config.stripMobilePayload = false
        self.client = PubNub.clientWithConfiguration(config)
        super.init()
        client.addListener(self)
    }

}

extension Network: PNObjectEventListener {
    
//    func client(_ client: PubNub, didReceive status: PNStatus) {
//        print("\(#function) => status: \(status.debugDescription)")
//    }
//    
//    func client(_ client: PubNub, didReceiveMessage message: PNMessageResult) {
//        print("\(#function) => message: \(message.debugDescription)")
//    }
//    
//    func client(_ client: PubNub, didReceivePresenceEvent event: PNPresenceEventResult) {
//        print("\(#function) => presenceEvent: \(event.debugDescription)")
//    }
    
}

extension Network {
    
    func endpointPostPublish(to channel: String, with message: String, and completion: @escaping (String?) -> (Void)) {
        let sessionConfig = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: sessionConfig)
//        let urlString = "https://pubsub.pubnub.com/v1/blocks/sub-key/sub-c-7c127a94-55e2-11e7-bc9c-0619f8945a4f/publish"
        
//        guard let encodedMessage = message.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
//            fatalError()
//        }
//        let messageQueryString = "message=\(encodedMessage)"
//        let finalMessageURL = "\(urlString)?\(messageQueryString)"
//        guard let actualURL = URL(string: finalMessageURL) else {
//            fatalError()
//        }
//        var urlRequest = URLRequest(url: actualURL)
//        urlRequest.httpMethod = "POST"
//        session.dataTask(with: urlRequest) { (data, response, error) in
//            
//        }
        var requestURL = URLComponents()
        requestURL.scheme = "https"
        requestURL.host = "pubsub.pubnub.com"
        requestURL.path = "/v1/blocks/sub-key/sub-c-7c127a94-55e2-11e7-bc9c-0619f8945a4f/publish"
        requestURL.queryItems = [
            URLQueryItem(name: "sender", value: self.client.uuid()),
            URLQueryItem(name: "channel", value: channel)
        ]
        let messageDict: [String:String] = [
            "message": message,
            "sender": self.client.uuid()
        ]
        var messageBody: Data
        do {
            messageBody = try JSONSerialization.data(withJSONObject: messageDict, options: .prettyPrinted)
        } catch {
            fatalError(error.localizedDescription)
        }
//        guard let actualURL = URL(string: urlString) else {
//            fatalError()
//        }
//        var urlRequest = URLRequest(url: actualURL)
        guard let actualURL = requestURL.url else {
            fatalError()
        }
        var urlRequest = URLRequest(url: actualURL)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = messageBody
        session.dataTask(with: urlRequest) { (data, response, error) in
            guard let actualData = data else {
                completion(nil)
                return
            }
//            do {
//                let responseObject = try JSONSerialization.jsonObject(with: actualData, options: [.allowFragments])
//                print("responseData: \(responseObject)")
//            } catch {
//                fatalError(error.localizedDescription)
//            }
            guard let responseString = String(data: actualData, encoding: .utf8) else {
                fatalError()
            }
            print("responseString: \(responseString)")
            completion(responseString)
        }.resume()
        
        
        
    }
    
}

