//
//  LoginViewController.swift
//  solovel.ver3
//
//  Created by 平本尚寛 on 2022/01/15.
//

import UIKit
import Firebase

class LoginViewController: UIViewController{
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var LoginButton: UIButton!
    
    
    @IBAction func LoginButton(_ sender: Any) {
        
        func viewDidLoad() {
            super.viewDidLoad()
            
            LoginButton.isEnabled = false
            emailTextField.delegate = self
            passwordTextField.delegate = self
        }
        
        guard let email = emailTextField.text else{ return }
        guard let password = passwordTextField.text else{ return }
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] res, err in
            guard let self = self else { return }
            
            if let err = err {
                print("Login失敗", err)
                return
            }
            print("Login成功")
            res?.user.refreshToken
            UserDefaults.standard.set( res?.user.providerID, forKey: "loggedInUserId")
            let tabBarController = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
            self.present(tabBarController, animated: true, completion: nil)
            
            }
        }
    }


extension LoginViewController: UITextFieldDelegate{
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let emailIsEmpty = emailTextField.text?.isEmpty ?? true
        let passwordIsEmpty = passwordTextField.text?.isEmpty ?? true
        
        if emailIsEmpty || passwordIsEmpty{
            LoginButton.isEnabled = false
        } else {
            LoginButton.isEnabled = true
        }
        
    }
}
