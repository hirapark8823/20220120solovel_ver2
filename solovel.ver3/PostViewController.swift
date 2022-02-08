//
//  PostViewController.swift
//  solovel.ver3
//
//  Created by 平本尚寛 on 2022/01/13.
//

import UIKit
import Firebase
import FirebaseAuth
import PKHUD

class PostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    
    
    @IBOutlet weak var ghTextView: UITextField!
    @IBOutlet weak var areaTextView: UITextField!
    @IBOutlet weak var moneyTextView: UITextField!
    @IBOutlet weak var memoTextView: UITextField!
    @IBOutlet weak var PostBTN: UIButton!
    @IBOutlet weak var PostIMG: UIImageView!
    
    //Fierestoreのデータベース
    let db = Firestore.firestore()
    
//    override func viewDidLoad() {
//            super.viewDidLoad()
//            // Do any additional setup after loading the view.
//    }
    //投稿ボタン
    @IBAction func Post(_ sender: Any) {
        
        HUD.show(.progress, onView: view)

        //画像が入っていたら
        guard let postImage = PostIMG.image else {return}
        //1画像ファイルが大きすぎるので小さくする
        let uploadImage = postImage.jpegData(compressionQuality: 0.3)
        //2画像の名前を設定
        let fileName = NSUUID().uuidString
        //3保存する場所を指定
        let storageRef = Storage.storage().reference().child("postImage").child(fileName)
        let meta = StorageMetadata()
        meta.contentType = "image/jpeg" // <- これ！！
        //4storageに画像を保存
        storageRef.putData(uploadImage!, metadata: meta) { (metadate, error) in
            //errorがあったら
            if error != nil {
                print("Firestrageへの画像の保存に失敗")
                HUD.hide{ (_) in
                    HUD.flash(.error, delay: 1)
                }
            }else {
                print("Firestrageへの画像の保存に成功")
                //5画像のURLを取得
                storageRef.downloadURL { (url, error) in
                    if error != nil {
                        print("Firestorageからのダウンロードに失敗しました")
                        HUD.hide{ (_) in
                            HUD.flash(.error, delay: 1)
                        }
                    }else {
                        print("Firestorageからのダウンロードに成功しました")
                        HUD.hide{ (_) in
                            HUD.flash(.success, delay: 1)
                        }
                        //6URLをString型に変更して変数urlStringにdainyuu
                        guard let urlString =  url?.absoluteString else {return}
                        //ここで呼ぶ。postImageUrlにurlStringを入れることで、URLがsavePostに届く
                        self.savePost(postImageUrl: urlString)
                    }
                }
            }
        }
    }
    
    //投稿内容を保存する関数
       func savePost(postImageUrl:String) {
           //postTextViewにテキストが入っていたら
           guard let ghName = ghTextView.text else {return}
           guard let area = areaTextView.text else {return}
           guard let money = moneyTextView.text else {return}
           guard let memo = memoTextView.text else {return}
           db.collection("post").addDocument(data: ["GHName":ghName, "area":area, "money":money, "memo":memo, "time":Date().timeIntervalSince1970, "image":postImageUrl]) { (error) in
                       if error != nil {
                           print("送信失敗")
                       } else {
                           print("送信成功")
                           //postTextViewを空にする
                           self.ghTextView.text = ""
                           self.areaTextView.text = ""
                           self.moneyTextView.text = ""
                           self.memoTextView.text = ""
                       }
                   }
    }
    
    @IBAction func chooseIMG(_ sender: Any) {
        //imagePicerContoeoller で画像を選択できる
                let imagePicerContoeoller = UIImagePickerController()
                imagePicerContoeoller.delegate = self
                imagePicerContoeoller.allowsEditing = true

                self.present(imagePicerContoeoller,animated: true,completion: nil)
    }
    
    //キーボードをえぇ感じに表示する
    @objc func showKeyboard(notofication: Notification){
        let keyboardFrame =
        (notofication.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        
        guard let keyboardMinY = keyboardFrame?.minY else{return}
        let loginButtonMaxY = PostBTN.frame.maxY
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
    
    //ログアウト開始
    @IBAction func tapLogOutButton(_ sender: Any) {
        handleLogout()
    }
    
    private func handleLogout(){
        do{
            try Auth.auth().signOut()
            dismiss(animated: true, completion: nil)
        } catch (let err){
            print("ログアウト失敗: \(err)")
        }
    }
    //ログアウト終了
    
    //エリアセレクトボックス開始
    var pickerView: UIPickerView = UIPickerView()
    let list = ["北海道","青森県","秋田県","岩手県","山形県","宮城県","福島県","新潟県","栃木県","群馬県","茨城県","埼玉県",
                "千葉県","神奈川県","東京都","山梨県","長野県","静岡県","富山県","石川県","福井県","愛知県","三重県","岐阜県","滋賀県","京都府","奈良県","大阪府","和歌山県","兵庫県","岡山県","広島県","鳥取県","島根県","山口県","徳島県","香川県","高知県","愛媛県","福岡県","佐賀県","長崎県","熊本県","大分県","宮崎県","鹿児島県","沖縄県"]

        override func viewDidLoad() {
            super.viewDidLoad()

            pickerView.delegate = self
            pickerView.dataSource = self
            pickerView.showsSelectionIndicator = true

            let toolbar = UIToolbar(frame: CGRectMake(0, 0, 0, 35))
            let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(PostViewController.done))
            let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(PostViewController.cancel))
            toolbar.setItems([cancelItem, doneItem], animated: true)

            self.areaTextView.inputView = pickerView
            self.areaTextView.inputAccessoryView = toolbar
        }

        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }

        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return list.count
        }

        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return list[row]
        }

        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            self.areaTextView.text = list[row]
        }

    @objc func cancel() {
            self.areaTextView.text = ""
            self.areaTextView.endEditing(true)
        }

    @objc func done() {
            self.areaTextView.endEditing(true)
        }

        func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
            return CGRect(x: x, y: y, width: width, height: height)
        }

        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
    //エリアセレクトボックス終了
}
    
//画像表示
extension PostViewController {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let choosedImage = info[.originalImage] as? UIImage {
                PostIMG.image = choosedImage
            }
            dismiss(animated: true, completion: nil)
        }
}
