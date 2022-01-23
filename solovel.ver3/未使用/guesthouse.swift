//
//  guesthouse.swift
//  solovel.ver3
//
//  Created by 平本尚寛 on 2021/12/27.
//

import Foundation

struct guesthouse {
    private(set) public var houseName : String
    private(set) public var imageName : String
    
    init(houseName: String, imageName: String) {
        self.houseName = houseName
        self.imageName = imageName
    }
}
