//
//  SceneReconstructionViewController+Buttons.swift
//  PlaneMeasurement
//
//  Created by Adwith Mukherjee on 6/13/24.
//

import UIKit

extension SceneReconstructionViewController {

    func setupRecordButton() {
        recordButton = UIButton(type: .system)
        recordButton.translatesAutoresizingMaskIntoConstraints = false
        recordButton.setTitle("", for: .normal)
        recordButton.backgroundColor = .red
        recordButton.tintColor = .white
        recordButton.layer.cornerRadius = 25
        recordButton.setTitle("START", for: .normal)

        // Add the button to the view
        view.addSubview(recordButton)

        // Set up constraints
        NSLayoutConstraint.activate([
            recordButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -80),
            recordButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            recordButton.widthAnchor.constraint(equalToConstant: 100),
            recordButton.heightAnchor.constraint(equalToConstant: 50)
        ])

        // Add action for the button
        recordButton.addTarget(self, action: #selector(recordButtonTapped), for: .touchUpInside)
    }

    @objc func recordButtonTapped() {
        updateIsRecording(_isRecording: !isRecording)
    }

    func setupShutterButton() {
        // Create the shutter button
        let shutterButton = UIButton(type: .system)
        shutterButton.translatesAutoresizingMaskIntoConstraints = false
        shutterButton.setTitle("", for: .normal)
        shutterButton.backgroundColor = .systemBlue
        shutterButton.tintColor = .white
        shutterButton.layer.cornerRadius = 25

        // Add the button to the view
        view.addSubview(shutterButton)

        // Set up constraints
        NSLayoutConstraint.activate([
            shutterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            shutterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            shutterButton.widthAnchor.constraint(equalToConstant: 50),
            shutterButton.heightAnchor.constraint(equalToConstant: 50)
        ])

        // Add action for the button
        shutterButton.addTarget(self, action: #selector(shutterButtonTapped), for: .touchUpInside)
    }

    @objc func shutterButtonTapped() {
        session.pause()
        sceneView.scene.rootNode.isHidden = true

        guard let frame = session.currentFrame else {
            print("no session")
            return
        }
        guard let pov = sceneView.pointOfView else {
            print("no sceneView")
            return
        }
        let image = sceneView.snapshot()
        let rootNode = sceneView.scene.rootNode

        if let navigationController {
            let nextVC = DrawRulersViewController(
                viewSnapshot: image,
                pov: pov,
                frame: frame,
                root: rootNode
            )
            navigationController.pushViewController(nextVC, animated: false)
        }
    }

}
