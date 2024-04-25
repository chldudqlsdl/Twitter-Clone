//
//  TweetController.swift
//  TwitterTutorial
//
//  Created by Youngbin Choi on 4/22/24.
//

import Foundation
import UIKit

private let reuseIdentifier = "TweetCell"
private let headerIdentifier = "TweetHeader"

class TweetController: UICollectionViewController {
    
    // MARK: - Properties
    private let tweet: Tweet
    private let actionSheetLauncher: ActionSheetLauncher
    private var replies: [Tweet] = [] {
        didSet { collectionView.reloadData() }
    }
    
    // MARK: - Lifecycle
    init(tweet: Tweet) {
        self.tweet = tweet
        self.actionSheetLauncher = ActionSheetLauncher(user: tweet.user)
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        fetchReplies()
    }
    
    // MARK: - Helpers
    func configureCollectionView() {
        collectionView.backgroundColor = .systemBackground
        
        collectionView.register(TweetHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    
    // MARK: - Helpers
    func fetchReplies() {
        TweetService.shared.fetchReplies(forTweet: tweet) { [weak self] replies in
            self?.replies = replies
        }
    }
}


// MARK: - DataSource

extension TweetController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return replies.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TweetCell
        cell.tweet = replies[indexPath.row]
        return cell
    }
}


// MARK: - headerDataSource
extension TweetController {
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! TweetHeader
        header.tweet = tweet
        header.delegate = self
        return header
    }
}


// MARK: - UICollectionViewFlowLayout

extension TweetController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let viewModel = TweetViewModel(tweet: tweet)
        let height = viewModel.size(forWidth: view.frame.width - 32, withFontSize: 20).height
        return CGSize(width: view.frame.width, height: height + 220)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewModel = TweetViewModel(tweet: replies[indexPath.row])
        let height = viewModel.size(forWidth: view.frame.width - 80, withFontSize: 14).height
        return CGSize(width: view.frame.width, height: height + 80)
    }
}

// MARK: - TweetHeaderDelegate
extension TweetController: TweetHeaderDelegate {
    
    func showActionSheet() {
        actionSheetLauncher.delegate = self
        actionSheetLauncher.show()
    }
}

// MARK: - ActionSheetLauncherDelegate
extension TweetController: ActionSheetLauncherDelegate {
    
    func didSelect(option: ActionSheetOptions) {
        switch option {
        case .follow(let user):
            UserService.shared.followUser(uid: user.uid) { err, ref in
                print("\(user.fullname) 팔로우 하였습니다")
            }
        case .unfollow(let user):
            UserService.shared.unFollowUser(uid: user.uid) { err, ref in
                print("\(user.fullname) 언팔로우 하였습니다")
            }
        case .report:
            print("신고하였습니다")
        case .delete:
            print("트윗 삭제하였습니다")
        }
    }

}
