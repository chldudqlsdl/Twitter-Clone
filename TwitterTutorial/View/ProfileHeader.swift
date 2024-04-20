//
//  ProfileHeader.swift
//  TwitterTutorial
//
//  Created by Youngbin Choi on 4/19/24.
//

import Foundation
import UIKit
import Then
import SnapKit

protocol ProfileHeaderDelegate: AnyObject {
    func handleDismissal()
}

class ProfileHeader: UICollectionReusableView {
    
    // MARK: - Properties
    
    var user: User? {
        didSet { configure() }
    }
    
    weak var delegate: ProfileHeaderDelegate?
    
    private let filterBar = ProfileFilterView()
    
    private lazy var containerView = UIView().then {
        $0.backgroundColor = .twitterBlue
    }
    
    private lazy var backButton = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "baseline_arrow_back_white_24dp")!.withRenderingMode(.alwaysOriginal), for: .normal)
        $0.addTarget(self, action: #selector(handledismissal), for: .touchUpInside)
        $0.setDimensions(width: 30, height: 30)
    }
    
    private lazy var profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.setDimensions(width: 80, height: 80)
        $0.layer.cornerRadius = 80 / 2
        $0.backgroundColor = .lightGray
        $0.layer.borderWidth = 4
        $0.layer.borderColor = UIColor.systemBackground.cgColor
    }
    
    private lazy var editProfileFollowButton = UIButton(type: .system).then {
        $0.setTitle("Loading", for: .normal)
        $0.setTitleColor(UIColor.twitterBlue, for: .normal)
        $0.layer.borderColor = UIColor.twitterBlue.cgColor
        $0.layer.borderWidth = 1.25
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        $0.setDimensions(width: 100, height: 36)
        $0.layer.cornerRadius = 36 / 2
        $0.clipsToBounds = true
        $0.addTarget(self, action: #selector(handleEditProfileFollow), for: .touchUpInside)
    }
    
    private let fullnameLabel = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 20)
    }
    
    private let usernameLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 16)
        $0.textColor = .lightGray
    }
    
    private let bioLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 16)
        $0.numberOfLines = 3
        $0.text = "I am a non-flying witch"
    }
    
    private lazy var labelStackView = UIStackView().then {
        $0.addArrangedSubview(fullnameLabel)
        $0.addArrangedSubview(usernameLabel)
        $0.addArrangedSubview(bioLabel)
        $0.axis = .vertical
        $0.distribution = .fillProportionally
        $0.spacing = 4
    }
    
    private let underlineView = UIView().then {
        $0.backgroundColor = .twitterBlue
    }
    
    private lazy var followingLabel = UILabel().then {
        let followTap = UITapGestureRecognizer(target: self, action: #selector(handleFollowingTapped))
        $0.addGestureRecognizer(followTap)
        $0.isUserInteractionEnabled = true
        $0.text = "0 Following"
    }
    
    private lazy var followersLabel = UILabel().then {
        let followTap = UITapGestureRecognizer(target: self, action: #selector(handleFollowersTapped))
        $0.addGestureRecognizer(followTap)
        $0.isUserInteractionEnabled = true
        $0.text = "0 Followers"
    }
    
    private lazy var followStackView = UIStackView().then {
        $0.addArrangedSubview(followingLabel)
        $0.addArrangedSubview(followersLabel)
        $0.axis = .horizontal
        $0.spacing = 8
        $0.distribution = .fillEqually
    }
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        filterBar.delegate = self
        
        addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview()
            $0.height.equalTo(108)
        }
        
        containerView.addSubview(backButton)
        backButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(42)
            $0.leading.equalToSuperview().inset(16)
        }
        
        addSubview(profileImageView)
        profileImageView.snp.makeConstraints {
            $0.top.equalTo(containerView.snp.bottom).offset(-24)
            $0.leading.equalToSuperview().inset(8)
        }
        
        addSubview(editProfileFollowButton)
        editProfileFollowButton.snp.makeConstraints {
            $0.top.equalTo(containerView.snp.bottom).offset(12)
            $0.trailing.equalToSuperview().inset(12)
        }
        
        addSubview(labelStackView)
        labelStackView.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(12)
        }
        
        addSubview(filterBar)
        filterBar.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        addSubview(underlineView)
        underlineView.snp.makeConstraints {
            $0.leading.bottom.equalToSuperview()
            $0.width.equalTo(frame.width / 3)
            $0.height.equalTo(2)
        }
        
        addSubview(followStackView)
        followStackView.snp.makeConstraints {
            $0.top.equalTo(labelStackView.snp.bottom).offset(8)
            $0.leading.equalToSuperview().inset(12)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("ProfileHeader deinit")
    }
    
    // MARK: - Selectors
    @objc func handledismissal() {
        delegate?.handleDismissal()
    }
    @objc func handleEditProfileFollow() {
        
    }
    
    @objc func handleFollowingTapped() {
        
    }
    
    @objc func handleFollowersTapped() {
        
    }
    
    // MARK: - Helpers
    func configure() {
        guard let user = user else { return }
        
        let viewModel = ProfileHeaderViewModel(user: user)
        
        profileImageView.kf.setImage(with: user.profileImageUrl)
        
        editProfileFollowButton.setTitle(viewModel.followButtonTitle, for: .normal)
        followingLabel.attributedText = viewModel.followingString
        followersLabel.attributedText = viewModel.followersString
        
        fullnameLabel.text = user.fullname
        usernameLabel.text = "@\(user.username)"
    }
}

extension ProfileHeader: ProfileFilterViewDelegate {
    func filterView(_ view: ProfileFilterView, didSelect indexPath: IndexPath) {
        guard let cell = view.collectionView.cellForItem(at: indexPath) as? ProfileFilterCell else { return }
        let xposition = cell.frame.origin.x
        UIView.animate(withDuration: 0.3) {
            self.underlineView.frame.origin.x = xposition
        }
    }
}
