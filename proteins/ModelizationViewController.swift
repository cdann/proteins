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
    
        setupView()
        setupScene()
        let text = "mon text"
        let newText = SCNText(string: text, extrusionDepth:0.1)
        newText.font = UIFont (name: "Arial", size: 3)
        newText.firstMaterial!.diffuse.contents = UIColor.white
        newText.firstMaterial!.specular.contents = UIColor.white
        
        for (_, at) in atoms {
            displayAtom(at)
            getMinMax(at)
        }
        
        setupCamera()
        let textNode = SCNNode(geometry: newText)
        //textNode.constraints = SCNLookAtConstraint
        textNode.position = SCNVector3(x:xminmax!.0, y:yminmax!.1, z: zminmax!.1+10)
        scnScene.rootNode.addChildNode(textNode)
        for (_,co) in conects {
            displayConect(co)
            return //a enlever
        }
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
        let pointa = atoms[conect.mainAtomKey]!.pos
        //print(atoms)
//        print("______")
        for conection in conect.conections {
            let pointb = atoms[conection]!.pos
            let norma = pointa.normalize()
            let normb = pointb.normalize()
            // les deux vecteurs normalisés
            let height = CGFloat(SCNVector3.distance(pointa, right: pointb))
            
            // solution1
 /*          var angle = SCNVector3.dotProduct(norma, right: normb)
            print(" dot product \(pointa) \(pointb) == \(angle)")
            angle = (Float(M_PI) *  angle)/180
            angle = acosf(angle)*/
            
            //solution 2
            let dot = SCNVector3.dotProduct(pointa, right: pointb)
            let mul = pointa.getNorm() * pointb.getNorm()
            let angle = acosf(dot/mul)
            
            let axis = SCNVector3.crossProduct(norma, right: normb)
            /*var angle = SCNVector3.dotProduct(pointa, right: pointb)
            angle = angle/pointa.getNorm() * pointb.getNorm()
            angle = acosf(angle)
            angle = (Float(M_PI) *  angle)/180*/
            /*let axis = SCNVector3.crossProduct(norma, right: normb).normalize()
            var angle = SCNVector3.dotProduct(pointa, right: pointb)
            angle = sqrt(SCNVector3) + angle
            angle = (Float(M_PI) *  angle)/180*/
            //let angle = SCNVector3.dotProduct(pointa, right: pointb)/SCNVector3.dotProduct(pointa.normalize(), right: pointb.normalize())
            //print(acosf(angle))
            //angle = (Float(M_PI) *  acos(angle))/180
            
            //let axis = SCNVector3.crossProduct(norma, right: normb).normalize()
            //print("axis " + String(describing: axis) + " angle " + String(angle))
            let geometry = SCNCylinder(radius: 0.2, height: height)
            geometry.materials.first?.diffuse.contents = atoms[conect.mainAtomKey]!.color
            let node = SCNNode(geometry: geometry)
            node.rotation = SCNVector4(axis.x, axis.y, axis.x, angle )
            node.position = SCNVector3((pointb.x + pointa.x)/2, (pointb.y + pointa.y)/2 , (pointb.z + pointa.z)/2)
            //print("\(height), \(node.rotation), \(conect.mainAtomKey), \(conection) ")
            scnScene.rootNode.addChildNode(node)
            //return //a enlever
        }
    }

    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

}
