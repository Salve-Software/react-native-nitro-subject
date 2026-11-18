import Vision

extension VNRequest {
  /// Runs the request on the CPU in the simulator, which has no Neural Engine.
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
