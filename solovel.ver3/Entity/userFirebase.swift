//
//  userFirebase.swift
//  solovel.ver3
//
//  Created by 平本尚寛 on 2022/02/08.
//

import Foundation
import FirebaseFirestore

extension GuestHouseMessage {
    static func build(from documents: [QueryDocumentSnapshot]) -> [GuestHouseMessage] {
        var users = [GuestHouseMessage]()
        for document in documents {
            users.append(GuestHouseMessage(name: document["name"] as? String ?? "",
                                           message: document["message"] as? String ?? ""))
        }
        return users
    }
}
