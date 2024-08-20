//
//  AppDelegate.swift
//  TipTap
//
//  Created by Toqsoft on 27/10/23.
//

import UIKit
import GoogleMaps
import GoogleSignIn

import AuthenticationServices
@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
                           if granted {
                               print("Notification authorization granted")
                           } else {
                               print("Notification authorization denied")
                           }
                       }
        // Override point for customization after application launch.
        GMSServices.provideAPIKey("AIzaSyBOcM01Em7oQbrbojC4BWRkJ_pG7-Vvp3o")
   
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if error != nil || user == nil {
                      // User is not signed in, show the app's signed-out state
                      self.navigateToLogin()
                  } else {
                      // User is signed in, show the app's signed-in state
                      self.navigateToHome()
                  }
        }
        
        
//            let appleIDProvider = ASAuthorizationAppleIDProvider()
//            appleIDProvider.getCredentialState(forUserID: KeychainItem.currentUserIdentifier) { (credentialState, error) in
//                switch credentialState {
//                case .authorized:
//                    break // The Apple ID credential is valid.
//                case .revoked, .notFound:
//                    // The Apple ID credential is either revoked or was not found, so show the sign-in UI.
//                    DispatchQueue.main.async {
//                        self.window?.rootViewController?.showLoginViewController()
//                    }
//                default:
//                    break
//                }
//            }
            return true
        }
       

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
  
    func application(_ app: UIApplication, open url: URL,
              options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
      var handled: Bool

      handled = GIDSignIn.sharedInstance.handle(url)
      if handled {
        return true
      }

      // Handle other custom URL types.

      // If not handled by this app, return false.
      return false
    }
    func navigateToHome() {
           guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
               return
           }

           let storyboard = UIStoryboard(name: "Main", bundle: nil)
           let homeViewController = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! TabBarController

           sceneDelegate.window?.rootViewController = homeViewController
           sceneDelegate.window?.makeKeyAndVisible()
       }

       func navigateToLogin() {
           guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
               return
           }

           let storyboard = UIStoryboard(name: "Main", bundle: nil)
           let loginViewController = storyboard.instantiateViewController(withIdentifier: "GoogleSignInVC") as! GoogleSignInVC

           sceneDelegate.window?.rootViewController = loginViewController
           sceneDelegate.window?.makeKeyAndVisible()
       }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
                // Handle the notification response here, e.g., navigate to a specific view controller
                // Reset the badge count to zero
                UIApplication.shared.applicationIconBadgeNumber = 0
                // Call the completion handler when you're done
                completionHandler()
            } 
}

