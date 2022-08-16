import Flutter
import UIKit
import AmazonChimeSDK
import AmazonChimeSDKMedia

public class SwiftEggnstoneAmazonChimePlugin: NSObject, FlutterPlugin {
    var _meetingSession: MeetingSession?
    var audioVideoConfig = AudioVideoConfiguration()
    //var _applicationContext: Context?
    var _methodChannel: FlutterMethodChannel?
    var _audioVideoFacade: AudioVideoFacade?

    var _audioOutputs: [MediaDevice] = [MediaDevice]()

    public static func register(with registrar: FlutterPluginRegistrar) {

        let channel = FlutterMethodChannel(name: "ChimePlugin", binaryMessenger: registrar.messenger())
        let instance = SwiftEggnstoneAmazonChimePlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)

        let eventChannel = FlutterEventChannel(name: "ChimePluginEvents", binaryMessenger: registrar.messenger())
        eventChannel.setStreamHandler(ExampleStreamHandler.get())

        let viewFactory = ChimeDefaultVideoRenderViewFactory()
        registrar.register(viewFactory, withId: "ChimeDefaultVideoRenderView")
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        print(call.method)

        switch call.method {
            case "AudioVideoStart": self.handleAudioVideoStart(result: result)
            case "AudioVideoStop": self.handleAudioVideoStop(result: result)
            case "AudioVideoStartLocalVideo": self.handleAudioVideoStartLocalVideo(result: result)
            case "AudioVideoStopLocalVideo": self.handleAudioVideoStopLocalVideo(result: result)
            case "AudioVideoStartRemoteVideo": self.handleAudioVideoStartRemoteVideo(result: result)
            case "AudioVideoStopRemoteVideo": self.handleAudioVideoStopRemoteVideo(result: result)
            case "BindVideoView": self.handleBindVideoView(call: call, result: result)
            case "ChooseAudioDevice": self.handleChooseAudioDevice(call: call, result: result)
            // case "ClearViewIds": self.handleClearViewIds(call: call, result: result)
            case "CreateMeetingSession": self.handleCreateMeetingSession(call: call, result: result)
            case "GetVersion": self.getSDKVersion(result: result)
            case "ListAudioDevices": self.handleListAudioDevices(result: result)
            case "Mute": self.handleMute(result: result)
            case "SendDataMessage": self.handleSendDataMessage(call: call, result: result)
            case "UnbindVideoView": self.handleUnbindVideoView(call: call, result: result)
            case "Unmute": self.handleUnmute(result: result)

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
            let mr = CreateMeetingResponse(meeting: meeting)
            let attendee = Attendee(attendeeId: attendeeId, externalUserId: externalUserId, joinToken: joinToken)
            let ar = CreateAttendeeResponse(attendee: attendee)
            let configuration = MeetingSessionConfiguration(createMeetingResponse: mr, createAttendeeResponse: ar)

            _meetingSession = DefaultMeetingSession(configuration: configuration, logger: AmazonChimeSDK.ConsoleLogger(name: "debug"))
            _audioVideoFacade = _meetingSession?.audioVideo
            let eventSink = ExampleStreamHandler.get().getEventSink()!
            _audioVideoFacade?.addActiveSpeakerObserver(policy:  DefaultActiveSpeakerPolicy(speakerWeight: 0, cutoffThreshold: 0, takeoverRate: 0), observer: ChimeActiveSpeakerObserver(eventSink: eventSink))
            _audioVideoFacade?.addAudioVideoObserver(observer: ChimeAudioVideoObserver(eventSink: eventSink))
            _audioVideoFacade?.addDeviceChangeObserver(observer: ChimeDeviceChangeObserver(eventSink: eventSink))
            _audioVideoFacade?.addMetricsObserver(observer: ChimeMetricsObserver(eventSink: eventSink))
            _audioVideoFacade?.addRealtimeObserver(observer: ChimeRealtimeObserver(eventSink: eventSink))
            _audioVideoFacade?.addVideoTileObserver(observer: ChimeVideoTileObserver(eventSink: eventSink))
            _audioVideoFacade?.addRealtimeDataMessageObserver(topic: "CHAT", observer: ChimeDataMessageObserver(eventSink: eventSink))
            result(nil)
        }
        else {
            print("Not gone through creation process")
        }
    }

    func getSDKVersion(result: @escaping FlutterResult) {
        result(Versioning.sdkVersion())
    }

    func handleAudioVideoStart(result: @escaping FlutterResult) {
        if checkAudioVideoFacade(result: result, source: "AudioVideoStart") == false {
            return
        }
        do {
            try _audioVideoFacade?.start();
            result(nil)
        } catch {
            result(FlutterError())
        }
    }

    func handleAudioVideoStop(result: @escaping FlutterResult) {
        if checkAudioVideoFacade(result: result, source: "AudioVideoStop") == false {
            return
        }
        do {
            _audioVideoFacade?.stop()
            result(nil)
        } catch {
            result(FlutterError())
        }
    }

    func handleAudioVideoStartLocalVideo(result: @escaping FlutterResult) {
        if checkAudioVideoFacade(result: result, source: "AudioVideoStartLocalVideo") == false{
            return
        }
        do {
            try _audioVideoFacade?.startLocalVideo()
            result(nil)
        } catch {
            result(FlutterError())
        }
    }

    func handleAudioVideoStopLocalVideo(result: @escaping FlutterResult) {
        if checkAudioVideoFacade(result: result, source: "AudioVideoStopLocalVideo") == false {
            return
        }
        do {
            try _audioVideoFacade?.stopLocalVideo()
            result(nil)
        } catch {
            result(FlutterError())
        }
    }

    func handleAudioVideoStartRemoteVideo(result: @escaping FlutterResult) {
        if checkAudioVideoFacade(result: result, source: "AudioVideoStartRemoteVideo") == false {
            return
        }
        do {
            try _audioVideoFacade?.startRemoteVideo()
            result(nil)
        } catch {
            result(FlutterError())
        }
    }

    func handleAudioVideoStopRemoteVideo(result: @escaping FlutterResult) {
        if checkAudioVideoFacade(result: result, source: "AudioVideoStopRemoteVideo") == false {
            return
        }
        do {
            try _audioVideoFacade?.stopRemoteVideo()
            result(nil)
        } catch {
            result(FlutterError())
        }
    }

    func handleBindVideoView(call: FlutterMethodCall, result: @escaping FlutterResult) {
        print("handleBindVideoView")
        if checkAudioVideoFacade(result: result, source: "BindVideoView") == false{
            return
        }

        let args = call.arguments as? [String: Any]

        if let myArgs = args as? [String:Any],
            let tileId = myArgs["TileId"] as? Int,
            let viewId = myArgs["ViewId"] as? Int64 {
            let videoRenderView: VideoRenderView = ChimeDefaultVideoRenderViewFactory.getViewById(id: viewId)?.view() as! VideoRenderView

            try? _audioVideoFacade?.bindVideoView(videoView: videoRenderView , tileId: tileId)
        }
        result(nil)
    }

    func handleUnbindVideoView(call: FlutterMethodCall, result: @escaping FlutterResult) {
        if checkAudioVideoFacade(result: result, source: "UnbindVideoView") == false {
            return
        }

        let args = call.arguments as? [String: Any]

        if let myArgs = args as? [String:Any],
            let tileId = myArgs["tileId"] as? Int {
            try? _audioVideoFacade?.unbindVideoView(tileId: tileId)
        }
        result(nil)
    }

    func handleChooseAudioDevice(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments else {
            result(FlutterError())
            return
        }

        if checkAudioVideoFacade(result: result, source: "ChooseAudioDevice") == false {
            return
        }

        if let myArgs = args as? [String:Any],
            let deviceName = myArgs["Label"] as? String {
            if let device = _audioOutputs.first(where: {$0.label == deviceName}) {
                _audioVideoFacade?.chooseAudioDevice(mediaDevice: device)
                result(nil)
            }
            else {
                result(FlutterError())
            }
        }
    }

    func handleListAudioDevices(result: @escaping FlutterResult) {
        if checkAudioVideoFacade(result: result, source: "ListAudioDevices") == false {
            return
        }
        do {
            let concatenatedDevices : String

            let devices: [MediaDevice] = (_audioVideoFacade?.listAudioDevices())!

            self._audioOutputs.removeAll()
            for device in devices {
                self._audioOutputs.append(device)
            }

            concatenatedDevices = "[" + devices.map({(device: MediaDevice) -> String in
            return """
                {
                "Label": "\(device.label)",
                "Type": "\(device.type)",
                "Port": "\(device.port)",
                "Description": "\(device.description)"
                }
                """
                }).joined(separator: ",") + "]"

            result(concatenatedDevices)
        } catch {
            result(FlutterError())
        }
    }

    func checkAudioVideoFacade(result: FlutterResult, source: String) -> Bool
    {
        if _meetingSession != nil {
            if _audioVideoFacade != nil {
                return true
            }
        }
        print("audioVideoFacade not available")

        return false
    }

    func handleSendDataMessage(call: FlutterMethodCall, result: @escaping FlutterResult) {
        if checkAudioVideoFacade(result: result, source: "SendDataMessage") == false{
            return
        }

        let args = call.arguments as? [String: Any]
        if let myArgs = args,
           let data = myArgs["Data"] as? Dictionary<String, Any>{

            do {
                try  _audioVideoFacade?.realtimeSendDataMessage(topic: "CHAT", data: data, lifetimeMs: 0)
                result(nil)
            } catch {
                result(FlutterError())
            }

        }
        result(nil)
    }

    func handleMute(result: @escaping FlutterResult) {
        if checkAudioVideoFacade(result: result, source: "AudioVideoMute") == false{
            return
        }

        try? _audioVideoFacade?.realtimeLocalMute()
        result(nil)
    }

    func handleUnmute(result: @escaping FlutterResult) {
        if checkAudioVideoFacade(result: result, source: "AudioVideoUnmute") == false{
            return
        }

        try? _audioVideoFacade?.realtimeLocalUnmute()
        result(nil)
    }
}

class ExampleStreamHandler: NSObject, FlutterStreamHandler {
    private static var _exampleStreamHandler : ExampleStreamHandler?

    private var _eventSink: FlutterEventSink?

    public static func get() -> ExampleStreamHandler {
        if _exampleStreamHandler != nil {
            return _exampleStreamHandler!
        }
        else {
            _exampleStreamHandler = ExampleStreamHandler()
            return _exampleStreamHandler!
        }
    }

    public func getEventSink() -> FlutterEventSink? {
        return _eventSink!
    }

    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        print("ExampleStreamHandler onListen")
        _eventSink = events
        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        _eventSink = nil
        print("ExampleStreamHandler onCancel")
        return nil
    }
}
