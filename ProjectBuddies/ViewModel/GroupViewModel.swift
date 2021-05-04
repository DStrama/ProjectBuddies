//
//  GroupViewModel.swift
//  ProjectBuddies
//
//  Created by Dominik Strama on 20/03/2021.
//

import Foundation

struct GroupViewModel {
    
    private let group: Group
    
    var imageUrl: URL? {
        return URL(string: group.imageUrl)
    }
    
    var name: String? {
        return group.name
    }
    
    var description: String? {
        return group.description
    }
    
    var targetNumberOfPeople: Int? {
        return group.targetNumberOfPeople
    }
    
    var members: Int? {
        return group.members
    }
    
    init(group: Group) {
        self.group = group
    }
}
