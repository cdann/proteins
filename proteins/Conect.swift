//
//  Conect.swift
//  proteins
//
//  Created by Celine DANNAPPE on 10/27/16.
//  Copyright © 2016 Celine DANNAPPE. All rights reserved.
//

import Foundation
import SceneKit

class ConectData {
    static var all = [Int : ConectData]()
    let mainAtomKey:Int
    let conections:[Int]
   
    
    init?(main:String, connects:[String]){
        if let m = Int(main){
            mainAtomKey = m
        }
        else {
            return nil
        }
        conections = connects.map(){
            value in
            if let m = Int(value){
                return m
            } else {
                return -1
            }

        }
        if conections.contains(-1) {
            return nil
        }
    }
    
    func displayConect(_ scnScene:SCNScene) {
        let src = AtomData.all[mainAtomKey]!.pos
        let color = AtomData.all[mainAtomKey]!.color
        let radius:CGFloat = 0.2
        for conection in conections {
            if AtomData.all[conection]?.checkConnect == false {
                let dest = AtomData.all[conection]!.pos
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
        AtomData.all[mainAtomKey]!.checkConnect = true
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
}
