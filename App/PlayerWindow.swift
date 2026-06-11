import SwiftUI
import AppKit

/// Full-bleed NSWindow locked to the clip's aspect for BOTH modes (overlay and
/// docked are now both overlays over the video, so the window is always just the
/// video — it scales as one piece). Traffic-light buttons fade with the controls.
struct WindowConfigurator: NSViewRepresentable {
    var buttonsVisible: Bool
    var displaySize: CGSize?

    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        let hasClip = (displaySize != nil)
        DispatchQueue.main.async {
            guard let window = view.window else { return }
            window.isMovableByWindowBackground = true
            window.backgroundColor = .black
            if !hasClip {
                window.contentAspectRatio = .zero
                let defaultSize: NSSize
                if let screen = window.screen ?? NSScreen.main {
                    let w = min(screen.visibleFrame.width * 0.6, 1280)
                    defaultSize = NSSize(width: w, height: (w * 9.0 / 16.0).rounded())
                } else {
                    defaultSize = NSSize(width: 960, height: 540)
                }
                window.setContentSize(defaultSize)
                window.center()
            }
        }
        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {
        guard let window = nsView.window else { return }

        let buttons: [NSButton?] = [
            window.standardWindowButton(.closeButton),
            window.standardWindowButton(.miniaturizeButton),
            window.standardWindowButton(.zoomButton)
        ]
        let target: CGFloat = buttonsVisible ? 1 : 0
        NSAnimationContext.runAnimationGroup { ctx in
            ctx.duration = 0.30
            for button in buttons { button?.animator().alphaValue = target }
        }

        guard let size = displaySize, size.width > 0, size.height > 0 else { return }
        let aspect = NSSize(width: size.width, height: size.height)
        if window.contentAspectRatio != aspect {
            window.contentAspectRatio = aspect
            if let screen = window.screen ?? NSScreen.main {
                let maxW = screen.visibleFrame.width * 0.8
                let maxH = screen.visibleFrame.height * 0.8
                let scale = min(maxW / size.width, maxH / size.height, 1.0)
                let contentSize = NSSize(width: size.width * scale, height: size.height * scale)
                window.setContentSize(contentSize)
                window.center()
            }
        }
    }
}
