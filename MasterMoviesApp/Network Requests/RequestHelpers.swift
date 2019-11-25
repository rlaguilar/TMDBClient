//
//  RequestHelpers.swift
//  MasterMoviesApp
//
//  Created by Reynaldo Aguilar on 29/10/19.
//  Copyright © 2019 Reynaldo Aguilar. All rights reserved.
//

import Foundation
import UIKit

public struct APIAuthHelper: RequestHelper {
    public let extraParams: RequestParams
    
    public init(apiKey: String = "340528aae953e802b9f330ecb5aedbed") {
        extraParams = ["api_key": apiKey]
    }
    
    public func willSend(request: URLRequest) {}
    
    public func didReceiveResponse(for request: URLRequest) {}
}

public class BackgroundTaskHelper: RequestHelper {
    public let extraParams: RequestParams = [:]
    
    private let syncQueue = DispatchQueue(label: "com.mastermoviesapp.background-task-helper.sync-queue")
    
    private var taskIdentifiers: [URLRequest: UIBackgroundTaskIdentifier] = [:]
    
    private let backgroundTaskHandler: BackgroundTaskHandler
    
    public init(backgroundTaskHandler: BackgroundTaskHandler = UIApplication.shared) {
        self.backgroundTaskHandler = backgroundTaskHandler
    }
    
    public func willSend(request: URLRequest) {
        let identifier = backgroundTaskHandler.beginBackgroundTask {
            self.finishtTask(for: request)
        }
        
        syncQueue.async {
            self.taskIdentifiers[request] = identifier
        }
    }
    
    public func didReceiveResponse(for request: URLRequest) {
        finishtTask(for: request)
    }
    
    private func finishtTask(for request: URLRequest) {
        syncQueue.async {
            if let identifier = self.taskIdentifiers[request] {
                self.backgroundTaskHandler.endBackgroundTask(identifier)
                self.taskIdentifiers[request] = nil
            }
        }
    }
}

public class RequestProfiler: RequestHelper {
    public let extraParams: RequestParams = [:]
    
    private var startTimes: [URLRequest: Date] = [:]
    
    public func willSend(request: URLRequest) {
        startTimes[request] = Date()
    }
    
    public func didReceiveResponse(for request: URLRequest) {
        guard let start = startTimes[request] else {
            return
        }

        startTimes[request] = nil
        let time = Date().timeIntervalSince(start)
        print("It took \(time) seconds to perform request to \(request)")
    }
}

public protocol BackgroundTaskHandler {
    func beginBackgroundTask(expirationHandler handler: (() -> Void)?) -> UIBackgroundTaskIdentifier
    
    func endBackgroundTask(_ identifier: UIBackgroundTaskIdentifier)
}

extension UIApplication: BackgroundTaskHandler { }
