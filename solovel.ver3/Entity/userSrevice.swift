//
//  userSrevice.swift
//  solovel.ver3
//
//  Created by 平本尚寛 on 2022/02/08.
//

import Foundation
import FirebaseFirestore

class UserService {
    let db = Firestore.firestore()

    func get(collectionID: String, handler: @escaping ([GuestHouseMessage]) -> Void) {
        db.collection("message")
            .addSnapshotListener { querySnapshot, err in
                if let error = err {
                    print(error)
                    handler([])
                } else {
                    handler(GuestHouseMessage.build(from: querySnapshot?.documents ?? []))
                }
            }
    }
}
