//
//  ChimeM.swift
//  eggnstone_amazon_chime
//
//  Created by 長谷川 樹 on 2022/07/25.
//

import Foundation
import AmazonChimeSDK
import Flutter

public class ChimeDataMessageObserver : DataMessageObserver{
    
    let _eventSink: FlutterEventSink
    
    init(eventSink: @escaping FlutterEventSink) {
        self._eventSink = eventSink
    }
    
    
    public func dataMessageDidReceived(dataMessage: DataMessage) {

        let arguments = """
            {
            "timestampMs": "\(dataMessage.timestampMs)",
            "topic": "\(dataMessage.topic)",
            "senderAttendeeId": "\(dataMessage.senderAttendeeId)",
            "senderExternalUserId": "\(dataMessage.senderExternalUserId)",
            "throttled": "\(dataMessage.throttled)",
            "data": "\(dataMessage.data)",
            "text": \(dataMessage.text()!)
            }
            """

        let json = """
            {
            "Name": "OnDataMessageDidReceived",
            "Arguments": \(arguments)
            }
            """

        _eventSink(json)
    }
    
}
