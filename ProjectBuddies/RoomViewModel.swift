//
//  RoomViewModel.swift
//  ProjectBuddies
//
//  Created by Dominik Strama on 17/03/2021.
//

import Foundation

struct RoomViewModel {
    
    private let room: Room
    
    var imageUrl: URL? {
        return URL(string: room.imageUrl)
    }
    
    var name: String? {
        return room.name
    }
    
    var members: Int? {
        return room.members
    }
    
    var groups: Int? {
        return room.groups
    }
    
    init(room: Room) {
        self.room = room
    }
}
