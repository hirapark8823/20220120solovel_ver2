//
//  PostViewController.swift
//  solovel.ver3
//
//  Created by 平本尚寛 on 2022/01/13.
//

import UIKit
import Firebase
import FirebaseAuth

class PostViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    
    
    @IBOutlet weak var ghTextView: UITextField!
    @IBOutlet weak var areaTextView: UITextField!
    @IBOutlet weak var moneyTextView: UITextField!
    @IBOutlet weak var memoTextView: UITextField!
    @IBOutlet weak var PostBTN: UIButton!
    @IBOutlet weak var PostIMG: UIImageView!
    
    //Fierestoreのデータベース
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
            super.viewDidLoad()
            // Do any additional setup after loading the view.
    }
    //投稿ボタン
    @IBAction func Post(_ sender: Any) {
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
            }else {
                print("Firestrageへの画像の保存に成功")
                //5画像のURLを取得
                storageRef.downloadURL { (url, error) in
                    if error != nil {
                        print("Firestorageからのダウンロードに失敗しました")
                    }else {
                        print("Firestorageからのダウンロードに成功しました")
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
