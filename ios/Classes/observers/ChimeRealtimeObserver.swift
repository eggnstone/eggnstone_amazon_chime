//
//  ChimeRealtimeObserver.swift
//  eggnstone_amazon_chime
//
//  Created by Hendrik Lakämper on 30.07.2020
//

import Foundation
import AmazonChimeSDK
import Flutter

public class ChimeRealtimeObserver : RealtimeObserver {
    let _eventSink: FlutterEventSink
    
    init(eventSink: @escaping FlutterEventSink) {
        self._eventSink = eventSink
    }
    
    public func volumeDidChange(volumeUpdates: [VolumeUpdate]) {
        _eventSink("""
            {
            "Name": "OnVolumeDidChange",
            "Arguments": [\(convertSignalUpdatesToJson(volumeUpdates: volumeUpdates))]
            }
            """)
    }
    
    public func signalStrengthDidChange(signalUpdates: [SignalUpdate]) {
        _eventSink("""
            {
            "Name": "OnSignalStrengthDidChange",
            "Arguments": [\(convertSignalUpdatesToJson(signalUpdates: signalUpdates)) ]
            }
            """)
    }
    
    public func attendeesDidJoin(attendeeInfo: [AttendeeInfo]) {
        _eventSink("""
            {
            "Name": "OnAttendeesDidJoin",
            "Arguments": [\(convertAttendeeInfosToJson(attendeeInfo: attendeeInfo))]
            }
            """)
    }
    
    public func attendeesDidLeave(attendeeInfo: [AttendeeInfo]) {
        _eventSink("""
            {
            "Name": "OnAttendeesDidLeave",
            "Arguments": [\(convertAttendeeInfosToJson(attendeeInfo: attendeeInfo))]
            }
            """)
    }
    
    public func attendeesDidDrop(attendeeInfo: [AttendeeInfo]) {
        _eventSink("""
            {
            "Name": "OnAttendeesDidDrop",
            "Arguments": [\(convertAttendeeInfosToJson(attendeeInfo: attendeeInfo))]
            }
            """)
    }
    
    public func attendeesDidMute(attendeeInfo: [AttendeeInfo]) {
        _eventSink("""
            {
            "Name": "OnAttendeesDidMute",
            "Arguments": [\(convertAttendeeInfosToJson(attendeeInfo: attendeeInfo))]
            }
            """)
    }
    
    public func attendeesDidUnmute(attendeeInfo: [AttendeeInfo]) {
        _eventSink("""
            {
            "Name": "OnAttendeesDidUnmute",
            "Arguments": [\(convertAttendeeInfosToJson(attendeeInfo: attendeeInfo))]
            }
            """)
    }
    
    func convertAttendeeInfosToJson(attendeeInfo: [AttendeeInfo]) -> String {
        return """
            [
            \(attendeeInfo.map({ (info: AttendeeInfo) -> String in
            return """
            {
            "AttendeeId": "\(info.attendeeId)",
            "ExernalUserId": "\(info.externalUserId)"
            }
            """
            }))
            ]
            """
    }
    
    func convertSignalUpdatesToJson(signalUpdates: [SignalUpdate]) -> String {
        return signalUpdates.map({ (update: SignalUpdate) -> String in
            return """
                {
                "AttendeeId": "\(update.attendeeInfo.attendeeId)",
                "ExernalUserId": "\(update.attendeeInfo.externalUserId)",
                "SignalStrength": "\(update.signalStrength)"
                }
                """
                }).joined(separator: ",")
    }
    
    func convertSignalUpdatesToJson(volumeUpdates: [VolumeUpdate]) -> String {
        return
        volumeUpdates.map({ (update: VolumeUpdate) -> String in
            return """
            {
            "AttendeeId": "\(update.attendeeInfo.attendeeId)",
            "ExernalUserId": "\(update.attendeeInfo.externalUserId)",
            "VolumeLevel": "\(update.volumeLevel)"
            }
            """
            }).joined(separator: ",")
    }
}
