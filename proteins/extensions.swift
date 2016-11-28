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
    
    public static func getCPKColor(_ elem:String) -> UIColor{
        switch elem {
        case "H":
            return UIColor.white
        case "C":
            return UIColor.darkGray
        case "N":
            return UIColor.blue
        case "O":
            return UIColor.red
        case "F", "Cl":
            return UIColor.green
        case "Br":
            return UIColor.brickColor()
        case "I":
            return UIColor.purple
        case "He", "Ne", "Ar", "Xe", "Kr":
            return UIColor.cyan
        case "P":
            return UIColor.orange
        case "S":
            return UIColor.yellow
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
    
    public static func distance(_ left:SCNVector3, right:SCNVector3) -> Float {
        //print("------calcul-----")
        //print("start \(left)  \(right)")
        var xdiff = left.x - right.x
        var ydiff = left.y - right.y
        var zdiff = left.z - right.z
        //print("diffs \(xdiff)  \(ydiff)  \(zdiff)")
        
        
        xdiff = powf(xdiff, 2)
        ydiff = powf(ydiff, 2)
        zdiff = powf(zdiff, 2)
        //print("carre \(xdiff)  \(ydiff)  \(zdiff)")
        let sum = xdiff + ydiff + zdiff
        //print("sum \(sum)")
        let result = sqrtf(sum)
        //print("\(result) ----------------------")
        return result
    }
    
    public static func crossProduct(_ left:SCNVector3, right:SCNVector3) -> SCNVector3 {
        let x = left.y * right.z - right.y * left.z
        let y = left.z * right.x - right.z * left.x
        let z = left.x * right.y - right.x * left.y
        return SCNVector3(x, y, z)
    }
    
    public static func dotProduct(_ left:SCNVector3, right:SCNVector3) -> Float {
        return right.x * left.x + right.y * left.y + right.z * left.z
    }
    
}
