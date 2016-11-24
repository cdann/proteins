//
//  extensions.swift
//  proteins
//
//  Created by Celine DANNAPPE on 10/27/16.
//  Copyright © 2016 Celine DANNAPPE. All rights reserved.
//

import SceneKit

extension UIColor {
    public static func pinkColor() -> UIColor {
        return UIColor(red: 255/255, green: 20/255, blue: 147/255, alpha: 1.0)
    }
    
    
    public static func brickColor() -> UIColor {
        return UIColor(red:165/255, green:42/255, blue:42/255, alpha: 1.0)
    }
    
    public static func salmonColor() -> UIColor {
        return UIColor(red:255/255, green:153/255, blue:96/255, alpha: 1.0)
    }
    
    public static func bluepurpleColor() -> UIColor {
        return UIColor(red: 98/255, green: 0, blue: 1, alpha: 1.0)
    }
    
    public static func darkGreenColor() -> UIColor {
        return UIColor(red: 4/255, green: 104/255, blue: 0, alpha: 1.0)
    }
    
    public static func silverColor() -> UIColor {
        return UIColor(red: 192/255, green: 192/255, blue: 192/255, alpha: 1.0)
    }
    
    public static func darkOrangeColor() -> UIColor {
        return UIColor(red: 213/255, green: 99/255, blue: 0, alpha: 1.0)
    }
    
    public static func getCPKColor(elem:String) -> UIColor{
        switch elem {
        case "H":
            return UIColor.whiteColor()
        case "C":
            return UIColor.darkGrayColor()
        case "N":
            return UIColor.blueColor()
        case "O":
            return UIColor.redColor()
        case "F", "Cl":
            return UIColor.greenColor()
        case "Br":
            return UIColor.brickColor()
        case "I":
            return UIColor.purpleColor()
        case "He", "Ne", "Ar", "Xe", "Kr":
            return UIColor.cyanColor()
        case "P":
            return UIColor.orangeColor()
        case "S":
            return UIColor.yellowColor()
        case "B":
            return UIColor.salmonColor()
        case "Li", "Na", "K", "Rb", "Cs", "Fr":
            return UIColor.bluepurpleColor()
        case "Be", "Mg", "Ca", "Sr", "Ba", "Ra":
            return UIColor.darkGreenColor()
        case "Ti":
            return UIColor.silverColor()
        case "Fe":
            return UIColor.darkOrangeColor()
        default:
            return UIColor.pinkColor()
        }
    }
}

extension SCNVector3 {
    
    public func normalize() -> SCNVector3 {
        let norm = self.getNorm()
        return SCNVector3(x/norm, y/norm, z/norm)
    }
    
    public func getNorm() -> Float{
        return sqrt(pow(x, 2) + pow(y, 2) + pow(z, 2))
    }
    
    public static func distance(left:SCNVector3, right:SCNVector3) -> Float {
        let xdiff = pow(left.x - right.x, 2)
        let ydiff = pow(left.y - right.x, 2)
        let zdiff = pow(left.z - right.z, 2)
        let result = sqrtf(xdiff + ydiff + zdiff)
        return result
    }
    
    public static func crossProduct(left:SCNVector3, right:SCNVector3) -> SCNVector3 {
        let x = left.y * right.z - right.y * left.z
        let y = left.z * right.x - right.z * left.x
        let z = left.x * right.y - right.x * left.y
        return SCNVector3(x, y, z)
    }
    
    public static func dotProduct(left:SCNVector3, right:SCNVector3) -> Float {
        return right.x * left.x + right.y * left.y + right.z * left.z
    }
    
}
