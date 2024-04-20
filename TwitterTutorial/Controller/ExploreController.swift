//
//  ExploreController.swift
//  TwitterTutorial
//
//  Created by Youngbin Choi on 4/10/24.
//

import UIKit

private let reuserIdentifier = "UserCell"

class ExploreController: UITableViewController {

    // MARK: - Properties
    
    
    // MARK: - LifeCycles

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchUsers()
    }
    
    // MARK: - API
    
    func fetchUsers() {
        UserService.shared.fetchUser { user in
        }
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "Explore"
        
        tableView.register(UserCell.self, forCellReuseIdentifier: reuserIdentifier)
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
    }
    
}

extension ExploreController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuserIdentifier, for: indexPath) as! UserCell
        return cell
    }
}
