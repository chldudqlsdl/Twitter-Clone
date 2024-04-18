//
//  TweetViewModel.swift
//  TwitterTutorial
//
//  Created by Youngbin Choi on 4/18/24.
//

import Foundation

class TweetViewModel {
    
    let tweet: Tweet
    
    var profileImageUrl: URL? {
        return tweet.user.profileImageUrl
    }
    
    init(tweet: Tweet) {
        self.tweet = tweet
    }
    
}
