//
//  SplitViewController.swift
//  NewsReader
//
//  Created by Mahjeed Marrow on 5/6/19.
//  Copyright © 2019 Mahjeed Marrow. All rights reserved.
//

import UIKit

class SplitViewController: UISplitViewController {

    //MARK: set display mode
    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferredDisplayMode = .allVisible
    }
}
