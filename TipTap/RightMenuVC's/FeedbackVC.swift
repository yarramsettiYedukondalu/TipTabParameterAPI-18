//
//  FeedbackVC.swift
//  TipTap
//
//  Created by sriram on 08/11/23.
//


import UIKit
import SystemConfiguration
class FeedbackVC: UIViewController ,UITextFieldDelegate{
    @IBOutlet weak var indicater: UIActivityIndicatorView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var insideView: UIView!
    @IBOutlet var questionLabels: [UILabel]!
    @IBOutlet var answerTFs: [UITextField]!
    @IBOutlet weak var titleButton: UIButton!
    @IBOutlet weak var alertBackView: UIView!
    @IBOutlet weak var imageGif: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var okayBtn: UIButton!
    
    var blurEffectView: UIVisualEffectView?
    var internetCheckTimer: Timer?
    
    @IBOutlet weak var designView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        showHUD()
        designView?.isHidden = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.designView?.isHidden = false
            self?.hideHUD()
            
            
            // Reload table view after dismissing SVProgressHUD
        }
        
        
        
        
        
        
        setupUI()
        indicater.hidesWhenStopped = true
        for textField in answerTFs {
            textField.delegate = self
            textField.tintColor = .black
        }
        blurEffectView?.alpha = 0 // Initially set alpha to 0, making it
        
        internetCheckTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(checkInternet), userInfo: nil, repeats: true)
        internetCheckTimer?.tolerance = 2.0
    }
    
    @objc func checkInternet() {
        if !Reachability.isConnectedToNetwork() {
            internetCheckTimer?.invalidate()
            redirectToResponsePage()
        }
    }
    
    func redirectToResponsePage() {
        // Implement the logic to navigate to the response page
        let controller = self.storyboard?.instantiateViewController(identifier: "InternetViewController") as! InternetViewController
        controller.message = "No Internet Connection"
        self.present(controller, animated: true)
    }
    
    func toggleBlurEffect() {
        UIView.animate(withDuration: 0.3) {
            // Toggle the alpha of the insideView
            self.insideView.alpha = (self.insideView.alpha == 1.0) ? 0.5 : 1.0 // Adjust alpha as needed
        }
    }
    
    
    
    func toggleOpacity() {
        UIView.animate(withDuration: 0.3) {
            // Toggle the alpha of the insideView
            self.insideView.alpha = (self.insideView.alpha == 1.0) ? 0.5 : 1.0 // Adjust alpha as needed
        }
    }
    func showActivityIndicator() {
        indicater.isHidden = false
        indicater.startAnimating()
        
    }
    
    // Function to hide the activity indicator
    func hideActivityIndicator() {
        indicater.stopAnimating()
        
    }
    func setupUI() {
        insideView.layer.cornerRadius = 10
        backView.layer.cornerRadius = 10
        submitButton.layer.cornerRadius = 8
        
        alertBackView.isHidden = true
        alertBackView.layer.cornerRadius = 10
        alertBackView.layer.shadowColor = UIColor.darkGray.cgColor
        alertBackView.layer.shadowOpacity = 0.5
        alertBackView.layer.shadowOffset = CGSize(width: 0, height: 0)
        alertBackView.layer.shadowRadius = 4
        
        if let gifURL = Bundle.main.url(forResource: "animated-green-verified-check-mark-k3et2jz52jyu2v22", withExtension: "GIF"),
           let gifData = try? Data(contentsOf: gifURL),
           let animatedImage = UIImage.animatedImagee(with: gifData) {
            imageGif.image = animatedImage
        }
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func okayBttonAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @IBAction func submitBtnAct(_ sender: Any) {
        submitFeedback { success in
            if success {
                print("Feedback submitted successfully.")
                NotificationCenter.default.post(name: Notification.Name("FeedbackSubmitActionNotification"), object: nil)
                //                DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                //                   // self?.dismiss(animated: true)
                //                }
            } else {
                print("Feedback submission failed.")
            }
        }
    }
    
    func submitFeedback(completion: @escaping (Bool) -> Void) {
        // Check for internet connection
        guard Reachability.isConnectedToNetwork() else {
            showAlert(title: "No Internet", message: "Please check your internet connection and try again.")
            completion(false)
            return
        }
        
        guard let oftenuseapp = answerTFs[0].text, !oftenuseapp.isEmpty,
              let motivationtouse = answerTFs[1].text, !motivationtouse.isEmpty,
              let mostusedfeature = answerTFs[2].text, !mostusedfeature.isEmpty,
              let toimprove = answerTFs[3].text, !toimprove.isEmpty else {
            showAlert(title: "Feedback", message: "Please fill in all the fields.")
            completion(false)
            return
        }
        
        let urlString = CompanyFeedbackURL
        guard let apiUrl = URL(string: urlString) else {
            print("Invalid URL: \(urlString)")
            completion(false)
            return
        }
        
        guard let loginUserID = loginUserID, !loginUserID.isEmpty else {
            completion(false)
            return
        }
        
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "POST"
        
        let requestBody: [String: Any] = [
            "UserID": loginUserID,
            "oftenuseapp": oftenuseapp,
            "motivationtouse": motivationtouse,
            "mostusedfeature": mostusedfeature,
            "toimprove": toimprove
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        } catch {
            print("Error encoding request body: \(error)")
            completion(false)
            return
        }
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                completion(false)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Status Code: \(httpResponse.statusCode)")
                
                if httpResponse.statusCode == 200 {
                    print("Feedback submit successfully")
                    DispatchQueue.main.async {
                        self.alertBackView.isHidden = false
                        for textField in self.answerTFs {
                            textField.text = ""
                            textField.tintColor = .clear
                        }
                        let controller = self.storyboard?.instantiateViewController(identifier: "ResponsePageViewController") as! ResponsePageViewController
                        controller.message = "Feedback submit successfully"
                        self.present(controller, animated: true)
                    }
                    completion(true)
                } else {
                    print("HTTP Status Code: \(httpResponse.statusCode)")
                    completion(false)
                }
            }
        }.resume()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Find the index of the current text field
        if let currentIndex = answerTFs.firstIndex(of: textField) {
            // If it's not the last text field, move focus to the next text field
            if currentIndex < answerTFs.count - 1 {
                let nextTextField = answerTFs[currentIndex + 1]
                nextTextField.becomeFirstResponder()
            } else {
                // If it's the last text field, resign the keyboard
                textField.resignFirstResponder()
            }
        }
        
        return true
    }
    
}

extension UIImage {
    class func animatedImagee(with gifData: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(gifData as CFData, nil) else { return nil }
        
        let count = CGImageSourceGetCount(source)
        var images = [UIImage]()
        
        for i in 0..<count {
            if let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) {
                let image = UIImage(cgImage: cgImage)
                images.append(image)
            }
        }
        
        let animatedImage = UIImage.animatedImage(with: images, duration: Double(count) * 0.3) // Adjust duration as needed
        return animatedImage
    }
}

public class Reachability {
    class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return isReachable && !needsConnection
    }
}
