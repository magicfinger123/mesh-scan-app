//
//  DrawRulersViewController.swift
//  PlaneMeasurement
//
//  Created by Adwith Mukherjee on 6/11/24.
//

import UIKit
import SceneKit
import SpriteKit
import MagnifyingGlass
import ARKit

class DrawRulersViewController: UIViewController {


    // MARK: - View Elements
    var scene: SCNScene!
    var sceneView: SCNView!
    var imageView: UIView!
    var tableViewController: TableViewController!

    // MARK: - state from SceneReconstructionVC
    var pointOfView: SCNNode?
    var image: UIImage
    var frame: ARFrame
    var oldRootNode: SCNNode

    // MARK: - keeping track of vertices / edges
    var quadNode: QuadNode!
    var skScene: SKScene {
        sceneView.overlaySKScene!
    }
    var panningState: PanningState = .first
    var dummyNode = SCNNode()


    let magnifyingGlass = MagnifyingGlassView(offset: CGPoint(x: 0, y: -75.0), radius: 50.0, scale: 1, crosshairColor: .white, crosshairWidth: 0.8)


    
    init(viewSnapshot: UIImage, pov: SCNNode, frame: ARFrame, root: SCNNode) {
        self.image = viewSnapshot
        self.pointOfView = pov
        self.frame = frame
        self.oldRootNode = root
        super.init(nibName: nil, bundle: nil)
        setupScene()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        enablePanGesture()
        imageView = UIImageView(image: image)
        imageView.frame = view.frame
        view.addSubview(imageView)
        setupNavigationItem()
        setupSceneView()
        setupQuadNode()
        setupSKScene()

    }
    // MARK: - Setup
    func setupScene() {
        scene = SCNScene()
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.simdTransform = frame.camera.transform
        scene.rootNode.addChildNode(cameraNode)
        for child in oldRootNode.childNodes {
            scene.rootNode.addChildNode(child)
            child.geometry?.firstMaterial?.colorBufferWriteMask = []
        }
    }

    private func setupNavigationItem() {
        navigationItem.title = "Create measurement"
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = .white.withAlphaComponent(0.5) // Customize the back button color
        navigationItem.leftBarButtonItem = backButton
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.backgroundColor = .black
            navigationBar.barTintColor = .systemBlue // Background color
            navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white] // Title color
        }
    }
    @objc private func backButtonTapped() {
        // Handle back button tap
        navigationController?.popViewController(animated: true)
    }
    func setupSceneView() {
        sceneView = SCNView()
        sceneView.frame = view.frame
        sceneView.backgroundColor = .clear
        sceneView.scene = scene
        sceneView.pointOfView = pointOfView
        sceneView.autoenablesDefaultLighting = false
        view.addSubview(sceneView)
      
        // Add the UILabel to the view hierarchy
        view.addSubview(descriptionLabel)
        // Set up constraints for the UILabel
         NSLayoutConstraint.activate([
             descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
             descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
             descriptionLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
             descriptionLabel.heightAnchor.constraint(equalToConstant: 100)
         ])
      }
      
    func setupQuadNode() {
        self.quadNode = QuadNode(sceneView: sceneView)
        scene.rootNode.addChildNode(quadNode)
        scene.rootNode.addChildNode(dummyNode)
    }

    func setupSKScene() {
        sceneView.overlaySKScene = SKScene(size: sceneView.bounds.size)
        skScene.delegate = self
        skScene.anchorPoint = CGPoint(x: 0, y: 0)
        skScene.isUserInteractionEnabled = true
    }

    func setupTableView() {
        // Initialize the child view controller
        tableViewController = TableViewController()

        // Add as a child view controller
        addChild(tableViewController)
        view.addSubview(tableViewController.view)
        tableViewController.didMove(toParent: self)

        // Set the frame or constraints
        tableViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            tableViewController.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            tableViewController.view.widthAnchor.constraint(equalToConstant: 200),
            tableViewController.view.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        label.textColor = .white
        label.numberOfLines = 3
        label.text = "Click any where on the screen to reveal a measurement interface with a blue rectangle and magnifying glass"
        return label
    }()
    
}
