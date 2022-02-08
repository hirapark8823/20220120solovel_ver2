//
//  timelineViewController.swift
//  solovel.ver3
//
//  Created by 平本尚寛 on 2022/01/14.
//

import UIKit
import Firebase
import FirebaseAuth
import Nuke
import SDWebImage //画像用のライブラリ読み込み(cellのところで使う)

class timelineViewController: UIViewController {
    @IBOutlet weak var timelineTableView: UITableView!
    
    var guestHouseInfomations: [GuestHouseInfomation] = [] //Firestoreから受け取ったユーザデータを格納する配列
    override func viewDidLoad() {
        super.viewDidLoad()
        timelineTableView.delegate = self
        timelineTableView.dataSource = self
        timelineTableView.register(UINib(nibName: "timelineTableViewCell", bundle: nil), forCellReuseIdentifier: "timelineTableViewCell")
        
        let db = Firestore.firestore()
        
        db.collection("post").getDocuments() { [weak self] (querySnapshot, err) in
            guard let self = self else { return }
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let guestHouseInfomation = GuestHouseInfomation(
                        id: document.documentID,  //追加！！firestoreのドキュメント取得
                        name: data["GHName"] as! String,
                        area: Area(rawValue: data["area"] as! String)!,
                        image: URL(string: data["image"] as! String)!,
                        memo: data["memo"] as! String,
                        value: data["money"] as! String,
                        time: Date(timeIntervalSince1970: TimeInterval(data["time"] as! Double)))
                    self.guestHouseInfomations.append(guestHouseInfomation)
                }
                self.timelineTableView.reloadData()
            }
        }
    }
    
    //ログアウトボタン処理
    @IBAction func tappedLogoutButton(_ sender: Any) {
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
}

extension timelineViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return guestHouseInfomations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "timelineTableViewCell", for: indexPath) as! timelineTableViewCell
        let user = guestHouseInfomations[indexPath.row]
        cell.GHBtn.titleLabel?.text = user.name //userはUser型のオブジェクトみたいなイメージ。表示したい文字列(name)を取り出す
        //該当のuserがphotoURLを持っていればURLから画像を表示(SDWebImageライブラリを使用)
        cell.userImageView?.sd_setImage(with: user.image)
        return cell
    }
    
    //guesthouseTableViewへ画面遷移
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let info = guestHouseInfomations[indexPath.row]
        let guestHouseDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "GuestHouseDetailViewController") as! GuestHouseDetailViewController
        guestHouseDetailViewController.id = info.id
        guestHouseDetailViewController.imageURL = info.image
        guestHouseDetailViewController.name = info.name
        guestHouseDetailViewController.area = info.area.rawValue
        guestHouseDetailViewController.value = info.value
        guestHouseDetailViewController.memo = info.memo
        
        self.navigationController?.pushViewController(guestHouseDetailViewController, animated: true)
    }
}
