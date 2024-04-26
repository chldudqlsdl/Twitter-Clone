//
//  UploadTweetController.swift
//  TwitterTutorial
//
//  Created by Youngbin Choi on 4/14/24.
//

import Foundation
import UIKit
import Then
import Kingfisher

class UploadTweetController: UIViewController {
    
    // MARK: - Properties
    private let user: User
    private let config: UploadTweetConfiguration
    private lazy var viewModel = UploadTweetViewModel(config: config)
    
    private lazy var actionButton = UIButton(type: .system).then {
        $0.backgroundColor = .twitterBlue
        $0.titleLabel?.textAlignment = .center
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        $0.setTitleColor(.white, for: .normal)
        $0.frame = CGRect(x: 0, y: 0, width: 64, height: 32)
        $0.layer.cornerRadius = 32 / 2
        $0.layer.masksToBounds = true
        $0.addTarget(self, action: #selector(handleUploadTweet), for: .touchUpInside)
    }
    
    private let profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.setDimensions(width: 48, height: 48)
        $0.layer.cornerRadius = 48 / 2
        $0.backgroundColor = .twitterBlue
    }
    
    private let replyLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textColor = .lightGray
    }
    
    private let captionTextView = CaptionTextView()
    
    private lazy var imageCaptionStack = UIStackView().then {
        $0.addArrangedSubview(profileImageView)
        $0.addArrangedSubview(captionTextView)
        $0.axis = .horizontal
        $0.spacing = 12
        $0.alignment = .top
    }
    
    private lazy var stackView = UIStackView().then {
        $0.addArrangedSubview(replyLabel)
        $0.addArrangedSubview(imageCaptionStack)
        $0.axis = .vertical
        $0.spacing = 12
    }
    
    // MARK: - LifeCycle
    init(user: User, config: UploadTweetConfiguration) {
        self.user = user
        self.config = config
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    deinit {
        print("UploadTweetController deinit")
    }
    
    // MARK: - Selectors
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleUploadTweet() {
        guard let caption = captionTextView.text else { return }
        TweetService.shared.uploadTweet(caption: caption, type: config) { error, ref in
            if let error = error {
                print("DEBUG: Failed to upload tweet with \(error.localizedDescription)")
                return
            }
            if case .reply(let tweet) = self.config {
                NotificationService.shared.uploadNotification(type: .reply, tweet: tweet)
            }
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - API
    
    // MARK: - Helpers
    
    func configureUI() {

        view.backgroundColor = .systemBackground
        configureNavigtionBar()
        
        view.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        profileImageView.kf.setImage(with: user.profileImageUrl)
        
        actionButton.setTitle(viewModel.actionButtonTitle, for: .normal)
        captionTextView.placeholderLabel.text = viewModel.placeholderText
        replyLabel.isHidden = !viewModel.shouldShowReplyLabel
        guard let replyText = viewModel.replyText else { return }
        replyLabel.text = replyText
    }
    
    func configureNavigtionBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: actionButton)
    }
}
