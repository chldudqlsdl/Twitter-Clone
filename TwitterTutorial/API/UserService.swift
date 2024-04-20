//
//  UserService.swift
//  TwitterTutorial
//
//  Created by Youngbin Choi on 4/13/24.
//

import Foundation
import FirebaseAuth

struct UserService {
    static let shared = UserService()
    
    private init() {}
    
    func fetchUser(completion: @escaping (User) -> Void) {
//        var users: [User] = []
//        REF_USERS.observe(.childAdded) { snapshot in
//            let uid = snapshot.key
//            let value = snapshot.value
//        }
    }
    
    func fetchUser(uid: String, completion: @escaping (User) -> Void){
        
        REF_USERS.child(uid).observeSingleEvent(of: .value) { snapshot in
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            
            let user = User(uid: uid, dictionary: dictionary)
            completion(user)
        }
    }
}

