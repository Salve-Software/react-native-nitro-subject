import Vision

extension VNRequest {
  /// The iOS Simulator has no Neural Engine and Vision's default devices fail
  /// there with "Failed to create espresso context". Pinning every stage to
  /// the CPU lets the requests that can run on it do so. No-op elsewhere.
  func preferCPUOnSimulator() {
    #if targetEnvironment(simulator)
    if #available(iOS 17.0, *) {
      guard let stages = try? supportedComputeStageDevices else { return }
      for (stage, devices) in stages {
        let cpu = devices.first { device in
          if case .cpu = device { return true }
          return false
        }
        if let cpu { try? setComputeDevice(cpu, for: stage) }
      }
    } else {
      usesCPUOnly = true
    }
    #endif
  }
}
