//
//  ViewController.swift
//  Mirror
//
//  Created by manuel on 28/08/19.
//  Copyright © 2019 Breakneck Labs. All rights reserved.
//

import UIKit
import AVFoundation

final class ViewController: UIViewController {

    // MARK: - UIViews

    private lazy var cameraView: CameraPreview = {
        let cameraView = CameraPreview(frame: view.bounds)
        cameraView.delegate = self
        return cameraView
    }()

    // MARK: - Lifecycle

    override func loadView() {
        super.loadView()
        view = cameraView
    }
}

extension ViewController: CameraPreviewDelegate {
    func cameraPreviewDelegate(_ cameraPreview: CameraPreview, didSwitchCamera newCamera: AVCaptureDevice.Position) {
        print("Switched camera to: \(newCamera.stringValue)")
    }

    func cameraPreviewDelegate(_ cameraPreview: CameraPreview, didEncounterError error: Error) {
        let alert = UIAlertController(title: nil, message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
}
