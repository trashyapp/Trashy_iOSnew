import UIKit
import AVFoundation

/// Wrapper around `AVCaptureTorchMode`.
public enum TorchMode {
  case on
  case off

  /// Returns the next torch mode.
  var next: TorchMode {
    switch self {
    case .on:
      return .off
    case .off:
      return .on
    }
  }

  /// Torch mode image.
  var image: UIImage {
    switch self {
    case .on:
        return /*imageNamed("LightSymbolOn")*/ (UIImage.init(named: "LightSymbolOn") as UIImage?)!
    case .off:
      return /*imageNamed("LightSymbol")*/ (UIImage.init(named: "LightSymbol") as UIImage?)!
    }
  }

  /// Returns `AVCaptureTorchMode` value.
  var captureTorchMode: AVCaptureDevice.TorchMode {
    switch self {
    case .on:
      return .on
    case .off:
      return .off
    }
  }
}
