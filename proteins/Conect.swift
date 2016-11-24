//
//  Conect.swift
//  proteins
//
//  Created by Celine DANNAPPE on 10/27/16.
//  Copyright © 2016 Celine DANNAPPE. All rights reserved.
//

import Foundation

class ConectData {
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
}