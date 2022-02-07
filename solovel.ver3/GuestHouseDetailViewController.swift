//
//  GuestHouseDetailViewController.swift
//  solovel.ver3
//
//  Created by sugimoto.itaru on 2022/02/08.
//

import UIKit
import Firebase
import SDWebImage //画像用のライブラリ読み込み(cellのところで使う)

class GuestHouseDetailViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var areaLabel: UILabel!
    @IBOutlet weak var memoLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var updateLabel: UILabel!
    @IBOutlet weak var inputTextField: UITextField!
    
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
        image.sd_setImage(with: imageURL)
        nameLabel.text = name
        areaLabel.text = area
        memoLabel.text = memo
        valueLabel.text = value
    }
    @IBAction func pushMessage(_ sender: Any) {
        let db = Firestore.firestore()
        db.collection("message").document(id!).updateData(["message": message]) { [self] (error) in
            if error != nil {
                db.collection("message").addDocument(data: ["id": id , "message": message] ) { (error) in
                    if error != nil {
                        print("送信失敗")
                    } else {
                        print("送信成功")
                    }
                }
            } else {
                print("送信成功1")
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        message = textField.text
        return true
    }
}
