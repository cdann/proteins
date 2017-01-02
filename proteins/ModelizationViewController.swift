//
//  ModelizationViewController.swift
//  proteins
//
//  Created by Celine DANNAPPE on 10/25/16.
//  Copyright (c) 2016 Celine DANNAPPE. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class ModelizationViewController: UIViewController {
    
    var scnView: SCNView!
    var scnScene: SCNScene!
    var cameraNode: SCNNode!
    var textNode:SCNNode?

    
    @IBAction func buttonShare(_ sender: UIBarButtonItem) {
        let bounds = UIScreen.main.bounds
        UIGraphicsBeginImageContextWithOptions(bounds.size, true, 0.0)
        self.view.drawHierarchy(in: bounds, afterScreenUpdates: false)
        if let img = UIGraphicsGetImageFromCurrentImageContext()
        {
            let activityVC = UIActivityViewController(activityItems: [img], applicationActivities: [UIActivity.init()])
            UIGraphicsEndImageContext()
            activityVC.excludedActivityTypes = [ UIActivityType.addToReadingList]
            self.present(activityVC, animated: true, completion: nil)
        }
        
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        setupView()
        setupScene()
        for (_, at) in AtomData.all {
            at.displayAtom(scnScene)
        }
        setupCamera()
        for (_,co) in ConectData.all {
            co.displayConect(scnScene)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        AtomData.all.removeAll()
        ConectData.all.removeAll()
        scnScene.rootNode.enumerateChildNodes{ (node, stop) -> Void in
            node.removeFromParentNode()
        }
        super.viewWillDisappear(animated)
    }
    
    //MARK: setup fct
    
    func setupView() {
        scnView = self.view as! SCNView
        scnView.showsStatistics = false
        scnView.allowsCameraControl = true
        scnView.autoenablesDefaultLighting = true
    }
    
    func setupScene() {
        scnScene = SCNScene()
        scnView.scene = scnScene
    }
    
    func setupCamera() {
        let xmid = (AtomData.xminmax!.1 - AtomData.xminmax!.0)/2 + AtomData.xminmax!.0
        let ymid = (AtomData.yminmax!.1 - AtomData.yminmax!.0)/2 + AtomData.yminmax!.0
        let zmid = (AtomData.zminmax!.1 - AtomData.zminmax!.0)/2 + AtomData.zminmax!.0
        cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: xmid, y: ymid, z: zmid + 50)
        scnScene.rootNode.addChildNode(cameraNode)
    }
    
    
    func handleTouch(node:SCNNode) {
        if let elm = node.name  {
            if textNode != nil {
                textNode!.removeFromParentNode()
                textNode = nil
            }
            let newText = SCNText(string: elm, extrusionDepth:0.03)
            newText.font = UIFont (name: "Arial", size: 0.7)
            newText.firstMaterial!.diffuse.contents = node.geometry!.materials.first?.diffuse.contents
   
            textNode = SCNNode(geometry: newText)
            let contraint = SCNBillboardConstraint()
            textNode!.constraints = [contraint]
            textNode!.position = SCNVector3(x:node.position.x - 0.15, y:node.position.y - 0.15, z: node.position.z - 0.15)
            
            scnScene.rootNode.addChildNode(textNode!)
            
        }
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       //On prend le premier touch
        let touch = touches.first!
        //On localise le touch par rapport aux coordonnées de la sceneView
        let location = touch.location(in: scnView)
        //On test un rayon qui part de l'endroit touché par le user ça nous renvoie un SCNHitTestResult
        let hitResults = scnView.hitTest(location, options: nil)
        //Si il y a bien un node de touché on l'envoie a handleTouch
        if hitResults.count > 0 {
            let result = hitResults.first!
            handleTouch(node: result.node)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
}
