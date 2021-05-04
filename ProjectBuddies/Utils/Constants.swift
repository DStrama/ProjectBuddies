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
        static let blue = UIColor(red: 0.29, green: 0.77, blue: 0.96, alpha: 1.00)
        static let red = UIColor.red
        static let gray = UIColor.gray
        static let clear = UIColor.clear
        static let lightWhite = UIColor(white: 1, alpha: 0.1)
        static let lightBlack = UIColor.black.withAlphaComponent(0.1)
        static let veryLightGray = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.00)
        static let creme = UIColor(red: 0.88, green: 0.85, blue: 0.82, alpha: 1.00)
        static let lighterCreme = UIColor(red: 0.97, green: 0.96, blue: 0.95, alpha: 1.00)
        static let brown = UIColor(red: 0.45, green: 0.43, blue: 0.39, alpha: 1.00)
        static let lightGray = UIColor.lightGray
        static let searchBarGray = UIColor(red: 0.91, green: 0.90, blue: 0.89, alpha: 1.00)
        static let mindApp = UIColor(red: 0.49, green: 0.89, blue: 0.98, alpha: 1.00)
        static let blueApp = UIColor(red: 0.27, green: 0.55, blue: 0.98, alpha: 1.00)
        static let navyApp = UIColor(red: 0.00, green: 0.16, blue: 0.30, alpha: 1.00)
        static let grayApp = UIColor(red: 0.41, green: 0.43, blue: 0.45, alpha: 1.00)
        static let blackApp = UIColor(red: 0.18, green: 0.18, blue: 0.20, alpha: 1.00)

    }

    struct Font {
        static let regularName = "Helvetica Neue"
        static let boldName = "Helvetica Neue Bold"
        static let tiny = UIFont(name: regularName, size: FontSize.tiny)
        static let tinyBold = UIFont(name: boldName, size: FontSize.tiny)
        static let small = UIFont(name: regularName, size: FontSize.small)
        static let regular = UIFont(name: regularName, size: FontSize.regular)
        static let large = UIFont(name: regularName, size: FontSize.large)
        static let extraLarge = UIFont(name: regularName, size: FontSize.extraLarge)
        static let smallBold = UIFont(name: boldName, size: FontSize.small)
        static let regularBold = UIFont(name: boldName, size: FontSize.regular)
        static let largeBold = UIFont(name: boldName, size: FontSize.large)
        static let extraLargeBold = UIFont(name: boldName, size: FontSize.extraLarge)
        static let header = UIFont(name: boldName, size: FontSize.header)
    }

    struct FontSize {
        static let tiny: CGFloat = 12
        static let small: CGFloat = 14
        static let regular: CGFloat = 16
        static let large: CGFloat = 18
        static let extraLarge: CGFloat = 26
        static let header: CGFloat = 36
    }

    struct FStore {
        static let COLLECTION_USERS = Firestore.firestore().collection("users")
        static let COLLECTION_ROOMS = Firestore.firestore().collection("rooms")
        static let COLLECTION_GROUPS = Firestore.firestore().collection("groups")
        static let COLLECTION_EXPERIENCES = Firestore.firestore().collection("experiences")
        static let COLLECTION_PROJECTS = Firestore.firestore().collection("projects")
        static let COLLECTION_NOTIFICATIONS = Firestore.firestore().collection("notifications")
    }
}
