//
//  MbProgressHUd.swift
//  TipTap
//
//  Created by ToqSoft on 09/05/24.
//

import Foundation
import MBProgressHUD
extension UIViewController {
    
    func showHUD() {
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.label.text = "Loading"
    }
    
    func hideHUD() {
        MBProgressHUD.hide(for: view, animated: true)
    }
    
}
