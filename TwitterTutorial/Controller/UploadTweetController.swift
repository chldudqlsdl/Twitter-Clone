//
//  UploadTweetController.swift
//  TwitterTutorial
//
//  Created by Youngbin Choi on 4/14/24.
//

import Foundation
import UIKit
import Then

class UploadTweetController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var actionButton = UIButton(type: .system).then {
        $0.backgroundColor = .twitterBlue
        $0.setTitle("Tweet", for: .normal)
        $0.titleLabel?.textAlignment = .center
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        $0.setTitleColor(.white, for: .normal)
        $0.frame = CGRect(x: 0, y: 0, width: 64, height: 32)
        $0.layer.cornerRadius = 32 / 2
        $0.layer.masksToBounds = true
        $0.addTarget(self, action: #selector(handleUploadTweet), for: .touchUpInside)
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Selectors
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleUploadTweet() {
        print("I'm handleUploadTweet")
    }
    
    // MARK: - API
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .systemBackground
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: actionButton)
    }
}


