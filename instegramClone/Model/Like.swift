//
//  Like.swift
//  instegramClone
//
//  Created by Mdo on 15/02/2021.
//

import Foundation
class Like{
    
    var didLike:Bool
    var likesNumber: Int
    init(didLike:Bool, likesNumber:Int = 0) {
        self.didLike = didLike
        self.likesNumber = likesNumber
        
    }
}
