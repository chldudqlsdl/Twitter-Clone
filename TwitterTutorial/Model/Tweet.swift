//
//  Tweet.swift
//  TwitterTutorial
//
//  Created by Youngbin Choi on 4/18/24.
//

import Foundation

struct Tweet {
    let caption: String
    let tweetID: String
    let uid: String
    let likes: Int
    let retweetCount: Int
    let timestamp: Date!
    let user: User
    
    init(tweetID: String, dictionary: [String: Any], user: User) {
        self.tweetID = tweetID
        self.caption = dictionary["caption"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        self.likes = dictionary["likes"] as? Int ?? 0
        self.retweetCount = dictionary["caption"] as? Int ?? 0
        
        if let timestamp = dictionary["timestamp"] as? Double {
            self.timestamp = Date(timeIntervalSince1970: timestamp)
        } else {
            timestamp = Date()
        }
        self.user = user
    }
}
