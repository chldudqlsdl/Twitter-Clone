//
//  TestController.swift
//  TwitterTutorial
//
//  Created by Youngbin Choi on 4/22/24.
//

import Foundation
import UIKit

class TestController: UIViewController {
    
    private let searchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
//        configureSearchController()
        definesPresentationContext = true
        
//        let vc = Test2Controller()
//        vc.modalPresentationStyle = .currentContext
//        present(vc, animated: true)
    }
    
    func configureSearchController() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search for a user"
        navigationItem.searchController = searchController
        definesPresentationContext = false
    }
    
}
