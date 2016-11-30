//
//  AuthentificationManager.swift
//  proteins
//
//  Created by Jaime BERNABE on 11/30/16.
//  Copyright © 2016 Celine DANNAPPE. All rights reserved.
//

import UIKit
import LocalAuthentication

class AuthentificationManager {
    let context = LAContext()
    var evaluationError:NSError?
    static let sharedInstance = AuthentificationManager()
    var needsAuthentication = false
    
    func checkTouchId()
    {
        
        let myLocalizedReasonString = "Authentication is required"
        
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &evaluationError) else {
            showAlertViewIfNoBiometricSensorHasBeenDetected()
            return
        }
        // 3. Check the fingerprint
        context.evaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            localizedReason: myLocalizedReasonString,
            reply: { [unowned self] (success, evaluationError) -> Void in
                
                if( success ) {
                    // Fingerprint recognized
                    // Go to view controller
                    OperationQueue.main.addOperation({ () -> Void in
                        self.loadData()
                    })
                }
                else {
                    // Check if there is an error
                    if 	let err = evaluationError {
                        let message  = err.localizedDescription
                        self.showAlertViewAfterEvaluatingPolicyWithMessage(message: message)
                    }
                }
        })
    }
    
    func loadData() {
        // Do whatever you want
        print("test load Data")
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
        self.showAlertWithTitle(title: "Error", message: message)
    }
    
    func showAlertWithTitle( title:String, message:String ) {
        
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertVC.addAction(okAction)
        
        DispatchQueue.main.async {
            LoginViewController.loginSharedInstance.present(alertVC, animated: false, completion: nil)
        }
    }
    
}
