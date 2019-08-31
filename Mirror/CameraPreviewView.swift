//
//  CameraPreviewView.swift
//  Mirror
//
//  Created by manuel on 28/08/19.
//  Copyright © 2019 Breakneck Labs. All rights reserved.
//

import UIKit
import AVFoundation

protocol CameraPreviewDelegate: class {
    func cameraPreviewDelegate(_ cameraPreview: CameraPreview, didSwitchCamera newCamera: AVCaptureDevice.Position)
    func cameraPreviewDelegate(_ cameraPreview: CameraPreview, didEncounterError error: Error)
}

final class CameraPreview: UIView {

    // MARK: - Properties

    private lazy var doubleTapGestureRecognizer: UITapGestureRecognizer = {
        let doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(switchCamera))
        doubleTapGestureRecognizer.numberOfTapsRequired = 2
        return doubleTapGestureRecognizer
    }()

    private var currentCamera: AVCaptureDevice.Position = .front {
        didSet {
            delegate?.cameraPreviewDelegate(self, didSwitchCamera: currentCamera)
        }
    }

    private var videoPreviewLayer: AVCaptureVideoPreviewLayer?

    weak var delegate: CameraPreviewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        addGestureRecognizer(doubleTapGestureRecognizer)
        startPreview(camera: currentCamera)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        videoPreviewLayer?.frame = self.layer.bounds
    }

    // MARK: - Functions

    /// Called at double tap on view
    @objc private func switchCamera() {
        currentCamera = currentCamera == .front ? .back : .front
        startPreview(camera: currentCamera)
        delayTouches()
    }

    private func startPreview(camera: AVCaptureDevice.Position) {
        do {
            videoPreviewLayer = try AVCaptureVideoPreviewLayer(camera: camera)
            videoPreviewLayer?.attachPreview(to: self)
            videoPreviewLayer?.session?.startRunning()
        } catch {
            delegate?.cameraPreviewDelegate(self, didEncounterError: error)
        }
    }

    private func delayTouches() {
        self.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { [unowned self] in
            self.isUserInteractionEnabled = true
        }
    }
}
