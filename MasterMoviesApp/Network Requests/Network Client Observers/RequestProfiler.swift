//
//  RequestHelpers.swift
//  MasterMoviesApp
//
//  Created by Reynaldo Aguilar on 29/10/19.
//  Copyright © 2019 Reynaldo Aguilar. All rights reserved.
//

import Foundation
import os

public class RequestProfiler: NetoworkClientObserver {
    private let networkLog: OSLog

    private var signpostIDs: [URLRequest: OSSignpostID] = [:]
    
    public init() {
        networkLog = OSLog(subsystem: "com.master-movies-app", category: "Network Requests Profiler")
    }
    
    public func willSend(request: URLRequest) {
        guard networkLog.signpostsEnabled else { return }
        
//        os_log(.error, log: networkLog, "Sending request %s", "\(request)")
        let spid = OSSignpostID(log: networkLog)
        signpostIDs[request] = spid
        os_signpost(.begin, log: networkLog, name: "Load Request", signpostID: spid, "%s", "\(request)")
    }
    
    public func didFinishLoadingContent(for request: URLRequest, data: Data, response: HTTPURLResponse) {
        guard networkLog.signpostsEnabled, let spid = signpostID(for: request) else { return }
        
        let format: StaticString = "Status Code: %d, Size: %{xcode:network-size-in-bytes}llu"
        os_signpost(.end, log: networkLog, name: "Load Request", signpostID: spid, format, response.statusCode, data.count)
    }
    
    public func didFailLoadingContent(for request: URLRequest, withError error: Error) {
        guard networkLog.signpostsEnabled, let spid = signpostID(for: request) else { return }
        
        os_signpost(.end, log: networkLog, name: "Load Request", signpostID: spid, "Error: %s", "\(error)")
    }
    
    private func signpostID(for request: URLRequest) -> OSSignpostID? {
        return signpostIDs[request]
    }
}
