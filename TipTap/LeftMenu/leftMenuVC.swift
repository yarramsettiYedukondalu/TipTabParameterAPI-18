//
//  leftMenuVC.swift
//  TipTap
//
//  Created by sriram on 04/11/23.
//

import UIKit

class leftMenuVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var arrdata = ["Favourite","Visited","Rewards","Tips","Feedback","Ratings","All Restaurants","All Cuisines","Signature Dishes"]
    var arrimg = ["heart","flag","rewards","sar","feedback","star","heart","heart","heart"]
    @IBOutlet var sideview: UIView!
    
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet var sidebar: UITableView!
    var isSideViewOpen: Bool = false
    var panGesture: UIPanGestureRecognizer!
    var initialX: CGFloat = 0
    override func viewDidLoad() {
        profileButton.layer.cornerRadius = 39
        //profileButton.frame.size.width/2
        profileButton.clipsToBounds = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleOutsideTap(_:)))
        self.view.addGestureRecognizer(tapGestureRecognizer)
        super.viewDidLoad()
        sideview.isHidden = true
        sidebar.backgroundColor = UIColor.groupTableViewBackground
        isSideViewOpen = false
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        sideview.addGestureRecognizer(panGesture)
        NotificationCenter.default.addObserver(self, selector: #selector(deviceOrientationDidChange), name: UIDevice.orientationDidChangeNotification, object: nil)

    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func deviceOrientationDidChange() {
        let currentOrientation = UIDevice.current.orientation
        
        if currentOrientation.isLandscape {
            openSideMenu()
        }
    }
    @objc func handleOutsideTap(_ sender: UITapGestureRecognizer) {
        if isSideViewOpen {
            let location = sender.location(in: self.view)
            if !sideview.frame.contains(location) {
                closeSideMenu()
            }
        }
    }
    
    @IBOutlet weak var menubutton: UIBarButtonItem!
    func openSideMenu() {
        sidebar.isHidden = false
        sideview.isHidden = false
        self.view.bringSubviewToFront(sideview)
        
        if !isSideViewOpen {
            isSideViewOpen = true
            sideview.frame = CGRect(x: 0, y: 88, width: 0, height: 499)
            sidebar.frame = CGRect(x: 0, y: 0, width: 0, height: 499)
            UIView.setAnimationDuration(0.3)
            UIView.setAnimationDelegate(self)
            UIView.beginAnimations("TableAnimation", context: nil)
            sideview.frame = CGRect(x: 0, y: 88, width: 259, height: 499)
            sidebar.frame = CGRect(x: 0, y: 0, width: 259, height: 499)
            UIView.commitAnimations()
        } else {
            sidebar.isHidden = true
            sideview.isHidden = true
            isSideViewOpen = false
            sideview.frame = CGRect(x: 0, y: 88, width: 259, height: 499)
            sidebar.frame = CGRect(x: 0, y: 0, width: 259, height: 499)
            UIView.setAnimationDuration(0.3)
            UIView.setAnimationDelegate(self)
            UIView.beginAnimations("TableAnimation", context: nil)
            sideview.frame = CGRect(x: 0, y: 88, width: 0, height: 499)
            sidebar.frame = CGRect(x: 0, y: 0, width: 0, height: 499)
            UIView.commitAnimations()
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrdata.count
    }
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
//        //cell.img.image = arrimg[indexPath.row]
////        cell.img.image = UIImage(named: arrimg[indexPath.row])
////        cell.nameLabel.text = arrdata[indexPath.row]
//
//        cell.imageView?.image = UIImage(named: arrimg[indexPath.row])
//        cell.textLabel?.text = arrdata[indexPath.row]
//        return cell
//    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "leftMenuCell")!

        if indexPath.row == 6 {
            // Set no image for index path 7
            cell.imageView?.image = nil
        } else if indexPath.row == 7 || indexPath.row == 8 {
            // Set nil image for index paths 8 and 9
            cell.imageView?.image = nil
        } else {
            // Set a regular image for other index paths
            cell.imageView?.image = UIImage(named: arrimg[indexPath.row])
        }

        cell.textLabel?.text = arrdata[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if indexPath.row == 1 {
//            let uname: unameViewController = self.storyboard?.instantiateViewController(withIdentifier: "uname") as! unameViewController
//            self.navigationController?.pushViewController(uname, animated: true)
//        }
    }
//    @IBAction func btnmenu(_ sender: UIButton) {
//
//        sidebar.isHidden = false
//        sideview.isHidden = false
//        self.view.bringSubview(toFront: sideview)
//        if !isSideViewOpen {
//            isSideViewOpen = true
//            sideview.frame = CGRect(x: 0, y: 88, width: 0, height: 499)
//            sidebar.frame = CGRect(x: 0, y: 0, width: 0, height: 499)
//            UIView.setAnimationDuration(0.3)
//            UIView.setAnimationDelegate(self)
//            UIView.beginAnimations("TableAnimation", context: nil)
//            sideview.frame = CGRect(x: 0, y: 88, width: 259, height: 499)
//            sidebar.frame = CGRect(x: 0, y: 0, width: 259, height: 499)
//            UIView.commitAnimations()
//        } else {
//            sidebar.isHidden = true
//            sideview.isHidden = true
//            isSideViewOpen = false
//            sideview.frame = CGRect(x: 0, y: 88, width: 259, height: 499)
//            sidebar.frame = CGRect(x: 0, y: 0, width: 259, height: 499)
//            UIView.setAnimationDuration(0.3)
//            UIView.setAnimationDelegate(self)
//            UIView.beginAnimations("TableAnimation", context: nil)
//            sideview.frame = CGRect(x: 0, y: 88, width: 0, height: 499)
//            sidebar.frame = CGRect(x: 0, y: 0, width: 0, height: 499)
//            UIView.commitAnimations()
//        }
//    }
    @IBAction func btnmenu(_ sender: UIButton) {
        sidebar.isHidden = false
        sideview.isHidden = false
        self.view.bringSubviewToFront(sideview)
        
        if !isSideViewOpen {
            // If the side menu is not open, open it.
            isSideViewOpen = true
            sideview.frame = CGRect(x: 0, y: 88, width: 0, height: 499)
            sidebar.frame = CGRect(x: 0, y: 0, width: 0, height: 499)
            UIView.setAnimationDuration(0.3)
            UIView.setAnimationDelegate(self)
            UIView.beginAnimations("TableAnimation", context: nil)
            sideview.frame = CGRect(x: 0, y: 88, width: 259, height: 499)
            sidebar.frame = CGRect(x: 0, y: 0, width: 259, height: 499)
            UIView.commitAnimations()
        } else {
            // If the side menu is open, close it.
            sidebar.isHidden = true
            sideview.isHidden = true
            isSideViewOpen = false
            sideview.frame = CGRect(x: 0, y: 88, width: 259, height: 499)
            sidebar.frame = CGRect(x: 0, y: 0, width: 259, height: 499)
            UIView.setAnimationDuration(0.3)
            UIView.setAnimationDelegate(self)
            UIView.beginAnimations("TableAnimation", context: nil)
            sideview.frame = CGRect(x: 0, y: 88, width: 0, height: 499)
            sidebar.frame = CGRect(x: 0, y: 0, width: 0, height: 499)
            UIView.commitAnimations()
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    @objc func handlePan(_ recognizer: UIPanGestureRecognizer) {
        if recognizer.state == .began {
            initialX = sideview.frame.origin.x
        } else if recognizer.state == .changed {
            let translation = recognizer.translation(in: sideview)
            var newX = initialX + translation.x
            newX = min(max(newX, 0), 259)
            sideview.frame.origin.x = newX
        } else if recognizer.state == .ended {
            let velocity = recognizer.velocity(in: sideview)
            if velocity.x < 0 {
                closeSideMenu()
            } else {
                openSideMenu()
            }
        }
    }
    func closeSideMenu() {
        sidebar.isHidden = true
        sideview.isHidden = true
        isSideViewOpen = false
        sideview.frame = CGRect(x: 0, y: 88, width: 259, height: 499)
        sidebar.frame = CGRect(x: 0, y: 0, width: 259, height: 499)
        UIView.setAnimationDuration(0.3)
        UIView.setAnimationDelegate(self)
        UIView.beginAnimations("TableAnimation", context: nil)
        sideview.frame = CGRect(x: 0, y: 88, width: 0, height: 499)
        sidebar.frame = CGRect(x: 0, y: 0, width: 0, height: 499)
        UIView.commitAnimations()
    }
    
}


