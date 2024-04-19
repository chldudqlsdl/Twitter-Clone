//
//  TestController.swift
//  TwitterTutorial
//
//  Created by Youngbin Choi on 4/19/24.
//

import Foundation
import UIKit
import Then
import SnapKit

class TestController: UIViewController {
    
    private lazy var button = UIButton().then {
        $0.addTarget(self, action: #selector(handleButton), for: .touchUpInside)
        $0.backgroundColor = .red
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(button)
        button.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.width.height.equalTo(100)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    @objc func handleButton() {
        navigationController?.popViewController(animated: true)
    }
}
