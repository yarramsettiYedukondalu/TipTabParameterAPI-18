//
//  HomeViewController.swift
//  TipTap
//
//  Created by sriram on 04/11/23.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var sideMenuBtn: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()

        sideMenuBtn.target = revealViewController()
                sideMenuBtn.action = #selector(revealViewController()?.revealSideMenu)
    }

}
