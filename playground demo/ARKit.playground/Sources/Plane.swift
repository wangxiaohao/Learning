

import Foundation
import ARKit

class Plane : SCNNode {
    var anchor : ARPlaneAnchor?
    var planeGeometry : SCNPlane?
    
    init(anchor: ARPlaneAnchor) {
        super.init()
        self.anchor = anchor
        self.planeGeometry = SCNPlane.init(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))
        
        // Instead of just visualizing the grid as a gray plane, we will render
        // it in some Tron style colours.
        let material = SCNMaterial()
        material.diffuse.contents = UIImage.init(named: "./WorldResources.scnassets/tron.png")
        self.planeGeometry?.materials = [material]
        
        let planeNode = SCNNode.init(geometry: planeGeometry)
        planeNode.position = SCNVector3Make(anchor.center.x, 0, anchor.center.z)
        planeNode.transform = SCNMatrix4MakeRotation(Float(-.pi/2.0), 1.0, 0.0, 0.0)
        
        setTextureScale()
        self.addChildNode(planeNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func update(anchor: ARPlaneAnchor) {
        // As the user moves around the extend and location of the plane
        // may be updated. We need to update our 3D geometry to match the
        // new parameters of the plane.
        planeGeometry?.width = CGFloat(anchor.extent.x)
        planeGeometry?.height = CGFloat(anchor.extent.z)
    
        // When the plane is first created it's center is 0,0,0 and the nodes
        // transform contains the translation parameters. As the plane is updated
        // the planes translation remains the same but it's center is updated so
        // we need to update the 3D geometry position
        position = SCNVector3Make(anchor.center.x, 0, anchor.center.z)
    
        let node = self.childNodes.first
        node?.physicsBody = SCNPhysicsBody.init(type: SCNPhysicsBodyType.kinematic, shape: SCNPhysicsShape.init(geometry: planeGeometry!, options: nil))
        setTextureScale()
    }
    
    func setTextureScale() {
        let width = self.planeGeometry?.width
        let height = self.planeGeometry?.height
        
        // As the width/height of the plane updates, we want our tron grid material to
        // cover the entire plane, repeating the texture over and over. Also if the
        // grid is less than 1 unit, we don't want to squash the texture to fit, so
        // scaling updates the texture co-ordinates to crop the texture in that case
        let material = self.planeGeometry?.materials.first
        material?.diffuse.contentsTransform = SCNMatrix4MakeScale(Float(width!), Float(height!), 1)
        material?.diffuse.wrapS = SCNWrapMode.repeat
        material?.diffuse.wrapT = SCNWrapMode.repeat
    }
}
