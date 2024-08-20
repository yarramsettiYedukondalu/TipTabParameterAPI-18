//
//  TipTapViewController.swift
//  TipTap
//
//  Created by sriram on 03/11/23.
//

import UIKit
import AVKit

import AuthenticationServices

class TipTapViewController: UIViewController




{
    var videoPlayer:AVPlayer?
    var playerLayer: AVPlayerLayer?
    var videoPlayerLayer:AVPlayerLayer?
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var continueSignInLabel: UILabel!
    @IBOutlet weak var emailPasswordLabel: UILabel!
    @IBOutlet weak var forgotPasswordLabel: UIButton!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var signupBtn: UIButton!
    @IBOutlet weak var emailLabel: UILabel!

    @IBOutlet weak var continueAppleButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    var player: AVPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        continueAppleButton.layer.cornerRadius = 5
        signInButton.layer.cornerRadius = 5
        
        navigationItem.leftBarButtonItem = nil
                let backButton = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
                navigationItem.leftBarButtonItem = backButton
        
        setUI()
      setUpVideo()
        let videoURL = Bundle.main.url(forResource: "WhatsApp Video 2023-10-27 at 15.25.23", withExtension: "mp4")
               
               if let videoURL = videoURL {
                   player = AVPlayer(url: videoURL)
                   playerLayer = AVPlayerLayer(player: player)
                   playerLayer?.videoGravity = .resizeAspectFill
                   playerLayer?.frame = view.bounds
                   
                   if let playerLayer = playerLayer {
                       view.layer.insertSublayer(playerLayer, at: 0)
                   }
                   
                   player?.play()
               } else {
                   print("Error: Video file not found")
               }
           }
           
           override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
               super.viewWillTransition(to: size, with: coordinator)
               
               coordinator.animate(alongsideTransition: { [weak self] _ in
                   self?.playerLayer?.frame = self?.view.bounds ?? CGRect.zero
               }, completion: nil)
           }
           
           override func viewWillDisappear(_ animated: Bool) {
               super.viewWillDisappear(animated)
               NotificationCenter.default.removeObserver(self)
           }
           
    func setUI(){
        welcomeLabel.applyLabelStyle(for: .heading)
        continueSignInLabel.applyLabelStyle(for: .description)
        emailLabel.applyLabelStyle(for: .subheading)
        emailPasswordLabel.applyLabelStyle(for: .subheading)
        forgotPasswordLabel.titleLabel?.applyLabelStyle(for: .description)
        signInButton.titleLabel?.applyLabelStyle(for: .buttonTitle)
        continueAppleButton.titleLabel?.applyLabelStyle(for: .buttonTitle)
        signupBtn.titleLabel?.applyLabelStyle(for: .buttonTitle)
        
    }
    @IBAction func signInaction(_ sender: UIButton) {
        let controller = self.storyboard?.instantiateViewController(identifier: "OtpScreen") as? OtpScreen
        controller!.modalTransitionStyle = .coverVertical
        controller?.modalPresentationStyle = .fullScreen
       self.present(controller!, animated: true)
    }
    
    @IBAction func signUpBtnAct(_ sender: Any) {
        let controller = self.storyboard?.instantiateViewController(identifier: "SignUpVC") as? SignUpVC
        controller!.modalTransitionStyle = .coverVertical
        controller?.modalPresentationStyle = .fullScreen
       self.present(controller!, animated: true)
    }
    
    func setUpVideo() {
        
//        // Get the path to the resource in the bundle
//        let bundlePath = Bundle.main.path(forResource: "WhatsApp Video 2023-10-27 at 15.25.23", ofType: "mp4")
        
        let videoURL = Bundle.main.url(forResource: "WhatsApp Video 2023-10-27 at 15.25.23", withExtension: "mp4")!
        player?.isMuted = true
        let player = AVPlayer(url: videoURL)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspectFill // This will make the video fit the screen
        playerLayer.frame = view.bounds
        view.layer.insertSublayer(playerLayer, at: 0)
        player.play()
         

    }
   

}  

