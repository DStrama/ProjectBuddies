//
//  ExperienceViewModel.swift
//  ProjectBuddies
//
//  Created by Dominik Strama on 18/03/2021.
//

import Foundation

struct ExperienceViewModel {
    
    private let experience: Experience
    
    var name: String? {
        return experience.title
    }
    
    var company: String? {
        return experience.company
    }
    
    var description: String? {
        return experience.description
    }
    
    var id: String? {
        return experience.experienceId
    }
    
    init(experience: Experience) {
        self.experience = experience
    }
}
