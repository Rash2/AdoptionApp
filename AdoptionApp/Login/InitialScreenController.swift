//
//  InitialScreenController.swift
//  AdoptionApp
//
//  Created by user169231 on 5/6/20.
//  Copyright © 2020 user169231. All rights reserved.
//

import UIKit

class InitialScreenController: UIViewController {
    
    @IBOutlet weak var AppTitle: UILabel!
    @IBOutlet weak var logo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape {
            logo.isHidden = true
        } else {
            logo.isHidden = false
        }
        
    }
    
}
