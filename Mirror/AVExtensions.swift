//
//  AVCaptureVideoPreviewLayer.swift
//  Mirror
//
//  Created by manuel on 28/08/19.
//  Copyright © 2019 Breakneck Labs. All rights reserved.
//

import UIKit
import AVFoundation

extension AVCaptureVideoPreviewLayer {
    convenience init?(camera: AVCaptureDevice.Position) throws {
        let deviceDiscoverySession = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: camera)
        guard let captureDevice = deviceDiscoverySession else { return nil }
        let input = try AVCaptureDeviceInput(device: captureDevice)
        let session = AVCaptureSession()
        session.addInput(input)
        self.init(session: session)
        self.videoGravity = AVLayerVideoGravity.resizeAspectFill
    }

    private func fixVideoOrientation() {
        if let connection =  connection  {
            let currentDevice: UIDevice = UIDevice.current
            let orientation: UIDeviceOrientation = currentDevice.orientation
            let previewLayerConnection : AVCaptureConnection = connection
            if previewLayerConnection.isVideoOrientationSupported {
                switch (orientation) {
                case .portrait: connection.videoOrientation = .portrait
                case .landscapeRight: connection.videoOrientation = .landscapeLeft
                case .landscapeLeft: connection.videoOrientation = .landscapeRight
                case .portraitUpsideDown: connection.videoOrientation = .portraitUpsideDown
                default: connection.videoOrientation = .portrait
                }
            }
        }
    }

    func attachPreview(to view: UIView) {
        self.frame = view.layer.bounds
        self.fixVideoOrientation()
        view.layer.addSublayer(self)
    }

    open override func layoutSublayers() {
        super.layoutSublayers()
        self.fixVideoOrientation()
    }
}

extension AVCaptureDevice.Position {
    var stringValue: String {
        return self == .front ? "front" : "back"
    }
}
