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
    
    var xminmax:(Float, Float)? = nil
    var yminmax:(Float, Float)? = nil
    var zminmax:(Float, Float)? = nil
    
    var atoms = [Int : AtomData]()
    var conects = [Int: ConectData]()

    
    override func viewDidLoad(){
        super.viewDidLoad()
       // var atoms = [Int : AtomData]()
       // var conects = [Int: ConectData]()
    
        setupView()
        setupScene()
        /*let text = "mon text"
        let newText = SCNText(string: text, extrusionDepth:0.1)
        newText.font = UIFont (name: "Arial", size: 3)
        newText.firstMaterial!.diffuse.contents = UIColor.white
        newText.firstMaterial!.specular.contents = UIColor.white*/
        
        for (_, at) in atoms {
            displayAtom(at)
            getMinMax(at)
        }
        
        setupCamera()
        /*let textNode = SCNNode(geometry: newText)
        //textNode.constraints = SCNLookAtConstraint
        textNode.position = SCNVector3(x:xminmax!.0, y:yminmax!.1, z: zminmax!.1+10)
        scnScene.rootNode.addChildNode(textNode)*/
        for (_,co) in conects {
            displayConect(co)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        scnScene.rootNode.enumerateChildNodes(){ (node, stop) -> Void in
            node.removeFromParentNode()
        }
        atoms.removeAll()
        conects.removeAll()
        super.viewDidDisappear(animated)
    }

    override var shouldAutorotate : Bool {
        return true
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    //MARK: setup fct
    
    func setupView() {
        scnView = self.view as! SCNView
        scnView.showsStatistics = true
        scnView.allowsCameraControl = true
        scnView.autoenablesDefaultLighting = true
    }
    
    func setupScene() {
        scnScene = SCNScene()
        scnView.scene = scnScene
    }
    
    func setupCamera() {
        let xmid = (xminmax!.1 - xminmax!.0)/2 + xminmax!.0
        let ymid = (yminmax!.1 - yminmax!.0)/2 + yminmax!.0
        let zmid = (zminmax!.1 - zminmax!.0)/2 + zminmax!.0
        cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: xmid, y: ymid, z: zmid + 50)
        scnScene.rootNode.addChildNode(cameraNode)
    }
    
    func displayAtom(_ atom:AtomData) {
        var geometry:SCNGeometry
        geometry = SCNSphere(radius: 0.4)
        geometry.materials.first?.diffuse.contents = atom.color
        atom.node = SCNNode(geometry: geometry)
        atom.node!.position = atom.pos
        scnScene.rootNode.addChildNode(atom.node!)
    }
    
    func getMinMax(_ atom:AtomData) {
        let px = atom.pos.x
        let py = atom.pos.y
        let pz = atom.pos.z
        
        if xminmax == nil && yminmax == nil && zminmax == nil {
            xminmax = (px, px)
            yminmax = (py, py)
            zminmax = (pz, pz)
        }
        else{
            if px < xminmax!.0{
                xminmax!.0 = px
            }
            else if px > xminmax!.1{
                xminmax!.1 = px
            }
            if py < yminmax!.0{
                yminmax!.0 = py
            }
            else if py > yminmax!.1{
                yminmax!.1 = py
            }
            if pz < zminmax!.0{
                zminmax!.0 = pz
            }
            else if pz > zminmax!.1{
                zminmax!.1 = pz
            }
            
        }
    }
    

    func displayConect(_ conect:ConectData) {
        let src = atoms[conect.mainAtomKey]!.pos
        let color = atoms[conect.mainAtomKey]!.color
        let radius:CGFloat = 0.2
        for conection in conect.conections {
            if atoms[conection]!.checkConnect == false {
                let dest = atoms[conection]!.pos
                let diff = SCNVector3(x: src.x-dest.x, y: src.y-dest.y, z: src.z-dest.z)
                let height = diff.lenght()
                let geometry = SCNCylinder(radius: radius, height: CGFloat(height))
                geometry.materials.first?.diffuse.contents = color
                let node = SCNNode(geometry: geometry)
                node.position = SCNVector3((dest.x + src.x)/2, (dest.y + src.y)/2 , (dest.z + src.z)/2)
                node.eulerAngles = getEuler(diff: diff, height: Double(height))
                scnScene.rootNode.addChildNode(node)
            }

        }
        atoms[conect.mainAtomKey]!.checkConnect = true
    }
    
    func getEuler(diff:SCNVector3, height:Double) -> SCNVector3 {
        let xzdiff = pow((pow(Double(diff.x), 2) + pow(Double(diff.z),2)),0.5)
        var pitch: Double
        if diff.y < 0 {
            pitch = M_PI - asin(Double(xzdiff)/height)
        } else {
            pitch = asin(Double(xzdiff)/height)
        }
        if diff.z != 0 {
            pitch = sign(Double(diff.z)) * pitch
        }
        var yaw: Double
        if diff.x == 0 && diff.z == 0 {
            yaw = 0
        } else {
            let inner = Double(diff.x) / (height * sin (pitch))
            if inner > 1 {
                yaw = M_PI_2
            } else if inner < -1 {
                yaw = M_PI_2
            } else {
                yaw = asin(inner)
            }
        }
        return SCNVector3(CGFloat(pitch), CGFloat(yaw), 0)
    }

    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

}
