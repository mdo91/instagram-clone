//
//  Constants.swift
//  instegramClone
//
//  Created by Mdo on 03/02/2021.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage

//MARK: - Root references

let DB_REF = Database.database().reference()
let STORAGE_REF = Storage.storage().reference()

//MARK: - Storage References

let STORAGE_PROFILE_IMAGES_REF = STORAGE_REF.child("profile_images")
let STORAGE_MESSAGES_IMAGES_REF = STORAGE_REF.child("message_images")
let STORAGE_MESSAGE_VIDEO_REF = STORAGE_REF.child("video_messages")
let STORAGE_POST_IMAGES_REF = STORAGE_REF.child("post_images")

//MARK: - Database References

let USER_REF = DB_REF.child("users")
let USER_FOLLOWER_REF = DB_REF.child("user-followers")
let USER_FOLLOWING_REF = DB_REF.child("user-following")

let POSTS_REF = DB_REF.child("posts")
let USER_POSTS_REF = DB_REF.child("user-posts")


let USER_FEED_REF = DB_REF.child("user-feed")

let POSTS_LIKES_REF = DB_REF.child("post-likes")
let USER_LIKES_REF = DB_REF.child("user-likes")

let NOTIFICATIONS_REF = DB_REF.child("notifications")

let LIKE_INT_VALUE = 0
let COMMENT_INT_VALUE = 1
let FOLLOW_INT_VALUE = 2
let USER_MESSAGES_REF = DB_REF.child("user-messages")
let MESSAGES_REF = DB_REF.child("messages")



