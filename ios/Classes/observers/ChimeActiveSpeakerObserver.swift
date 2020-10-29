//
//  ChimeActiveSpeakerObserver.swift
//  eggnstone_amazon_chime
//
//  Created by Hendrik Lakämper on 27.10.20.
//

import Foundation
import AmazonChimeSDK
import Flutter

public class ChimeActiveSpeakerObserver : ActiveSpeakerObserver{
    public var observerId: String = ""
    
    let _eventSink: FlutterEventSink
    
    init(eventSink: @escaping FlutterEventSink) {
        self._eventSink = eventSink
    }
    
    public func activeSpeakerDidDetect(attendeeInfo: [AttendeeInfo]) {
        _eventSink("""
            {
            "Name": "OnActiveSpeakerDetected",
            "Arguments": [\(convertAttendeeInfoToJson(infos: attendeeInfo))]
            }
        """)
    }
    
    func convertAttendeeInfoToJson(infos: [AttendeeInfo]) -> String {
        return infos.map({ (info: AttendeeInfo) -> String in
            return """
            {
            "AttendeeId": "\(info.attendeeId)",
            "ExternalUserId": "\(info.externalUserId)"
            }
            """
        }).joined(separator: ",")
    }
}
