import SwiftUI
import AVFoundation

/// Bridges an AppKit video layer into SwiftUI.
///
/// SwiftUI has no native video view, so we host an `AVPlayerLayer`
/// (AppKit) and expose it to SwiftUI through `NSViewRepresentable`.
struct VideoSurfaceView: NSViewRepresentable {
    let player: AVPlayer

    // Called once to build the AppKit view.
    func makeNSView(context: Context) -> PlayerNSView {
        let view = PlayerNSView()
        view.playerLayer.player = player
        view.playerLayer.videoGravity = .resizeAspect
        return view
    }

    // Called when SwiftUI state changes; keep the player reference current.
    func updateNSView(_ nsView: PlayerNSView, context: Context) {
        nsView.playerLayer.player = player
    }
}

/// An NSView whose *backing layer* is an AVPlayerLayer.
/// "Layer-backed" means the view draws via Core Animation, which is
/// what lets us use a specialized layer type as the view's surface.
final class PlayerNSView: NSView {
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        wantsLayer = true
        layer = AVPlayerLayer()
        layer?.backgroundColor = NSColor.black.cgColor
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var playerLayer: AVPlayerLayer { layer as! AVPlayerLayer }
}
