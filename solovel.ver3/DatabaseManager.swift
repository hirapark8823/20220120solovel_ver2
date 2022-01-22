//
//  databaseManager.swift
//  solovel.ver3
//
//  Created by 平本尚寛 on 2022/01/16.
//

import Foundation
import Firebase
import FirebaseAuth

class DatabaseManager {
    static let shared = DatabaseManager() //追記
    private init() {} //追記
    let db = Firestore.firestore() //追記


    func fetchUsers(completion: @escaping ([Post]) -> Void) {
        var allUsers = [Post]() //最終的にこちらにユーザ情報を格納する
//        if let loggedInUserId = (UserDefaults.standard.value(forKey: "loggedInUserId") as! String) {
//            print(loggedInUserId)
//        }
//        else {
//            print("値が代入されていません")
//        }
        let loggedInUserId = UserDefaults.standard.value(forKey: "loggedInUserId") as! String
        //ローカルに保存されているログインユーザのIDを取得。絶対にある想定なので強制アンラップ。
        //ここでエラー！Thread 1: Fatal error: Unexpectedly found nil while unwrapping an Optional value
        
        db.collection("post").whereField("firestoreId", isNotEqualTo: loggedInUserId).getDocuments { querySnapshot, error in //自分以外のユーザを取得する記述
            guard let querySnapshot = querySnapshot, error == nil else {
                completion([Post]()) //エラーあればその時点で終了。空っぽの配列をクロージャに渡す。
                return
            }
            for document in querySnapshot.documents {
                let data = document.data()
                guard let name = data["name"] as? String,
                      let id = data["firestoreId"] as? String else {
                          return
                      }
                let photoURL = data["photoURL"] as? String //写真はオプショナル
                let user = Post(id: id, name: name, photoURL: photoURL) //取得したデータをユーザ型に変換
                allUsers.append(user) //配列に一つずつ格納していく
            }
            completion(allUsers)
        }
    }
}
