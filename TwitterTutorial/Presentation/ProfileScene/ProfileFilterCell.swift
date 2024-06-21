//
//  ProfileFilterCell.swift
//  TwitterTutorial
//
//  Created by Youngbin Choi on 4/19/24.
//

import Foundation
import UIKit
import Then

class ProfileFilterCell: UICollectionViewCell {
    
    // MARK: - Properties
    var option: ProfileFilterOptions! {
        didSet { titleLabel.text = option.description }
    }
    
    
    private let titleLabel = UILabel().then {
        $0.text = "Hello"
        $0.textColor = .lightGray
        $0.font = UIFont.systemFont(ofSize: 14)
    }
    
    override var isSelected: Bool {
        didSet {
            titleLabel.font = isSelected ? UIFont.boldSystemFont(ofSize: 16) : UIFont.systemFont(ofSize: 14)
            titleLabel.textColor = isSelected ? .twitterBlue : .lightGray
        }
    }
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
