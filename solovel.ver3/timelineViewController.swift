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

    @IBOutlet weak var areapickerView: UIPickerView!
    
}

extension timelineViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return guestHouseInfomations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "timelineTableViewCell", for: indexPath) as! timelineTableViewCell
        let user = guestHouseInfomations[indexPath.row]
        cell.textLabel?.text = user.name //userはUser型のオブジェクトみたいなイメージ。表示したい文字列(name)を取り出す
        //該当のuserがphotoURLを持っていればURLから画像を表示(SDWebImageライブラリを使用)
        cell.imageView?.sd_setImage(with: user.image)
        return cell
    }
}

    
    
    
    
    
    
    
    
    
    
    
//    //摘んでいる処理
//    //Firestoreのデータベース
//    let db = Firestore.firestore()
//
//    var postArray = [Post]()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        //tableviewの設定
//        timelineTableView.delegate = self
//        timelineTableView.dataSource = self
//        timelineTableView.register(UINib(nibName: "timelineTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
//    }
//
//    func loadPost() {
//        //日付が古いものを下にして持ってくる
//        db.collection("post").order(by: "time").getDocuments  { (result, error) in
//            if error != nil {
//                print("データ呼び出し失敗")
//            } else {
//                print("データ呼び出し成功")
//
//                if let documents = result?.documents {
//                    //配列の初期化
//                    self.postArray = []
//                    //持ってきたデータを一つ一つ配列に入れる
//                    for document in documents {
//                        let data = document.data()
////                        let post = Post(dic: <#[String : Any]#>, GHName: data["GHName"] as! String,  postImage: data["image"] as! )
//                        //古いものを下にする
//                        self.postArray.reverse()
//                        //postArray配列に追加
////                        self.postArray.append(post)
//
//                    }
//                }
//            }
//        }
//    }
//}
//
////tableVIewの設定
//extension timelineViewController : UITableViewDelegate,UITableViewDataSource {
//
//    //tableViewのcellの数
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        //postArrayに入れた配列の数だけセルを表示
//        return postArray.count
//    }
//
//    //tableViewCellの中身
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = timelineTableView.dequeueReusableCell(withIdentifier: "Cell") as! timelineTableViewCell
////        //投稿画像をセルに配置
////        //Nukeを使いURLから画像に変更してセルのimageUrlに入れる
//////        let imageUrl = URL(Image: postArray[indexPath.row].postImage)
////        Nuke.loadImage(with: imageUrl as ImageRequestConvertible , into: cell.userImageView)
////
//        return cell
//    }
//
//    //tablaViewの高さ設定
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 500
//    }
//}
