//
//  ProfileHeaderViewModel.swifr.swift
//  ProjectBuddies
//
//  Created by Dominik Strama on 16/03/2021.
//

import UIKit

struct ProfileHeaderViewModel {
    let user: User
    
    var fullname: String {
        return user.fullname
    }
    
    var profileImageUrl: URL? {
        return URL(string: user.profileImageUrl)
    }
    
    var buttonText: String {
        if user.isCurrentUser {
            return "Edit Profile"
        }
        return "Message"
    }
    
    var buttonTextColor: UIColor {
        if user.isCurrentUser {
            return K.Color.white
        }
        return K.Color.white
    }
    
    var buttonBackgroundColor: UIColor {
        if user.isCurrentUser {
            return K.Color.navyApp
        }
        return K.Color.blueApp
    }

    var aboutme: String {
        return user.aboutme
    }
    
    init(user: User) {
        self.user = user
    }
    
}
