//
//  UploadTweetViewModel.swift
//  TwitterTutorial
//
//  Created by Youngbin Choi on 4/23/24.
//

import Foundation
import UIKit

enum UploadTweetConfiguration {
    case tweet
    case reply(Tweet)
}

class UploadTweetViewModel {
    
    let actionButtonTitle: String
    let placeholderText: String
    var shouldShowReplyLabel: Bool
    var replyText: String?
    
    init(config: UploadTweetConfiguration) {
        switch config {
        case .tweet:
            actionButtonTitle = "Tweet"
            placeholderText = "What's happening"
            shouldShowReplyLabel = false
        case .reply(let tweet):
            actionButtonTitle = "Reply"
            placeholderText = "Tweet your reply"
            shouldShowReplyLabel = true
            replyText = "Replying to @\(tweet.user.username)"
        }
    }
}
