import SwiftUI
import IrisCore

struct ContentView: View {
    @StateObject private var engine = AVPlayerEngine()
    @State private var isImporterPresented = false

    @State private var isScrubbing = false
    @State private var scrubValue: Double = 0

    var body: some View {
        VStack(spacing: 0) {
            VideoSurfaceView(player: engine.player)
                .background(.black)

            VStack(spacing: 8) {
                HStack(spacing: 12) {
                    Text(timeString(isScrubbing ? scrubValue : engine.currentTime))
                        .font(.system(.caption, design: .monospaced))
                        .foregroundStyle(.secondary)

                    Slider(
                        value: Binding(
                            get: { isScrubbing ? scrubValue : engine.currentTime },
                            set: { newValue in
                                scrubValue = newValue
                                // Seek live as the user drags, using the cheap tolerant seek.
                                engine.scrubSeek(to: newValue)
                            }
                        ),
                        in: 0...max(engine.duration, 0.1),
                        onEditingChanged: { editing in
                            if editing {
                                scrubValue = engine.currentTime
                                isScrubbing = true
                            } else {
                                // Land precisely on release with one exact seek.
                                engine.exactSeek(to: scrubValue)
                                isScrubbing = false
                            }
                        }
                    )

                    Text(timeString(engine.duration))
                        .font(.system(.caption, design: .monospaced))
                        .foregroundStyle(.secondary)
                }

                HStack(spacing: 16) {
                    Button {
                        isImporterPresented = true
                    } label: {
                        Label("Open…", systemImage: "folder")
                    }

                    Button {
                        engine.togglePlayPause()
                    } label: {
                        Image(systemName: engine.isPlaying ? "pause.fill" : "play.fill")
                            .frame(width: 24)
                    }
                    .keyboardShortcut(.space, modifiers: [])

                    Spacer()
                }
            }
            .padding(12)
        }
        .fileImporter(
            isPresented: $isImporterPresented,
            allowedContentTypes: [.movie, .video, .quickTimeMovie, .mpeg4Movie],
            allowsMultipleSelection: false
        ) { result in
            if case .success(let urls) = result, let url = urls.first {
                engine.load(url: url)   // load paused on the first frame — no autoplay
            }
        }
    }

    private func timeString(_ seconds: Double) -> String {
        guard seconds.isFinite, seconds >= 0 else { return "0:00" }
        let total = Int(seconds)
        let h = total / 3600, m = (total % 3600) / 60, s = total % 60
        return h > 0 ? String(format: "%d:%02d:%02d", h, m, s)
                     : String(format: "%d:%02d", m, s)
    }
}
