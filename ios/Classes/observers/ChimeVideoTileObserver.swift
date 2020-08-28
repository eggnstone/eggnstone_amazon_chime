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
        //"Name": "OnVideoTileDidAdd",
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
        "Name": "OnVideoTileDidRemove",
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
        let state: NSDictionary = [
            "AttendeeId" : tileState.attendeeId,
            "IsContent" : tileState.isContent,
            "IsLocalTile" : tileState.isLocalTile,
            "PauseState" : tileState.pauseState.rawValue,
            "TileId": tileState.tileId,
            "VideoStreamContentHeight": tileState.videoStreamContentHeight,
            "VideoStreamContentWidth": tileState.videoStreamContentWidth
        ]
        let json = try? JSONSerialization.data(withJSONObject: state, options: [])
        return String(data: json!, encoding: .utf8)!
    }
}
