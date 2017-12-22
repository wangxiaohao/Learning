

import UIKit
import SceneKit
import ARKit

public class ViewController: UIViewController, ARSCNViewDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    var planes : NSMutableDictionary = [:]
    
    let planeSize: Float = 1
    let planeSizeCGFloat: CGFloat = 1
    let planeCenter = SCNVector3(x: 0, y: -1.5, z: -2)
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScene()
        setupRecognizers()
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let _ = SCNScene(named: "Meebot.scn", inDirectory: "WorldResources.scnassets/_Scenes")
    }
    
    func loadNode(file: String, loc:SCNVector3, scale: SCNVector3) -> SCNNode {
        let loadingObjNode = SCNNode()
        let loadingScene = SCNScene(named: file)!
        let nodeArray = loadingScene.rootNode.childNodes
        
        loadingObjNode.position = loc
        loadingObjNode.scale = scale
        
        for childNode in nodeArray {
            loadingObjNode.addChildNode(childNode as SCNNode)
        }
        
        return loadingObjNode
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.isLightEstimationEnabled = true
        configuration.planeDetection = .horizontal
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Prevent the screen from being dimmed after a while.
//        UIApplication.shared.isIdleTimerDisabled = true
        
        // Start the ARSession.
        // restartPlaneDetection()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    // MARK: - ARKit / ARSCNView
    let session = ARSession()
    var sessionConfig: ARWorldTrackingConfiguration = ARWorldTrackingConfiguration()
    var screenCenter: CGPoint?
    
    func setupScene() {
        // set up sceneView
        sceneView.delegate = self
        sceneView.session = session
        sceneView.antialiasingMode = .none
        sceneView.automaticallyUpdatesLighting = true
        sceneView.debugOptions = ARSCNDebugOptions.showFeaturePoints
        
        sceneView.preferredFramesPerSecond = 60
        sceneView.contentScaleFactor = 1.3
        sceneView.showsStatistics = true
        
        let scene = SCNScene()
        self.sceneView.scene = scene
    }
    
    func setupRecognizers() {
        // Single tap will insert a new piece of geometry into the scene
        let tapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(ViewController.handleTapFrom(recognizer:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
        
        /*  let hidePlanesGestureRecognizer = UILongPressGestureRecognizer.init(target: self, action: #selector(ViewController.handleHidePlaneFrom(recognizer:)))
         hidePlanesGestureRecognizer.minimumPressDuration = 1
         hidePlanesGestureRecognizer.numberOfTouchesRequired = 2
         sceneView.addGestureRecognizer(hidePlanesGestureRecognizer)
         */
    }
    

    @objc func handleTapFrom(recognizer: UITapGestureRecognizer) {
        // Take the screen space tap coordinates and pass them to the hitTest method on the ARSCNView instance
        let tapPoint = recognizer.location(in: sceneView)
        let result = sceneView.hitTest(tapPoint, types: ARHitTestResult.ResultType.existingPlaneUsingExtent)
        
        // If the intersection ray passes through any plane geometry they will be returned, with the planes
        // ordered by distance from the camera
        if (result.count == 0) {
            return;
        }
        
        // If there are multiple hits, just pick the closest plane
        if let hitResult = result.first {
            insertGeometry(hitResult: hitResult)
        }
    }
    
    func insertGeometry(hitResult: ARHitTestResult) {
        let node = createNode()
        node.position = SCNVector3Make(
            hitResult.worldTransform.columns.3.x,
            hitResult.worldTransform.columns.3.y,
            hitResult.worldTransform.columns.3.z
        )
        
        node.rotation = SCNVector4Make(hitResult.worldTransform.columns.2.w, hitResult.worldTransform.columns.2.x, hitResult.worldTransform.columns.2.y, hitResult.worldTransform.columns.2.z)
        sceneView.scene.rootNode.addChildNode(node)
    }
    
    // MARK: - ARSCNViewDelegate
    public func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if let planeAnchor = anchor as? ARPlaneAnchor {
            let planeNode = Plane.init(anchor: planeAnchor)
            self.planes.setObject(planeNode, forKey: planeAnchor.identifier as NSCopying)
            node.addChildNode(planeNode)
        }
    }
    
    public func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        if let planeAnchor = anchor as? ARPlaneAnchor {
            // See if this is a plane we are currently rendering
            if let plane = self.planes.object(forKey: anchor.identifier) as? Plane {
                plane.update(anchor: planeAnchor)
            }
        }
    }
    
    public func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        self.planes.removeObject(forKey: anchor.identifier)
    }
    
    func createNode() -> SCNNode {
        // Create a SceneKit plane to visualize the node using its position and extent.
        // Create the geometry and its materials
        let planeNode = loadNode(file: "WorldResources.scnassets/_Scenes/Meebot.scn", loc: SCNVector3(x: 0, y:0, z:0), scale: SCNVector3(x: 0.0007, y:0.0007, z:0.0007))
        return planeNode
    }
}

