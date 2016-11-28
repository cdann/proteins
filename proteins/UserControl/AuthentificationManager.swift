//
//  AuthentificationManager.swift
//  proteins
//
//  Created by Jaime BERNABE on 11/28/16.
//  Copyright © 2016 Celine DANNAPPE. All rights reserved.
//

import UIKit
import LocalAuthentication

class AuthentificationManager: UIViewController {

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
        print("Load data")
    }
  

}
