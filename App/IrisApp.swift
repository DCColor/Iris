import SwiftUI
import IrisCore

@main
struct IrisApp: App {
    // A shared engine the App owns, so a file opened at launch reaches the same
    // engine the ContentView displays.
    @StateObject private var engine = AVPlayerEngine()

    var body: some Scene {
        WindowGroup {
            ContentView(engine: engine)
                .frame(minWidth: 720, minHeight: 460)
                // Fires when macOS opens a file with Iris: double-click in Finder,
                // drag onto the dock icon, or "Open With". Works at cold launch
                // and while already running.
                .onOpenURL { url in
                    engine.load(url: url)
                }
        }
        .windowStyle(.hiddenTitleBar)
    }
}
