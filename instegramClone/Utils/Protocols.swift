//
//  Protocols.swift
//  instegramClone
//
//  Created by Mdo on 15/01/2021.
//

import Foundation

protocol FeedCellDelegate:class {
    func handleUserNameTapped(for cell:FeedCell)
    func handleOptionTapped(for cell:FeedCell)
    func handleLikeTapped(for cell:FeedCell)
    func handleCommentTapped(for cell: FeedCell)
    func handleShowLikesForCell(for cell: FeedCell)
    func configureCommentIndicatorView(for cell: FeedCell)
    func handleMessageButtonTapped(for cell:FeedCell)
}



protocol UserProfileHeaderDelegate:class{
    
    func handleEditFollowTapped(for header:UserProfileHeader)
    func setUserStats(for header:UserProfileHeader)
    func handleFollowersTapped(for header:UserProfileHeader)
    func handleFollowingTapped(for header:UserProfileHeader)
    
}

protocol FollowCellDelegate:class {
    func handleFollowTappedDelegate(for cell: FollowCell)
}

