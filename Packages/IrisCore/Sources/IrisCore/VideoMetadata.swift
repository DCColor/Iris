import Foundation
import CoreMedia

/// Technical metadata about a loaded clip, for the inspector panel.
public struct VideoMetadata: Equatable, Sendable {
    public var codecName: String = "—"
    public var width: Int = 0
    public var height: Int = 0
    public var frameRate: Double = 0
    public var container: String = "—"

    // Friendly names...
    public var colorPrimaries: String = "—"
    public var transferFunction: String = "—"
    public var colorMatrix: String = "—"

    // ...and their numeric nclc/CICP codes (nil if unknown).
    public var colorPrimariesCode: Int?
    public var transferFunctionCode: Int?
    public var colorMatrixCode: Int?

    public var resolutionString: String {
        (width > 0 && height > 0) ? "\(width) × \(height)" : "—"
    }

    public var frameRateString: String {
        frameRate > 0 ? String(format: "%.3f fps", frameRate) : "—"
    }

    /// Compact nclc triple, e.g. "1-1-1" or "9-16-9". Dashes for unknown fields.
    public var nclcTriple: String {
        func s(_ c: Int?) -> String { c.map(String.init) ?? "—" }
        return "\(s(colorPrimariesCode))-\(s(transferFunctionCode))-\(s(colorMatrixCode))"
    }

    /// A field's friendly name with its code appended, e.g. "Rec. 709 (1)".
    public func labeled(_ name: String, _ code: Int?) -> String {
        guard let code else { return name }
        return "\(name) (\(code))"
    }
}
