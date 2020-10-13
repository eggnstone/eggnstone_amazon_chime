//
//  ChimeMetricsObserver.swift
//  eggnstone_amazon_chime
//
//  Created by Hendrik Lakämper on 30.07.2020
//

import Foundation
import AmazonChimeSDK
import Flutter

public class ChimeMetricsObserver : MetricsObserver {
    let _eventSink: FlutterEventSink
    
    init(eventSink: @escaping FlutterEventSink) {
        self._eventSink = eventSink
    }
    
    public func metricsDidReceive(metrics: [AnyHashable : Any]) {
//        let json = """
//        {
//        "Name": "OnAudioSessionCancelledReconnect"
//        }
//        """
//        
//        _eventSink(json)
    }
    
//    func convertMetricsToJson(metrics: [AnyHashable : Any]) -> String {
//        return """
//        [
//        \(metrics.map({ (metric: [AnyHashable: Any]) -> String in
//            return """
//        \(metric.)
//        """
//
//        }))
//
//        ]
//        """
//    }
}
