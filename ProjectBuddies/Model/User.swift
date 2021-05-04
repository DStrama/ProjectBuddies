//
//  User.swift
//  ProjectBuddies
//
//  Created by Dominik Strama on 08/03/2021.
//

import Firebase

struct User {
    let email: String
    let fullname: String
    let aboutme: String
    var profileImageUrl: String
    let username: String
    let uid: String
    var rooms: [String]
    var hobbies: [String]
    var softskills: [String]
    var hardskills: [String]
    
    var isCurrentUser: Bool { return Auth.auth().currentUser?.uid == uid}
    
    init(dictionary: [String: Any]) {
        self.email = dictionary["email"] as? String ?? ""
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        self.rooms = dictionary["rooms"]  as? [String] ?? []
        self.aboutme = dictionary["aboutme"]  as? String ?? ""
        self.hobbies = dictionary["hobbies"] as? [String] ?? []
        self.hardskills = dictionary["hardskills"] as? [String] ?? []
        self.softskills = dictionary["softskills"] as? [String] ?? []
    }
}
