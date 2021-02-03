//
//  Protocols.swift
//  instegramClone
//
//  Created by Mdo on 15/01/2021.
//

import Foundation

protocol FeedCellDelegate {
    func handleUserNameTapped(for cell:String)
    func handleOptionTapped(for cell:String)
    func handleLikeTapped(for cell:String)
    func handleCommentTapped(for cell: String)
    func handleShowLikesForCell(for cell: String)
    func configureCommentIndicatorView(for cell: String)
}



protocol UserProfileHeaderDelegate:class{
    
    func handleEditFollowTapped(for header:UserProfileHeader)
    func setUserStats(for header:UserProfileHeader)
    func handleFollowersTapped(for header:UserProfileHeader)
    func handleFollowingTapped(for header:UserProfileHeader)
    
}
