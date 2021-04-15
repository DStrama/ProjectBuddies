//
//  Notification.swift
//  ProjectBuddies
//
//  Created by Dominik Strama on 20/03/2021.
//

import Firebase

enum NotificationType: Int {
    case join
    case message
    
    var notificationMessage: String {
        switch self {
        case .join: return " wants to join group "
        case .message: return " messaged you."
        }
    }
}

struct Notification {
    let uid: String
    var groupId: String?
    var groupImageUrl: String?
    var groupName: String
    var userName: String
    var profileImageUrl: String
    var roomId: String?
    var roomName: String?
    let timestamp: Timestamp
    let type: NotificationType
    let id: String
    
    init(dictionary: [String: Any]) {
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.id = dictionary["id"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        self.groupId = dictionary["groupId"] as? String ?? ""
        self.groupImageUrl = dictionary["groupImageUrl"] as? String ?? ""
        self.groupName = dictionary["groupName"] as? String ?? ""
        self.userName = dictionary["userName"] as? String ?? ""
        self.profileImageUrl = dictionary["uerProfileImageUrl"] as? String ?? ""
        self.roomName = dictionary["roomName"] as? String ?? ""
        self.roomId = dictionary["roomId"] as? String ?? ""
        self.type = NotificationType(rawValue: dictionary["type"] as? Int ?? 0) ?? .join
    }
}
