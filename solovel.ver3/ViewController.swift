//
//  ViewController.swift
//  solovel.ver3
//
//  Created by 平本尚寛 on 2021/12/15.
//

import UIKit
import Firebase
import PKHUD

struct User{
    
    let name: String
    let createdAt: Timestamp
    let email: String
    
    init(dic: [String: Any]){
        self.name = dic["name"] as! String
        self.createdAt = dic["createdAt"] as! Timestamp
        self.email = dic["email"] as! String
    }
}


class ViewController: UIViewController {

    //ログイン画面
    @IBOutlet weak var emailTextFielder: UITextField!
    @IBOutlet weak var passwordTextFielder: UITextField!
    @IBOutlet weak var usernameTextFielder: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBAction func tappedRegisterButton(_ sender: Any) {
        handleAuthToFirebase()
    }
    
    private func handleAuthToFirebase(){
        HUD.show(.progress, onView: view)
        guard let email = emailTextFielder.text else{return}
        guard let password = passwordTextFielder.text else{return}
        
        Auth.auth().createUser(withEmail: email, password: password){(res, err) in
            if let err = err{
                print("認証情報の取得に失敗しました。\(err)")
                HUD.hide{ (_) in
                    HUD.flash(.error, delay: 1)
                }
                return
            }
            self.addUserInfoToFirestore(email: email)
            
            UserDefaults.standard.set( res?.user.providerID, forKey: "loggedInUserId")
            let tabBarController = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
            self.present(tabBarController, animated: true, completion: nil)
        }
    }
    
    private func addUserInfoToFirestore(email: String){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let name = self.usernameTextFielder.text else{ return }
        UserDefaults.standard.set(name, forKey: "name")
        let docData = ["email":email, "name":name, "createdAt":Timestamp()] as [String : Any]
        let userRef = Firestore.firestore().collection("users").document(uid)
        
        userRef.setData(docData){(err) in
            if let err = err{
                print("firestoreへの保存に失敗しました。\(err)")
                HUD.hide{ (_) in
                    HUD.flash(.error, delay: 1)
                }
                return
            }
            print("firestoreへの保存に成功しました。")
            
            userRef.getDocument { (snapshot, err)in
                if let err = err {
                    print("ユーザー情報の取得に失敗しました。\(err)")
                    HUD.hide{ (_) in
                        HUD.flash(.error, delay: 1)
                    }
                    return
                }
                
                guard let data = snapshot?.data() else {return}
                let user = User.init(dic: data)
                
                print("ユーザー情報の取得が出来ました。\(user.name)")
                HUD.hide{ (_) in
                    HUD.flash(.success, delay: 1)
                }
            }
        }
    }
    
    //20210120ログインエラー開始
    private func signInErrAlert(_ error: NSError){
        print(#function)
        //メッセージをエラーの種類によって変える
        if let errCode = AuthErrorCode(rawValue: error.code) {
            var message = ""
            switch errCode {
            case .userNotFound:  message = "アカウントが見つかりませんでした"
            case .wrongPassword: message = "パスワードを確認してください"
            case .userDisabled:  message = "アカウントが無効になっています"
            case .invalidEmail:  message = "Eメールが無効な形式です"
            default:             message = "エラー: \(error.localizedDescription)"
            }
            // アラートを出す関数を実施する。
            self.showAlert(title: "ログインできませんでした", message: message)
        }
    }
    
    //Mark: AlertMethod
    private func showAlert(title: String, message: String?) {
        print(#function)
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default,handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
    //20210120ログインエラー終了
    
    //キーボードをえぇ感じに表示させる処理
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        loginButton.isEnabled = false
        emailTextFielder.delegate = self
        passwordTextFielder.delegate = self
        usernameTextFielder.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func showKeyboard(notofication: Notification){
        let keyboardFrame =
        (notofication.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        
        guard let keyboardMinY = keyboardFrame?.minY else{return}
        let loginButtonMaxY = loginButton.frame.maxY
        let distance = loginButtonMaxY - keyboardMinY + 20
        
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
}

//文字が入力されていなかったらボタンが押せない処理
extension ViewController:UITextFieldDelegate{
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let emailIsEmpty = emailTextFielder.text?.isEmpty ?? true
        let passwordIsEmpty = passwordTextFielder.text?.isEmpty ?? true
        let usernameIsEmpty = usernameTextFielder.text?.isEmpty ?? true
        
        if emailIsEmpty || passwordIsEmpty{
            loginButton.isEnabled = false
        } else {
            loginButton.isEnabled = true
        }
    }
}

