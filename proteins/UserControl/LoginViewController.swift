//
//  LoginViewController.swift
//  proteins
//
//  Created by Jaime BERNABE on 11/28/16.
//  Copyright © 2016 Celine DANNAPPE. All rights reserved.
//

import UIKit
import LocalAuthentication

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
        self.showAlertWithTitle(title: "Error", message: message)
    }
    
    
}

class LoginViewController: UIViewController {
    
    var shouldGo: Bool = false
    let authenticationContext = LAContext()
    var error:NSError?
    @IBOutlet weak var loginOutletButton: UIButton!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard self.authenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            loginOutletButton.isHidden = true
           self.showAlertViewIfNoBiometricSensorHasBeenDetected()
            return
        }
    }
    
    @IBAction func LoginAction(_ sender: UIButton) {
        // 2. Check if the device has a fingerprint sensor
        // If not, show the user an alert view and bail out!
        guard self.authenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            print("should hide")
            self.showAlertViewIfNoBiometricSensorHasBeenDetected()
            return
        }
        // 3. Check the fingerprint
        authenticationContext.evaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            localizedReason: "Only awesome people are allowed",
            reply: { [unowned self] (success, error) -> Void in
                
                if( success ) {
                    
                    // Fingerprint recognized
                    // Go to view controller
                    print("should pass")
                    self.shouldGo = true
                    self.navigateToAuthenticatedViewController()
                }else {
                    
                    // Check if there is an error
                    print("should stop")
                    if 	let err = error {
                        let message  = err.localizedDescription
                        self.showAlertViewAfterEvaluatingPolicyWithMessage(message: message)
                        self.shouldGo = false
                    }
                }
        })
        print("this is afert test  should go \(self.shouldGo)")
    }
    
    /**
     This method will push the authenticated view controller onto the UINavigationController stack
     */
    func navigateToAuthenticatedViewController(){
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "LoggedInViewController", sender: nil)
            
        }
    }
    
    override func showAlertWithTitle( title:String, message:String ) {
        
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertVC.addAction(okAction)
        
        DispatchQueue.main.async {
            self.present(alertVC, animated: false, completion: nil)
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "LoggedInViewController"
        {
            return self.shouldGo
        }
        return self.shouldGo
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}
