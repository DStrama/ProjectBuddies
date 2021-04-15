//
//  NotificationViewModel.swift
//  ProjectBuddies
//
//  Created by Dominik Strama on 21/03/2021.
//

import Firebase

struct NotificationViewModel {

    private let notification: Notification

    var groupImageUrl: URL? {
        return URL(string: notification.groupImageUrl ?? "")
    }
    
    var profileImageUrl: URL? {
        return URL(string: notification.profileImageUrl ?? "")
    }

    var type: NotificationType? {
        return notification.type
    }

    var roomId: String? {
        return notification.roomId
    }
    
    var id: String? {
        return notification.id
    }
    
    var uid: String? {
        return notification.uid
    }
    
    var time: Timestamp {
        return notification.timestamp
    }
    
    var notificationMessage: NSAttributedString {
        let userName = notification.userName
        let message = notification.type.notificationMessage
        let groupName = notification.groupName
        let roomName = notification.roomName
        
        let attributedText = NSMutableAttributedString(string: userName, attributes: [.font: UIFont.boldSystemFont(ofSize: 10)])
        
        attributedText.append(NSAttributedString(string: message, attributes: [.font: UIFont.systemFont(ofSize: 10)]))
        attributedText.append(NSAttributedString(string: groupName, attributes: [.font: UIFont.boldSystemFont(ofSize: 10)]))
        attributedText.append(NSAttributedString(string: " from room ", attributes: [.font: UIFont.systemFont(ofSize: 10)]))
        attributedText.append(NSAttributedString(string: roomName! + ".", attributes: [.font: UIFont.boldSystemFont(ofSize: 10)]))
        
        return attributedText
    }
    
    var timeMessage: NSAttributedString {
        let time = notification.timestamp.dateValue().timeAgoDisplay()
        let attributedText = NSMutableAttributedString(string: time, attributes: [.font: UIFont.systemFont(ofSize: 7), .foregroundColor: UIColor.lightGray])
        return attributedText
    }

    init(notification: Notification) {
        self.notification = notification
    }
}

extension Date {
    func timeAgoDisplay() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: self, relativeTo: Date())
    }
}
