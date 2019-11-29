//
//  BackgroundTaskStarter.swift
//  MasterMoviesApp
//
//  Created by Reynaldo Aguilar on 29/11/19.
//  Copyright © 2019 Reynaldo Aguilar. All rights reserved.
//

import Foundation
import UIKit

public class BackgroundTaskStarter: NetoworkClientObserver {
    private let syncQueue = DispatchQueue(label: "com.mastermoviesapp.background-task-helper.sync-queue")
    
    private var taskIdentifiers: [URLRequest: UIBackgroundTaskIdentifier] = [:]
    
    private let backgroundTaskHandler: BackgroundTaskHandler
    
    public init(backgroundTaskHandler: BackgroundTaskHandler = UIApplication.shared) {
        self.backgroundTaskHandler = backgroundTaskHandler
    }
    
    public func willSend(request: URLRequest) {
        let identifier = backgroundTaskHandler.beginBackgroundTask {
            self.finishTask(for: request)
        }
        
        syncQueue.async {
            self.taskIdentifiers[request] = identifier
        }
    }
    
    public func didFinishLoadingContent(for request: URLRequest, data: Data, response: HTTPURLResponse) {
        finishTask(for: request)
    }
    
    public func didFailLoadingContent(for request: URLRequest, withError error: Error) {
        finishTask(for: request)
    }
    
    private func finishTask(for request: URLRequest) {
        syncQueue.async {
            if let identifier = self.taskIdentifiers[request] {
                self.backgroundTaskHandler.endBackgroundTask(identifier)
                self.taskIdentifiers[request] = nil
            }
        }
    }
}

public protocol BackgroundTaskHandler {
    func beginBackgroundTask(expirationHandler handler: (() -> Void)?) -> UIBackgroundTaskIdentifier
    
    func endBackgroundTask(_ identifier: UIBackgroundTaskIdentifier)
}

extension UIApplication: BackgroundTaskHandler { }
