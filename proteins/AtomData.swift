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
    let key:Int
    let pos :SCNVector3
    let color:UIColor
    var node:SCNNode?
    
    
    var description: String {
        get {
            return "\(key): pos -> \(pos), color -> \(color) \n ******************\n"
        }
    }
    
    
    init?(k:String, px:String, py:String, pz:String, elem:String) {
        if let ke = Int(k), let x = Float(px), let y = Float(py), let z = Float(pz){
            key = ke
            pos = SCNVector3(x:x, y:y, z:z)
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
}
