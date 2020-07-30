//
//  ChimeDeviceChangeObserver.swift
//  eggnstone_amazon_chime
//
//  Created by Hendrik Lakämper on 30.07.20.
//

import Foundation
import AmazonChimeSDK

public class ChimeDeviceChangeObserver : DeviceChangeObserver {
    let _eventSink: FlutterEventSink
    
    init(eventSink: @escaping FlutterEventSink) {
        self._eventSink = eventSink
    }
    
    public func audioDeviceDidChange(freshAudioDeviceList: [MediaDevice]) {
        _eventSink(convertMediaDevicesToJson(freshAudioDeviceList: freshAudioDeviceList))
    }
    
    func convertMediaDevicesToJson(freshAudioDeviceList: [MediaDevice]) -> String {
        return """
        [
        \(freshAudioDeviceList.map({ (device: MediaDevice) -> String in
            return """
            {
            "Label": "\(device.label)",
            "Type": "\(device.type)"
            }
            """
        
        }))
        ]
    """
    }
}