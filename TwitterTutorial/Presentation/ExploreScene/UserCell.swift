//
//  UserCell.swift
//  TwitterTutorial
//
//  Created by Youngbin Choi on 4/20/24.
//

import Foundation
import UIKit

class UserCell: UITableViewCell {
    
    // MARK: - Properties
    var user: User? {
        didSet { configure() }
    }
    
    private lazy var profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.setDimensions(width: 40, height: 40)
        $0.layer.cornerRadius = 40 / 2
        $0.backgroundColor = .twitterBlue
    }
    
    private let usernameLabel = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 14)
        $0.text = "Username"
    }
    
    private let fullNameLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.text = "Fullname"
    }
    
    private lazy var labelStackView = UIStackView().then {
        $0.addArrangedSubview(usernameLabel)
        $0.addArrangedSubview(fullNameLabel)
        $0.axis = .vertical
        $0.spacing = 2
        
    }
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .systemBackground
        
        addSubview(profileImageView)
        profileImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(12)
        }
        
        addSubview(labelStackView)
        labelStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(profileImageView.snp.trailing).offset(12)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    func configure() {
        profileImageView.kf.setImage(with: user?.profileImageUrl)
        usernameLabel.text = user?.username
        fullNameLabel.text = user?.fullname
    }
}
