//
//  FeedController.swift
//  TwitterTutorial
//
//  Created by Youngbin Choi on 4/10/24.
//

import UIKit
import Then
import Kingfisher

private let reuseIdentifier = "TweetCell"

class FeedController: UICollectionViewController {

    // MARK: - Properties
    var user: User? {
        didSet {
            configureLeftBarButton()
        }
    }
    
    private var tweets: [Tweet] = [] {
        didSet { collectionView.reloadData() }
    }
    
    
    // MARK: - LifeCycles

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchTweets()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    
    // MARK: - API
    
    func fetchTweets() {
        TweetService.shared.fetchTweets { [weak self] tweets in
            self?.tweets = tweets
            self?.checkIfUserLikedTweet(tweets)
        }
    }
    
    func checkIfUserLikedTweet(_ tweets: [Tweet]) {
        for (index, tweet) in tweets.enumerated() {
            TweetService.shared.checkIfUserLikedTweet(tweet) { didLike in
                if didLike {
                    self.tweets[index].didLike = true
                }
            }
        }
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .systemBackground
        
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.delegate = self
        
        let imageView = UIImageView(image: UIImage(named: "twitter_logo_blue")).then {
            $0.contentMode = .scaleAspectFit
            $0.setDimensions(width: 44, height: 44)
        }
        navigationItem.titleView = imageView
        
    }
    
    func configureLeftBarButton() {
        guard let user = user else { return }
        
        let profileImageView = UIImageView().then {
            $0.backgroundColor = .twitterBlue
            $0.setDimensions(width: 32, height: 32)
            $0.layer.cornerRadius = 16
            $0.layer.masksToBounds = true
            $0.contentMode = .scaleAspectFill

            $0.kf.setImage(with: user.profileImageUrl)
        }
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileImageView)
    }
}
// MARK: - UICollectionViewDelegate / DataSource

extension FeedController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tweets.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TweetCell
        cell.tweet = tweets[indexPath.row]
        cell.delegate = self
        cell.indexPath = indexPath
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = TweetController(tweet: tweets[indexPath.row])
        navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension FeedController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewModel = TweetViewModel(tweet: tweets[indexPath.row])
        let height = viewModel.size(forWidth: view.frame.width - 80, withFontSize: 14).height
        return CGSize(width: view.frame.width, height: height + 80)
    }
}

// MARK: - TweetCellDelegate

extension FeedController: TweetCellDelegate {
    
    
    func handleProfileImageTapped(_ cell: TweetCell) {
        
        guard let user = cell.tweet?.user else { return }
        let vc = ProfileController(user: user)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func handleCommentTapped(_ cell: TweetCell) {
        guard let tweet = cell.tweet else { return }
        let controller = UploadTweetController(user: tweet.user, config: .reply(tweet))
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
    
    func handleLikeTapped(_ cell: TweetCell, _ indexPath: IndexPath?) {
        guard let tweet = cell.tweet else { return }
        guard let indexPath = indexPath else { return }
        
        TweetService.shared.likeTweet(tweet: tweet) { err, ref in
            UIView.animate(withDuration: 0.5) {
                cell.tweet?.didLike.toggle()
                self.tweets[indexPath.row].didLike.toggle()
            }
            let likes = tweet.didLike ? tweet.likes - 1 : tweet.likes + 1
            
            self.tweets[indexPath.row].likes = likes
            cell.tweet?.likes = likes
            
            // NotiUpload 는 좋아요를 눌렀을 때만
            if !tweet.didLike {
                NotificationService.shared.uploadNotification(type: .like, tweet: tweet)
            }
        }
    }
}
