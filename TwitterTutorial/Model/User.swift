//
//  User.swift
//  TwitterTutorial
//
//  Created by Youngbin Choi on 4/13/24.
//

import Foundation
import FirebaseAuth

struct User {
    let uid: String
    let email: String
    let fullname: String
    let username: String
    var profileImageUrl: URL?
    var isFollowed = false
    var stats: UserRelationStats?
    
    var isCurrentUser: Bool { return Auth.auth().currentUser?.uid == uid }
    
    init(uid:String, dictionary: [String: AnyObject]){
        self.uid = uid
        
        self.email = dictionary["email"] as? String ?? ""
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        
        if let profileImageUrl = dictionary["profileImageUrl"] as? String {
            guard let url = URL(string: profileImageUrl) else { return }
            self.profileImageUrl = url
        }
    }
}

struct UserRelationStats {
    var followers: Int
    var following: Int
}
