import Flutter
import UIKit
import AmazonChimeSDK
import AmazonChimeSDKMedia


public class SwiftEggnstoneAmazonChimePlugin: NSObject, FlutterPlugin {
    
    var _meetingSession: MeetingSession?
    //var _applicationContext: Context?
    var _methodChannel: FlutterMethodChannel?
    var _audioVideoFacade: AudioVideoFacade?
    var _eventSink: FlutterEventSink?
    
    override init() {
        
    }
    
  public static func register(with registrar: FlutterPluginRegistrar) {

    let channel = FlutterMethodChannel(name: "ChimePlugin", binaryMessenger: registrar.messenger())
    let instance = SwiftEggnstoneAmazonChimePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)

    let eventChannel = FlutterEventChannel(name: "ChimePluginEvents", binaryMessenger: registrar.messenger())
    eventChannel.setStreamHandler(ExampleStreamHandler())

    let viewFactory = ChimeDefaultVideoRenderViewFactory()
    registrar.register(viewFactory, withId: "ChimeDefaultVideoRenderView")
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    
    switch call.method {
    case "GetVersion": result("Amazon Chime Version currently unknown")
    case "CreateMeetingSession": self.handleCreateMeetingSession(call: call, result: result)
    case "AudioVideoStart": self.handleAudioVideoStart(result: result)
    case "AudioVideoStop": self.handleAudioVideoStop(result: result)
    case "AudioVideoStartLocalVideo": self.handleAudioVideoStartLocalVideo(result: result)
    case "AudioVideoStopLocalVideo": self.handleAudioVideoStopLocalVideo(result: result)
    case "AudioVideoStartRemoteVideo": self.handleAudioVideoStartRemoteVideo(result: result)
    case "AudioVideoStopRemoteVideo": self.handleAudioVideoStopRemoteVideo(result: result)
    case "BindVideoView": self.handleBindVideoView(call: call, result: result)
    case "UnbindVideoView": self.handleUnbindVideoView(call: call, result: result)
    default:result(FlutterMethodNotImplemented)
    }
    
  }
    
    func handleCreateMeetingSession(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments else {
            result(FlutterError())
            return
        }
        
        if let myArgs = args as? [String:Any],
            let meetingId = myArgs["MeetingId"] as? String,
            let externalMeetingId = myArgs["ExternalMeetingId"] as? String,
            let mediaRegion = myArgs["MediaRegion"] as? String,
            let mediaPlacementAudioHostUrl = myArgs["MediaPlacementAudioHostUrl"] as? String,
            let mediaPlacementAudioFallbackUrl = myArgs["MediaPlacementAudioFallbackUrl"]as? String,
            let mediaPlacementSignalingUrl = myArgs["MediaPlacementSignalingUrl"]as? String,
            let mediaPlacementTurnControlUrl = myArgs["MediaPlacementTurnControlUrl"]as? String,
            let attendeeId = myArgs["AttendeeId"]as? String,
            let externalUserId = myArgs["ExternalUserId"]as? String,
            let joinToken = myArgs["JoinToken"]as? String
        {
            let mediaPlacement = MediaPlacement.init(audioFallbackUrl: mediaPlacementAudioFallbackUrl, audioHostUrl: mediaPlacementAudioHostUrl, signalingUrl: mediaPlacementSignalingUrl, turnControlUrl: mediaPlacementTurnControlUrl)
            
            let meeting = Meeting(externalMeetingId: externalMeetingId, mediaPlacement: mediaPlacement, mediaRegion: mediaRegion, meetingId: meetingId)
            
            let meetingResponse = CreateMeetingResponse(meeting: meeting)
            
            let attendee = Attendee(attendeeId: attendeeId, externalUserId: externalUserId, joinToken: joinToken)
            
            let attendeeResponse = CreateAttendeeResponse(attendee: attendee)
            
            let configuration = MeetingSessionConfiguration(createMeetingResponse: meetingResponse, createAttendeeResponse: attendeeResponse)
            
            _meetingSession = DefaultMeetingSession(configuration: configuration, logger: AmazonChimeSDK.ConsoleLogger(name: "debug"))
            _audioVideoFacade = _meetingSession?.audioVideo
            _audioVideoFacade?.addAudioVideoObserver(observer: ChimeAudioVideoObserver())
            _audioVideoFacade?.addMetricsObserver(observer: ChimeMetricsObserver())
            _audioVideoFacade?.addRealtimeObserver(observer: ChimeRealtimeObserver())
            _audioVideoFacade?.addDeviceChangeObserver(observer: ChimeDeviceChangeObserver())
            _audioVideoFacade?.addVideoTileObserver(observer: ChimeVideoTileObserver())
            
            result("OK")
        }
    }
    
    func handleAudioVideoStart(result: @escaping FlutterResult) {
        if checkAudioVideoFacade(result: result, source: "AudioVideoStart") {
            return
        }
                    
        try? _audioVideoFacade?.start()
        
    }
    func handleAudioVideoStop(result: @escaping FlutterResult) {
        if checkAudioVideoFacade(result: result, source: "AudioVideoStop") {
            return
        }
        
        try? _audioVideoFacade?.stop()
    }
    func handleAudioVideoStartLocalVideo(result: @escaping FlutterResult) {
        if checkAudioVideoFacade(result: result, source: "AudioVideoStartLocalVideo") {
            return
        }
        try? _audioVideoFacade?.startLocalVideo()
        
    }
    func handleAudioVideoStopLocalVideo(result: @escaping FlutterResult) {
        if checkAudioVideoFacade(result: result, source: "AudioVideoStopLocalVideo") {
            return
        }
        try? _audioVideoFacade?.stopLocalVideo()
    }
    func handleAudioVideoStartRemoteVideo(result: @escaping FlutterResult) {
        if checkAudioVideoFacade(result: result, source: "AudioVideoStartRemoteVideo") {
            return
        }
        try? _audioVideoFacade?.startRemoteVideo()
    }
    func handleAudioVideoStopRemoteVideo(result: @escaping FlutterResult) {
        if checkAudioVideoFacade(result: result, source: "AudioVideoStopRemoteVideo") {
            return
        }
        try? _audioVideoFacade?.stopRemoteVideo()
    }
    func handleBindVideoView(call: FlutterMethodCall, result: @escaping FlutterResult) {
        if checkAudioVideoFacade(result: result, source: "BindVideoView") {
            return
        }
        
        let args = call.arguments as? [String: Any]
        
        if let myArgs = args as? [String:Any],
            let tileId = myArgs["tileId"] as? Int,
            let viewId = myArgs["viewId"] as? Int64 {
            
            let videoRenderView: VideoRenderView = ChimeDefaultVideoRenderViewFactory.getViewById(id: viewId)?.view() as! VideoRenderView
            
            try? _audioVideoFacade?.bindVideoView(videoView: videoRenderView , tileId: tileId)
        }
    }
    func handleUnbindVideoView(call: FlutterMethodCall, result: @escaping FlutterResult) {
        if checkAudioVideoFacade(result: result, source: "UnbindVideoView") {
            return
        }
        
        let args = call.arguments as? [String: Any]
        
        if let myArgs = args as? [String:Any],
            let tileId = myArgs["tileId"] as? Int {
            try? _audioVideoFacade?.unbindVideoView(tileId: tileId)
        }
    }
    
    func checkAudioVideoFacade(result: FlutterResult, source: String) -> Bool
     {
         if (_meetingSession == nil)
         {
             result("$source: $ERROR__NO_MEETING_SESSION__ERROR_MESSAGE")
             return false
         }

         if (_audioVideoFacade == nil)
         {
             result("$source: $ERROR__NO_AUDIO_VIDEO_FACADE__ERROR_MESSAGE")
             return false
         }

         return true
     }
}

class ExampleStreamHandler: NSObject, FlutterStreamHandler {
  private var _eventSink: FlutterEventSink?

  func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
      _eventSink = events
      return nil
  }

  func onCancel(withArguments arguments: Any?) -> FlutterError? {
      _eventSink = nil
      return nil
  }
}
