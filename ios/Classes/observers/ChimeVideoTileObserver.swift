//
//  ChimeVideoTileObserver.swift
//  eggnstone_amazon_chime
//
//  Created by Hendrik Lakämper on 30.07.20.
//

import Foundation
import AmazonChimeSDK

public class ChimeVideoTileObserver : VideoTileObserver {
    let _eventSink: FlutterEventSink
    
    init(eventSink: @escaping FlutterEventSink) {
        self._eventSink = eventSink
    }
    
    public func videoTileDidAdd(tileState: VideoTileState) {
        let arguments = """
        {
        "Arguments": "\(self.convertVideoTileStateToJson(tileState: tileState))"
        }
        """
        
        let json = """
        {
        "Name": "OnVideoTileDidAdd",
        "Arguments": \(arguments)
        }
        """
        
        
        _eventSink(json)
    }
    
    public func videoTileDidRemove(tileState: VideoTileState) {
        let arguments = """
        {
        "Arguments": "\(self.convertVideoTileStateToJson(tileState: tileState))"
        }
        """
        
        let json = """
        {
        "Name": "OnVideoTileDidRemove",
        "Arguments": \(arguments)
        }
        """
        
        
        _eventSink(json)
    }
    
    public func videoTileDidPause(tileState: VideoTileState) {
        let arguments = """
        {
        "Arguments": "\(self.convertVideoTileStateToJson(tileState: tileState))"
        }
        """
        
        let json = """
        {
        "Name": "OnVideoTileDidPause",
        "Arguments": \(arguments)
        }
        """
        
        
        _eventSink(json)
    }
    
    public func videoTileDidResume(tileState: VideoTileState) {
        let arguments = """
        {
        "Arguments": "\(self.convertVideoTileStateToJson(tileState: tileState))"
        }
        """
        
        let json = """
        {
        "Name": "OnVideoTileDidResume",
        "Arguments": \(arguments)
        }
        """
        
        
        _eventSink(json)
    }
    
    public func videoTileSizeDidChange(tileState: VideoTileState) {
        let arguments = """
        {
        "Arguments": "\(self.convertVideoTileStateToJson(tileState: tileState))"
        }
        """
        
        let json = """
        {
        "Name": "OnVideoTileSizeDidChange",
        "Arguments": \(arguments)
        }
        """
        
        
        _eventSink(json)
    }
    
    func convertVideoTileStateToJson(tileState: VideoTileState) -> String {
        return """
        {
        "AttendeeId": "\(tileState.attendeeId)",
        "IsContent": "\(tileState.isContent)",
        "IsLocalTile": "\(tileState.isLocalTile)",
        "PauseState": "\(tileState.pauseState)",
        "TileId": "\(tileState.tileId)",
        }
        """
    }
}
