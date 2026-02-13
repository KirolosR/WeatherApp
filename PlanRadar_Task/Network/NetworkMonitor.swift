//
//  NetworkMonitor.swift
//  PlanRadar_Task
//
//  Created by Kirolos Ramses on 22/10/2025.
//

import Foundation
import Network

public class NetworkMonitor {
    public static let shared = NetworkMonitor()

    private let monitor: NWPathMonitor
    private let queue = DispatchQueue(label: "NetworkMonitor")

    private var status: NWPath.Status = .requiresConnection
    public var isReachable: Bool { status == .satisfied }
    public var isReachableOnCellular: Bool = true
    
    public init () {
        monitor = NWPathMonitor()
    }

    public func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.status = path.status
            //Preferences.shared.isNetworkReachable = (path.status == .satisfied)
            self?.isReachableOnCellular = path.isExpensive
        }
        monitor.start(queue: queue)
    }
    
    

    public func stopMonitoring() {
        monitor.cancel()
    }
}
