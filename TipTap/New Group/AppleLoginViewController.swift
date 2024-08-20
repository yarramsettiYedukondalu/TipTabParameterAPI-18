//
//  AppleLoginViewController.swift
//  TipTap
//
//  Created by yarramsetti yedukondalu on 20/11/23.
//

import UIKit
import AuthenticationServices
class AppleLoginViewController: UIViewController  ,ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding{
    
    @IBOutlet weak var loginView: UIView!
    override func viewDidLoad() {
        setupSignInWithAppleButton()
        
        
    }
    
    func setupSignInWithAppleButton() {
        let button = ASAuthorizationAppleIDButton()
        button.addTarget(self, action: #selector(handleSignInWithAppleButtonPress), for: .touchUpInside)

        // Add the button to your view
        loginView.addSubview(button)

      //   Set constraints as needed
         button.translatesAutoresizingMaskIntoConstraints = false
         NSLayoutConstraint.activate([
             button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
             button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
         ])
    }
    
    @objc func handleSignInWithAppleButtonPress() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]

        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }

    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            // User signed in with Apple. You can access the user's information.
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email

            // Now, you can proceed to the next screen or perform any necessary actions.
            // For example, you can pass this information to the next view controller.
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle the error
        print("Sign In with Apple failed: \(error.localizedDescription)")
    }


}
