//
//  TweetCell.swift
//  TwitterTutorial
//
//  Created by Youngbin Choi on 4/18/24.
//

import Foundation
import UIKit
import Kingfisher

protocol TweetCellDelegate: AnyObject {
    func handleProfileImageTapped(_ cell: TweetCell)
    func handleCommentTapped(_ cell: TweetCell)
    func handleLikeTapped(_ cell: TweetCell, _ indexPath: IndexPath?)
}

class TweetCell : UICollectionViewCell {
    
    // MARK: - Properties
    
    var tweet: Tweet? {
        didSet { configure() }
    }
    
    var indexPath: IndexPath?
    
    weak var delegate: TweetCellDelegate?
    
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
    
    private let captionLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.numberOfLines = 0
    }
    
    private let infoLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14)
    }
    
    private lazy var stackLabelView = UIStackView().then {
        $0.addArrangedSubview(infoLabel)
        $0.addArrangedSubview(captionLabel)
        $0.axis = .vertical
        $0.distribution = .fillProportionally
        $0.spacing = 4
    }
    
    private lazy var commentButton = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "comment"), for: .normal)
        $0.tintColor = .darkGray
        $0.setDimensions(width: 20, height: 20)
        $0.addTarget(self, action: #selector(handleCommentTapped), for: .touchUpInside)
    }
    private lazy var retweetButton = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "retweet"), for: .normal)
        $0.tintColor = .darkGray
        $0.setDimensions(width: 20, height: 20)
        $0.addTarget(self, action: #selector(handleRetweetTapped), for: .touchUpInside)
    }
    private lazy var likeButton = UIButton(type: .system).then {
        $0.setDimensions(width: 20, height: 20)
        $0.addTarget(self, action: #selector(handleLikeTapped), for: .touchUpInside)
    }
    private lazy var shareButton = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "share"), for: .normal)
        $0.tintColor = .darkGray
        $0.setDimensions(width: 20, height: 20)
        $0.addTarget(self, action: #selector(handleShareTapped), for: .touchUpInside)
    }
    
    private lazy var stackButtonView = UIStackView().then {
        $0.addArrangedSubview(commentButton)
        $0.addArrangedSubview(retweetButton)
        $0.addArrangedSubview(likeButton)
        $0.addArrangedSubview(shareButton)
        $0.axis = .horizontal
        $0.spacing = 72
    }
    
    private let underLineView = UIView().then {
        $0.backgroundColor = .systemGroupedBackground
    }
    
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
                
        addSubview(profileImageView)
        profileImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.leading.equalToSuperview().inset(8)
        }
        
        addSubview(stackLabelView)
        stackLabelView.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.top)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(12)
            $0.trailing.equalToSuperview().inset(12)
        }
        addSubview(stackButtonView)
        stackButtonView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(8)
            $0.centerX.equalToSuperview()
        }
        
        addSubview(underLineView)
        underLineView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc func handleCommentTapped() {
        delegate?.handleCommentTapped(self)
    }
    @objc func handleRetweetTapped() {
        
    }
    @objc func handleLikeTapped() {
        delegate?.handleLikeTapped(self, self.indexPath)
    }
    @objc func handleShareTapped() {
        
    }
    @objc func handleProfileImageTapped() {
        delegate?.handleProfileImageTapped(self)
    }
    
    
    // MARK: - Helpers
    func configure() {
        guard let tweet = tweet else { return }
        let viewModel = TweetViewModel(tweet: tweet)
        
        captionLabel.text = tweet.caption
        profileImageView.kf.setImage(with: viewModel.profileImageUrl)
        infoLabel.attributedText = viewModel.userInfoText
        likeButton.tintColor = viewModel.likeButtonTintColor
        likeButton.setImage(viewModel.likeButtonImage, for: .normal)
    }
}



