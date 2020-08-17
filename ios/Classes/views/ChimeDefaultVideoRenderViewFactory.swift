import UIKit
import Flutter

public class ChimeDefaultVideoRenderViewFactory : NSObject, FlutterPlatformViewFactory {
    
    public static var _viewIdToViewMap = [Int64: ChimeDefaultVideoRenderView]()
    
    public func create (
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        let view = ChimeDefaultVideoRenderView(frame, viewId: viewId, args: args)
        ChimeDefaultVideoRenderViewFactory._viewIdToViewMap[viewId] = view
        return view
    }

    public static func getViewById(id: Int64) -> ChimeDefaultVideoRenderView? {
        return self._viewIdToViewMap[id]!
    }
    
    
}
