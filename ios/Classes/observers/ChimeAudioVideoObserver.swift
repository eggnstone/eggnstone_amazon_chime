//
//  ChimeAudioVideoObserver.swift
//  eggnstone_amazon_chime
//
//  Created by Hendrik Lakämper on 30.07.2020
//

import Foundation
import Flutter
import AmazonChimeSDK

public class ChimeAudioVideoObserver: AudioVideoObserver {
    let _eventSink: FlutterEventSink
    
    init(eventSink: @escaping FlutterEventSink) {
        self._eventSink = eventSink
    }
    
    public func audioSessionDidStartConnecting(reconnecting: Bool) {
        let json = """
            {
            "Name": "OnAudioSessionCancelledReconnect"
            }
            """
        
        _eventSink(json)
    }
    
    public func audioSessionDidStart(reconnecting: Bool) {
        let json = """
            {
            "Name": "OnAudioSessionStarted"
            }
            """
        
        _eventSink(json)
    }
    
    public func audioSessionDidDrop() {
        let json = """
            {
            "Name": "OnAudioSessionDidDrop"
            }
            """
        
        _eventSink(json)
    }
    
    public func audioSessionDidStopWithStatus(sessionStatus: MeetingSessionStatus) {
        let arguments = """
            {
            "sessionStatus": "\(sessionStatus.statusCode)"
            }
            """
        
        let json = """
            {
            "Name": "OnAudioSessionCancelledReconnect",
            "Arguments": \(arguments)
            }
            """
        
        _eventSink(json)
    }
    
    public func audioSessionDidCancelReconnect() {
        let json = """
            {
            "Name": "OnAudioSessionDidCancelReconnect"
            }
            """
        
        _eventSink(json)
    }
    
    public func connectionDidRecover() {
        let json = """
            {
            "Name": "OnConnectionDidRecover"
            }
        """
        
        _eventSink(json)
    }
    
    public func connectionDidBecomePoor() {
        let json = """
            {
            "Name": "OnConnectionDidBecomePoor"
            }
            """
        
        _eventSink(json)
    }
    
    public func videoSessionDidStartConnecting() {
        let json = """
            {
            "Name": "OnVideoSessionDidStartConnecting"
            }
            """
        
        _eventSink(json)
    }
    
    public func videoSessionDidStartWithStatus(sessionStatus: MeetingSessionStatus) {
        let arguments = """
            {
            "sessionStatus": "\(sessionStatus.statusCode)"
            }
            """
        
        let json = """
            {
            "Name": "OnVideoSessionDidStartWithStatus",
            "Arguments": \(arguments)
            }
            """
        
        _eventSink(json)
    }
    
    public func videoSessionDidStopWithStatus(sessionStatus: MeetingSessionStatus) {
        let arguments = """
            {
            "sessionStatus": "\(sessionStatus.statusCode)"
            }
            """
        
        let json = """
            {
            "Name": "OnVideoSessionDidStopWithStatus",
            "Arguments": \(arguments)
            }
            """
        
        _eventSink(json)
    }
}
