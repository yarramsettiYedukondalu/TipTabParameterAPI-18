//
//  SideMenuViewController.swift
//  TipTap
//
//  Created by sriram on 04/11/23.
//
import UIKit

import Foundation
struct SideMenuModel {
    var icon: UIImage
    var title: String
}


import UIKit

protocol SideMenuViewControllerDelegate {
    func selectedCell(_ row: Int)
}
class SideMenuViewController: UIViewController {
    
    @IBOutlet var headerImageView: UIImageView!
    @IBOutlet var sideMenuTableView: UITableView!
    @IBOutlet var footerLabel: UILabel!
    var delegate: SideMenuViewControllerDelegate?
    var defaultHighlightedCell: Int = 0
    
    var menu: [SideMenuModel] = [
        
        SideMenuModel(icon: UIImage(systemName: "heart")!, title: "Favourite"),
        SideMenuModel(icon: UIImage(systemName: "flag")!, title: "Visited"),
        SideMenuModel(icon: UIImage(systemName: "rosette")!, title: "Rewards"),
        SideMenuModel(icon: UIImage(named: "tip")!, title: "Tips"),
        SideMenuModel(icon: UIImage(systemName: "bubble.left")!, title: "Feedback"),
        SideMenuModel(icon: UIImage(systemName: "star")!, title: "Ratings"),
        SideMenuModel(icon: UIImage(systemName: "fork.knife.circle")!, title: "All Restaurants"),
        SideMenuModel(icon: UIImage(systemName: "cup.and.saucer")!, title: "All Cuisines"),
        SideMenuModel(icon: UIImage(systemName: "frying.pan")!, title: "Signature Dishes")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TableView
        self.sideMenuTableView.delegate = self
        self.sideMenuTableView.dataSource = self
        self.sideMenuTableView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.sideMenuTableView.separatorStyle = .none
        
        // Set Highlighted Cell
        DispatchQueue.main.async {
            let defaultRow = IndexPath(row: self.defaultHighlightedCell, section: 0)
            self.sideMenuTableView.selectRow(at: defaultRow, animated: false, scrollPosition: .none)
        }
        
        // Footer
        self.footerLabel.textColor = UIColor.white
        self.footerLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        self.footerLabel.text = "Version 1.1"
        
        // Register TableView Cell
        self.sideMenuTableView.register(SideMenuCell.nib, forCellReuseIdentifier: SideMenuCell.identifier)
        
        // Update TableView with the data
        self.sideMenuTableView.reloadData()
        
        // Update TableView with the data
      //  self.sideMenuTableView.reloadData()
    }
    @IBAction func DismissButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }
}



// MARK: - UITableViewDelegate

extension SideMenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}

// MARK: - UITableViewDataSource

extension SideMenuViewController: UITableViewDataSource,SideMenuViewControllerDelegate {
    func selectedCell(_ row: Int) {
        print(menu[row])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menu.count
    }
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: SideMenuCell.identifier, for: indexPath) as? SideMenuCell else { fatalError("xib doesn't exist") }
//        
//        cell.iconImageView.image = self.menu[indexPath.row].icon
//        cell.titleLabel.text = self.menu[indexPath.row].title
//        
//        // Highlighted color
//        let myCustomSelectionColorView = UIView()
//        myCustomSelectionColorView.backgroundColor = #colorLiteral(red: 0.6196078431, green: 0.1098039216, blue: 0.2509803922, alpha: 1)
//        cell.selectedBackgroundView = myCustomSelectionColorView
//        return cell
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SideMenuCell.identifier, for: indexPath) as? SideMenuCell else { fatalError("xib doesn't exist") }
        
        cell.iconImageView.image = self.menu[indexPath.row].icon
        cell.titleLabel.text = self.menu[indexPath.row].title
        
        // Highlighted color
        let myCustomSelectionColorView = UIView()
        myCustomSelectionColorView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        cell.selectedBackgroundView = myCustomSelectionColorView
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.selectedCell(indexPath.row)
        // ...
        print(menu[indexPath.row].title + "Clicked")
        
        let controller = storyboard?.instantiateViewController(identifier: "FavoritesVC") as! FavoritesVC
        controller.titleText = menu[indexPath.row].title
        
        controller.modalPresentationStyle = .fullScreen
        controller.modalTransitionStyle = .coverVertical
        self.present(controller, animated: true)
        // Remove highlighted color when you press the 'Profile' and 'Like us on facebook' cell
        if indexPath.row == 4 || indexPath.row == 6 {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
