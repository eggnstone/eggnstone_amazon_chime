//
//  ChimeAudioVideoObserver.swift
//  eggnstone_amazon_chime
//
//  Created by Hendrik Lakämper on 30.07.20.
//

import Foundation
import AmazonChimeSDK

public class ChimeAudioVideoObserver: AudioVideoObserver {
    public func audioSessionDidStartConnecting(reconnecting: Bool) {
        
    }
    
    public func audioSessionDidStart(reconnecting: Bool) {
        
    }
    
    public func audioSessionDidDrop() {
        
    }
    
    public func audioSessionDidStopWithStatus(sessionStatus: MeetingSessionStatus) {
        
    }
    
    public func audioSessionDidCancelReconnect() {
        
    }
    
    public func connectionDidRecover() {
        
    }
    
    public func connectionDidBecomePoor() {
        
    }
    
    public func videoSessionDidStartConnecting() {
        
    }
    
    public func videoSessionDidStartWithStatus(sessionStatus: MeetingSessionStatus) {
        
    }
    
    public func videoSessionDidStopWithStatus(sessionStatus: MeetingSessionStatus) {
        
    }
}
