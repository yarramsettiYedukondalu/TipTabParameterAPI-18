//
//  TabBarController.swift
//  TipTap
//
//  Created by ToqSoft on 30/10/23.
//

import UIKit


class TabBarController: UITabBarController {
    
    let middleBtn = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBarIconAnimation()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTabBarIconAnimation()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupTabBarIconAnimation()
        setupCenterButton()
        middleBtn.layer.cornerRadius = middleBtn.frame.size.height / 2
    }
    
    //MARK: Add button
    
    func setupCenterButton() {
        
        middleBtn.translatesAutoresizingMaskIntoConstraints = false
        
        if let originalImage = UIImage(systemName: "qrcode.viewfinder")?.withTintColor(UIColor.white) {
            // Specify the desired size
            let newSize = CGSize(width: 40, height: 40)
            
            // Create a larger image with the specified size
            let resizedImage = originalImage.applyingSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: newSize.width, weight: .regular, scale: .default))
            
            // Set the resized image to the button
            middleBtn.setImage(resizedImage, for: .normal)
            
            // Set the content mode
            middleBtn.imageView?.contentMode = .scaleAspectFit
        } else {
            print("Failed to create a system image")
        }
        
        middleBtn.setTitleColor(.white, for: .normal)
        middleBtn.tintColor = .white
        middleBtn.backgroundColor = UIColor(red: 52/245, green: 78/245, blue: 65/245, alpha: 1)
        
        
        self.tabBar.addSubview(middleBtn) // Add to the tab bar's view hierarchy
        
        NSLayoutConstraint.activate([
            middleBtn.centerXAnchor.constraint(equalTo: self.tabBar.centerXAnchor),
            middleBtn.centerYAnchor.constraint(equalTo: self.tabBar.topAnchor, constant: 20),
            middleBtn.widthAnchor.constraint(equalToConstant: 70),
            middleBtn.heightAnchor.constraint(equalToConstant: 70)
        ])
        
        middleBtn.addTarget(self, action: #selector(self.CenterButtonAction), for: .touchUpInside)
    }
    
    
    //MARK: center button click event
    @objc func CenterButtonAction(sender: UIButton) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "ScannerViewController") as! ScannerViewController
        controller.modalPresentationStyle = .overFullScreen // Ensure this style is used
        self.present(controller, animated: true)
    }

    func setupTabBarIconAnimation() {
        if let tabBarItems = tabBar.items {
            for (index, tabBarItem) in tabBarItems.enumerated() {
                if index == 2 {
                    if let tabImageView = tabBarItem.value(forKey: "view") as? UIView,
                       let imageView = tabImageView.subviews.first as? UIImageView {
                        // Apply animation to the image view
                        let animation = CABasicAnimation(keyPath: "transform.scale")
                        animation.duration = 0.75
                        animation.repeatCount = .infinity
                        animation.autoreverses = true
                        animation.fromValue = 1.0
                        animation.toValue = 1.2
                        let timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
                        animation.timingFunction = timingFunction
                        imageView.layer.add(animation, forKey: "scaleAnimation_\(index)")
                    }
                } else {
                    // If the index is not 2, remove any existing animations
                    if let tabImageView = tabBarItem.value(forKey: "view") as? UIView {
                        tabImageView.layer.removeAllAnimations()
                    }
                }
            }
        }
    }
    
}
