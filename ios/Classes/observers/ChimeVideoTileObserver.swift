//
//  ChimeVideoTileObserver.swift
//  eggnstone_amazon_chime
//
//  Created by Hendrik Lakämper on 30.07.2020
//

import Foundation
import AmazonChimeSDK
import Flutter

public class ChimeVideoTileObserver : VideoTileObserver {
    let _eventSink: FlutterEventSink
    
    init(eventSink: @escaping FlutterEventSink) {
        self._eventSink = eventSink
    }
    
    public func videoTileDidAdd(tileState: VideoTileState) {
        let json = """
        {
        "Name": "OnVideoTileAdded",
        "Arguments": \(self.convertVideoTileStateToJson(tileState: tileState))
        }
        """
        
        _eventSink(json)
    }
    
    public func videoTileDidRemove(tileState: VideoTileState) {
        let json = """
        {
        "Name": "OnVideoTileRemoved",
        "Arguments": \(self.convertVideoTileStateToJson(tileState: tileState))
        }
        """
        
        _eventSink(json)
    }
    
    public func videoTileDidPause(tileState: VideoTileState) {
        let json = """
        {
        "Name": "OnVideoTileDidPause",
        "Arguments": \(self.convertVideoTileStateToJson(tileState: tileState))
        }
        """

        _eventSink(json)
    }
    
    public func videoTileDidResume(tileState: VideoTileState) {
        let json = """
        {
        "Name": "OnVideoTileDidResume",
        "Arguments": \(self.convertVideoTileStateToJson(tileState: tileState))
        }
        """

        _eventSink(json)
    }
    
    public func videoTileSizeDidChange(tileState: VideoTileState) {
        let json = """
        {
        "Name": "OnVideoTileSizeDidChange",
        "Arguments": \(self.convertVideoTileStateToJson(tileState: tileState))
        }
        """

        _eventSink(json)
    }
    
    func convertVideoTileStateToJson(tileState: VideoTileState) -> String {
        return """
        {
        "AttendeeId": "\(tileState.attendeeId)",
        "IsContent": \(tileState.isContent),
        "IsLocalTile": \(tileState.isLocalTile),
        "PauseState": "\(tileState.pauseState)",
        "TileId": \(tileState.tileId),
        "VideoStreamContentHeight": \(tileState.videoStreamContentHeight),
        "VideoStreamContentWidth": \(tileState.videoStreamContentWidth)
        }
        """
    }
}
