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
//        print("ok")
        guard let email = emailTextField.text else{ return }
        guard let password = passwordTextField.text else{ return }
        
        Auth.auth().signIn(withEmail: email, password: password) { (res, err ) in
            if let err = err {
                print("Login失敗", err)
                return
            }
            print("Login成功")
            
            guard let uid = Auth.auth().currentUser?.uid else { return }
            let userRef = Firestore.firestore().collection("users").document(uid)
            userRef.getDocument { (snapshot, err)in
                if let err = err {
                    print("ユーザー情報の取得に失敗しました。\(err)")
                    return
                }
                
                guard let data = snapshot?.data() else {return}
                let user = User.init(dic: data)
                
                print("ユーザー情報の取得が出来ました。\(user.name)")
                
                //画面遷移
                // let storyBoard = UIStoryboard(name: "timeline", bundle: nil)
                // let homeViewController = storyBoard.instantiateViewController(withIdentifier: "timelineViewController")as! timelineViewController
                // self.present(homeViewController, animated: true, completion: nil)
                }
                
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
