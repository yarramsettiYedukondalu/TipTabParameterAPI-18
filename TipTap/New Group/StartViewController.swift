//
//  StartViewController.swift
//  TipTap
//
//  Created by sriram on 03/11/23.
//
import UIKit
import AVFoundation

import UIKit
import AVFoundation
 
class StartViewController: UIViewController {
    
    @IBOutlet weak var arrowImage: UIImageView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        image.image = UIImage(named: "logo")
 
               // Add a tap gesture recognizer to trigger the animation
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
             image.addGestureRecognizer(tapGesture)
             image.isUserInteractionEnabled = true
 
             // Start continuous animation
             startContinuousAnimation()
         }
 
         @objc func handleTap(_ sender: UITapGestureRecognizer) {
             // Stop the continuous animation when tapped
             stopContinuousAnimation()
             
             // Scale up with small increments
             UIView.animate(withDuration: 0.5, animations: {
                 self.image.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
             }) { (_) in
                 // After scaling up, scale down
                 UIView.animate(withDuration: 0.5) {
                     self.image.transform = CGAffineTransform.identity
                     
                     // Resume continuous animation after completing the tap animation
                     self.startContinuousAnimation()
                 }
             }
         }
 
         func startContinuousAnimation() {
             UIView.animate(withDuration: 0.5, animations: {
                 self.image.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
             }) { (_) in
                 // After scaling up, scale down
                 UIView.animate(withDuration: 0.5, animations: {
                     self.image.transform = CGAffineTransform.identity
                 }) { (_) in
                     // Call the function recursively for a continuous loop
                     self.startContinuousAnimation()
                 }
             }
         }
 
         func stopContinuousAnimation() {
             // Stop any ongoing animations
             image.layer.removeAllAnimations()
         }
  
    
    
    @IBAction func startButtonAction(_ sender: UIButton) {
        
        let controller = storyboard?.instantiateViewController(identifier: "TipTapViewController") as! TipTapViewController
        controller.modalPresentationStyle = .fullScreen
        controller.modalTransitionStyle = .coverVertical
        self.present(controller, animated: true, completion: nil)
        
//        let controller = storyboard?.instantiateViewController(identifier: "AppleLoginViewController") as! AppleLoginViewController
//        controller.modalPresentationStyle = .fullScreen
//        controller.modalTransitionStyle = .coverVertical
//        self.present(controller, animated: true, completion: nil)
        
    }
    
}
 
