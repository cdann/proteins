//
//  AtomData.swift
//  proteins
//
//  Created by Celine DANNAPPE on 10/26/16.
//  Copyright © 2016 Celine DANNAPPE. All rights reserved.
//

import UIKit
import SceneKit


class AtomData: CustomStringConvertible {
    static var all = [Int : AtomData]()
    let key:Int
    let pos :SCNVector3
    let color:UIColor
    let elm:String
    var node:SCNNode?{
        didSet{
            node?.name = elm
        }
    }
    var checkConnect = false
    
    static var xminmax:(Float, Float)? = nil
    static var yminmax:(Float, Float)? = nil
    static var zminmax:(Float, Float)? = nil
    
    var description: String {
        get {
            return "\(key): pos -> \(pos), color -> \(color) \n ******************\n"
        }
    }
    
    
    init?(k:String, px:String, py:String, pz:String, elem:String) {
        if let ke = Int(k), let x = Float(px), let y = Float(py), let z = Float(pz){
            key = ke
            pos = SCNVector3(x:x, y:y, z:z)
            elm = elem
            color = UIColor.getCPKColor(elem)
        }
        else {
            if let _ = Int(k){print("keok")}
            if let _ = Float(px){ print("x ok")}
            if let _ = Float(py){ print("y ok")}
            if let _ = Float(pz){ print("z ok")}
            return nil
        }
    }
    
    func displayAtom(_ scene:SCNScene) {
        var geometry:SCNGeometry
        geometry = SCNSphere(radius: 0.4)
        geometry.materials.first?.diffuse.contents = color
        node = SCNNode(geometry: geometry)
        node!.position = pos
        scene.rootNode.addChildNode(node!)
        setMinMax()
    }
    
    func setMinMax() {
        let px = pos.x
        let py = pos.y
        let pz = pos.z
        
        if AtomData.xminmax == nil && AtomData.yminmax == nil && AtomData.zminmax == nil {
            AtomData.xminmax = (px, px)
            AtomData.yminmax = (py, py)
            AtomData.zminmax = (pz, pz)
        }
        else{
            if px < AtomData.xminmax!.0{
                AtomData.xminmax!.0 = px
            }
            else if px > AtomData.xminmax!.1{
                AtomData.xminmax!.1 = px
            }
            if py < AtomData.yminmax!.0{
                AtomData.yminmax!.0 = py
            }
            else if py > AtomData.yminmax!.1{
                AtomData.yminmax!.1 = py
            }
            if pz < AtomData.zminmax!.0{
                AtomData.zminmax!.0 = pz
            }
            else if pz > AtomData.zminmax!.1{
                AtomData.zminmax!.1 = pz
            }
            
        }
    }
}
