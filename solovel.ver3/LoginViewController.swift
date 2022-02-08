//
//  LoginViewController.swift
//  solovel.ver3
//
//  Created by 平本尚寛 on 2022/01/15.
//

import UIKit
import Firebase
import PKHUD

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
        
        HUD.show(.progress, onView: view)

        guard let email = emailTextField.text else{ return }
        guard let password = passwordTextField.text else{ return }
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] res, err in
            guard let self = self else { return }
            
            if let err = err {
                print("Login失敗", err)
                HUD.hide{ (_) in
                    HUD.flash(.error, delay: 1)
                }
                return
            }
            print("Login成功")
            HUD.hide{ (_) in
                HUD.flash(.success, delay: 1)
            }
            
            res?.user.refreshToken
            UserDefaults.standard.set( res?.user.providerID, forKey: "loggedInUserId")
            let tabBarController = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
            self.present(tabBarController, animated: true, completion: nil)
            }
        }
    //keyboard隠すコード開始
    @objc func showKeyboard(notofication: Notification){
        let keyboardFrame =
        (notofication.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        
        guard let keyboardMinY = keyboardFrame?.minY else{return}
        let loginButtonMaxY = LoginButton.frame.maxY
        let distance = loginButtonMaxY - keyboardMinY + 40
        
        let transform = CGAffineTransform(translationX: 0, y: -distance)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, animations: {
            self.view.transform = transform
        })
    }
    
    @objc func hideKeyboard(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, animations: {
            self.view.transform = .identity
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    //keyboard隠すコード終了
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
