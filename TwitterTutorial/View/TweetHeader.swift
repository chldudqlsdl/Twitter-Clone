//
//  TweetHeader.swift
//  TwitterTutorial
//
//  Created by Youngbin Choi on 4/23/24.
//

import Foundation
import UIKit

class TweetHeader: UICollectionReusableView {
    
    // MARK: - Properties
    var tweet: Tweet? {
        didSet { configure() }
    }
    
    private lazy var profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.setDimensions(width: 48, height: 48)
        $0.layer.cornerRadius = 48 / 2
        $0.backgroundColor = .twitterBlue
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTapped))
        $0.addGestureRecognizer(tapGesture)
        $0.isUserInteractionEnabled = true
    }
    
    private let fullnameLabel = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 14)
        $0.text = "hahaahh"
    }
    
    private let usernameLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textColor = .lightGray
        $0.text = "hahaahh"
    }
    
    private lazy var labelStackView = UIStackView().then {
        $0.addArrangedSubview(fullnameLabel)
        $0.addArrangedSubview(usernameLabel)
        $0.axis = .vertical
        $0.spacing = -6
    }
    
    private lazy var profileStackView = UIStackView().then {
        $0.addArrangedSubview(profileImageView)
        $0.addArrangedSubview(labelStackView)
        $0.spacing = 12
    }
    
    private let captionLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 20)
        $0.numberOfLines = 0
    }
    
    private let dateLabel = UILabel().then {
        $0.textColor = .lightGray
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textAlignment = .left
        $0.text = "sdsdsdsdsdsdsds"
    }
    
    private lazy var optionsButton = UIButton(type: .system).then {
        $0.tintColor = .lightGray
        $0.setImage(UIImage(named: "down_arrow_24pt"), for: .normal)
        $0.addTarget(self, action: #selector(showActionSheet), for: .touchUpInside)
    }
    
    private let retweetsLabel = UILabel()
    
    private let likesLabel = UILabel()
    
    private lazy var statsStackView = UIStackView(arrangedSubviews: [retweetsLabel, likesLabel]).then {
        $0.axis = .horizontal
        $0.spacing = 12
    }
    
    private lazy var statsView = UIView().then {
        let devider1 = UIView()
        devider1.backgroundColor = .systemGroupedBackground
        $0.addSubview(devider1)
        devider1.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(8)
            $0.height.equalTo(1)
        }
        $0.addSubview(statsStackView)
        statsStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(16)
        }
        let devider2 = UIView()
        devider2.backgroundColor = .systemGroupedBackground
        $0.addSubview(devider2)
        devider2.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(8)
            $0.height.equalTo(1)
        }
    }
    
    private lazy var commentButton = createButton(withImageName: "comment").then {
        $0.addTarget(self, action: #selector(handleCommentTapped), for: .touchUpInside)
    }
    
    private lazy var retweetButton = createButton(withImageName: "retweet").then {
        $0.addTarget(self, action: #selector(handleRetweetTapped), for: .touchUpInside)
    }
    
    private lazy var likeButton = createButton(withImageName: "like").then {
        $0.addTarget(self, action: #selector(handleLikeTapped), for: .touchUpInside)
    }
    
    private lazy var shareButton = createButton(withImageName: "share").then {
        $0.addTarget(self, action: #selector(handleShareTapped), for: .touchUpInside)
    }
    
    private lazy var actionStack = UIStackView(arrangedSubviews: [commentButton, retweetButton, likeButton, shareButton]).then {
        $0.spacing = 72
    }
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        
        addSubview(profileStackView)
        profileStackView.snp.makeConstraints {
            $0.leading.top.equalToSuperview().inset(16)
        }
        
        addSubview(captionLabel)
        captionLabel.snp.makeConstraints {
            $0.top.equalTo(profileStackView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        addSubview(dateLabel)
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(captionLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().inset(16)
        }
        
        addSubview(optionsButton)
        optionsButton.snp.makeConstraints {
            $0.centerY.equalTo(profileStackView)
            $0.trailing.equalToSuperview().inset(8)
        }
        
        addSubview(statsView)
        statsView.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(40)
        }
        
        addSubview(actionStack)
        actionStack.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(12)
//            $0.top.equalTo(statsView.snp.bottom).offset(16)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc func handleProfileImageTapped() {
        
    }
    
    @objc func showActionSheet() {
        
    }
    
    @objc func handleCommentTapped() {
        
    }
    
    @objc func handleRetweetTapped() {
        
    }
    
    @objc func handleLikeTapped() {
        
    }
    
    @objc func handleShareTapped() {
        
    }
    
    // MARK: - Helpers
    
    func createButton(withImageName imageName: String) -> UIButton {
        let button = UIButton(type: .system).then {
            $0.setImage(UIImage(named: imageName), for: .normal)
            $0.tintColor = .darkGray
            $0.setDimensions(width: 20, height: 20)
        }
        return button
    }
    
    func configure() {
        guard let tweet = tweet else { return }
        
        let viewModel = TweetViewModel(tweet: tweet)
        
        captionLabel.text = tweet.caption
        fullnameLabel.text = tweet.user.fullname
        usernameLabel.text = viewModel.usernameText
        profileImageView.kf.setImage(with: viewModel.profileImageUrl)
        dateLabel.text = viewModel.headerTimestamp
        retweetsLabel.attributedText = viewModel.retweetString
        likesLabel.attributedText = viewModel.likesString
    }
}

