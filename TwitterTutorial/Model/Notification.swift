//
//  Notification.swift
//  TwitterTutorial
//
//  Created by Youngbin Choi on 4/26/24.
//

import Foundation
import UIKit

enum NotificationType: Int {
    case follow
    case like
    case reply
    case retweet
    case mention
}

struct Notification {
    let tweetID: String?
    var timestamp: Date!
    let user: User
    var tweet: Tweet?
    var type: NotificationType!
    
    init(user: User, tweet: Tweet?, dictionary: [String : AnyObject]) {
        self.user = user
        self.tweet = tweet
        self.tweetID = dictionary["tweetID"] as? String ?? ""
        
        if let timestamp = dictionary["timestamp"] as? Double {
            self.timestamp = Date(timeIntervalSince1970: timestamp)
        }
        
        if let typeNum = dictionary["type"] as? Int {
            self.type = NotificationType(rawValue: typeNum)
        }
    }
}
