//
//  Constants.swift
//  ProjectBuddies
//
//  Created by Dominik Strama on 07/03/2021.
//
import UIKit
import Firebase

struct K {
    
    struct Color {
        static let white = UIColor.white
        static let black = UIColor.black
        static let blue = UIColor.blue
        static let red = UIColor.red
        static let gray = UIColor.gray
        static let clear = UIColor.clear
        static let lightWhite = UIColor(white: 1, alpha: 0.1)
        static let lightBlack = UIColor.black.withAlphaComponent(0.1)
        static let veryLightGray = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.00)
    }
    
    struct Font {
        static let regularName = "Helvetica Neue"
        static let boldName = "Helvetica Neue Bold"
        static let tiny = UIFont(name: regularName, size: FontSize.tiny)
        static let small = UIFont(name: regularName, size: FontSize.small)
        static let regular = UIFont(name: regularName, size: FontSize.regular)
        static let large = UIFont(name: regularName, size: FontSize.large)
        static let smallBold = UIFont(name: boldName, size: FontSize.small)
        static let regularBold = UIFont(name: boldName, size: FontSize.regular)
        static let largeBold = UIFont(name: boldName, size: FontSize.large)
    }
    
    struct FontSize {
        static let tiny: CGFloat = 12
        static let small: CGFloat = 14
        static let regular: CGFloat = 16
        static let large: CGFloat = 18
    }
    
    struct FStore {
        static let COLLECTION_USERS = Firestore.firestore().collection("users")
        static let COLLECTION_ROOMS = Firestore.firestore().collection("rooms")
        static let COLLECTION_GROPUS = Firestore.firestore().collection("grups")
    }
}
