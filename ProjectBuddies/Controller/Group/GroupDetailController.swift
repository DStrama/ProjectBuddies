//
//  GroupDetailController.swift
//  ProjectBuddies
//
//  Created by Dominik Strama on 02/04/2021.
//

import UIKit

class GroupDetailController: UIViewController {
    
    var group: Group
    
    init(group: Group) {
        self.group = group
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }

}
