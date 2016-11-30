//
//  tools.swift
//  proteins
//
//  Created by Jaime BERNABE on 11/30/16.
//  Copyright © 2016 Celine DANNAPPE. All rights reserved.
//

import UIKit
//import LocalAuthentication

extension UIViewController {
    
    func showAlertWithTitle( title:String, message:String ) {
        
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertVC.addAction(okAction)
        
        DispatchQueue.main.async {
            self.present(alertVC, animated: false, completion: nil)
        }
    }
    /**
     This method will present an UIAlertViewController to inform the user that the device has not a TouchID sensor.
     */
    
    func showAlertViewIfNoBiometricSensorHasBeenDetected(){
        self.showAlertWithTitle(title: "Error", message: "This device does not have a TouchID sensor.")
    }
    
    /**
     This method will present an UIAlertViewController to inform the user that there was a problem with the TouchID sensor.
     
     - parameter error: the error message
     
     */
    func showAlertViewAfterEvaluatingPolicyWithMessage( message:String ){
        LoginViewController.loginSharedInstance.showAlertWithTitle(title: "Error", message: message)
    }

}
