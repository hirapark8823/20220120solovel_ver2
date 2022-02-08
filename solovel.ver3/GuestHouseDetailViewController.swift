//
//  GuestHouseDetailViewController.swift
//  solovel.ver3
//
//  Created by sugimoto.itaru on 2022/02/08.
//

import UIKit
import Firebase
import FirebaseFirestore
import SDWebImage //画像用のライブラリ読み込み(cellのところで使う)

class GuestHouseDetailViewController: UIViewController, UITextFieldDelegate {
    
    var guestHouseMessages: [GuestHouseMessage] = [] //Firestoreから受け取ったユーザデータを格納する配列
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var areaLabel: UILabel!
    @IBOutlet weak var memoLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var updateLabel: UILabel!
    @IBOutlet weak var inputTextField: UITextField!
    
    //TableView名
    @IBOutlet weak var InfoExchangeTableView: UITableView!
    
    var id: String? = nil
    var imageURL: URL? = nil
    var name: String? = nil
    var area: String? = nil
    var memo: String? = nil
    var value: String? = nil
    var message: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inputTextField.delegate = self
        InfoExchangeTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "MessageCell")
        image.sd_setImage(with: imageURL)
        nameLabel.text = name
        areaLabel.text = area
        memoLabel.text = memo
        valueLabel.text = value
        
        InfoExchangeTableView.dataSource = self
        InfoExchangeTableView.delegate = self
        InfoExchangeTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        fetchMessageData()
    }
    
    func fetchMessageData() {
        //firestoreからのデータ取得
        let db = Firestore.firestore()
        
        db.collection("message").whereField("id", isEqualTo: id!).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                var messages: [GuestHouseMessage] = []
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let guestHouseMessage = GuestHouseMessage(
                        name: data["name"] as! String,
                        message: data["message"] as! String
                    )
                    messages.append(guestHouseMessage)
                }
                self.guestHouseMessages = messages
                self.InfoExchangeTableView.reloadData()
            }
        }
    }
    
    //Firebaseに"message"コレクションでデータ保存
    @IBAction func pushMessage(_ sender: Any) {
        let name = UserDefaults.standard.string(forKey: "name") ?? "名無しさん"
        let db = Firestore.firestore()
        db.collection("message").document(id!).updateData(["message": message, "name": name, "date": Date().timeIntervalSince1970]) { [self] (error) in
            if error != nil {
                db.collection("message").addDocument(data: ["id": id, "message": message, "name": name, "date": Date().timeIntervalSince1970]) { (error) in
                    if error != nil {
                        print("送信失敗")
                    } else {
                        print("送信成功")
                        fetchMessageData()
                    }
                }
            } else {
                print("送信成功1")
                fetchMessageData()
            }
            inputTextField.text = ""
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        message = textField.text
        return true
    }
    
    //backボタン処理
    @IBAction func tappedBackButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension GuestHouseDetailViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return guestHouseMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageCell
        let message = guestHouseMessages[indexPath.row]
        cell.name.text = message.name
        cell.message.text = message.message
        return cell
    }
}
