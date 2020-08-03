import UIKit
import Flutter
import AmazonChimeSDK

public class ChimeDefaultVideoRenderView : NSObject, FlutterPlatformView {
    private let _defaultVideoRenderView: DefaultVideoRenderView = DefaultVideoRenderView()
    
    let frame: CGRect
    let viewId: Int64
    
    init(_ frame: CGRect, viewId: Int64, args: Any?) {
        self.frame = frame
        self.viewId = viewId
    }
    
    public func view() -> UIView {
        return _defaultVideoRenderView//(frame: frame)
    }
}
