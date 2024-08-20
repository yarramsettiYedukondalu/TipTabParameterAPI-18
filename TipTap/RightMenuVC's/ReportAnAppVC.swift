//
//  ReportAnAppVC.swift
//  TipTap
//
//  Created by sriram on 08/11/23.
//


import UIKit
import ImageIO

class ReportAnAppVC: UIViewController, UITextViewDelegate ,UITextFieldDelegate{
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var imageGif: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var okBtn: UIButton!
    @IBOutlet weak var titlebutton: UIButton!
    @IBOutlet weak var insideView: UITextField!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var designView: UIView!
    @IBOutlet var issueTFs: [UITextField]!
    @IBOutlet weak var TellIssueLabel: UILabel!
    
    
    let userEmail = UserDefaults.standard.string(forKey: "userEmail")
    let userFullName = UserDefaults.standard.string(forKey: "userFullName")
    let userFamilyName = UserDefaults.standard.string(forKey: "userFamilyName")
    
    
    
    //network
    var blurEffectView: UIVisualEffectView?
    var internetCheckTimer: Timer?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        showHUD()
        designView?.isHidden = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.designView?.isHidden = false
            self?.hideHUD()
            
            
            // Reload table view after dismissing SVProgressHUD
        }
        
        
        
        
        // setPlaceholder()
        for textField in issueTFs {
            textField.delegate = self
            textField.tintColor = .black
        }
        
        
        indicator.hidesWhenStopped = true
        blurEffectView?.alpha = 0 // Initially set alpha to 0, making it
        indicator.hidesWhenStopped = true
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
            self.backView.alpha = (self.backView.alpha == 1.0) ? 0.5 : 1.0 // Adjust alpha as needed
        }
    }
    
    
    
    func toggleOpacity() {
        UIView.animate(withDuration: 0.3) {
            // Toggle the alpha of the insideView
            self.backView.alpha = (self.backView.alpha == 1.0) ? 0.5 : 1.0 // Adjust alpha as needed
        }
    }
    func showActivityIndicator() {
        indicator.isHidden = false
        indicator.startAnimating()
        
    }
    
    // Function to hide the activity indicator
    func hideActivityIndicator() {
        indicator.stopAnimating()
        
    }
    
    func setupUI() {
        alertView.isHidden = true
        alertView.layer.cornerRadius = 10
        alertView.layer.applyShadow()
        
        if let gifURL = Bundle.main.url(forResource: "animated-green-verified-check-mark-k3et2jz52jyu2v22", withExtension: "GIF"),
           let gifData = try? Data(contentsOf: gifURL),
           let animatedImage = UIImage.animatedImage(with: gifData) {
            imageGif.image = animatedImage
        }
        
        backView.layer.cornerRadius = 10
        submitButton.layer.cornerRadius = 8
        
        insideView.delegate = self
    }
    
    //        func setPlaceholder() {
    //            let placeholderText = "Enter your text here..."
    //            let attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [.foregroundColor: UIColor.lightGray])
    //            insideView.attributedText = attributedPlaceholder
    //        }
    
    
    @IBAction func submitBtnAct(_ sender: Any) {
        toggleBlurEffect()
        submitReport()
    }
    
    //    func textViewDidChange(_ textView: UITextView) {
    //        if textView.text == "Enter your text here..." {
    //            textView.text = ""
    //            textView.textColor = UIColor.black
    //        } else if textView.text.isEmpty {
    //            setPlaceholder()
    //        }
    //    }
    
    
    
    func isValidEmail(email: String) -> Bool {
        // Define the regular expression pattern for email validation
        let emailRegex = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        // Create a regular expression object
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        
        // Test the email against the regular expression
        return emailPredicate.evaluate(with: email)
    }
    
    func submitReport() {
        guard Reachability.isConnectedToNetwork() else {
            showAlert(title: "No Internet", message: "Please check your internet connection and try again.")
            return
        }
        let urlString = userReportURL
        
        guard let apiUrl = URL(string: urlString) else {
            print("Invalid URL: \(urlString)")
            return
        }
        guard let loginUserID = loginUserID, loginUserID != "" else{
            return
        }
        print("Request URL: \(apiUrl)")
        
        // Create the URLRequest
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "POST"
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let currentDate = dateFormatter.string(from: Date())
        
        guard let FirstName = issueTFs[0].text,
              let LastName = issueTFs[1].text,
              let EmailID = issueTFs[2].text,
              let Issue = insideView.text else {
            let controller = self.storyboard?.instantiateViewController(identifier: "InternetViewController") as! InternetViewController
            controller.message = "Report submit successfully"
            self.present(controller, animated: true)
            return
        }
        
        if !isValidEmail(email: EmailID){
            showAlert(title: "Report An APP" , message: "Please enter valid emailid")
        }else if insideView.text == ""{
            showAlert(title: "Report An APP", message: "Please enter enquiry")
        }else if FirstName == "" || LastName == ""{
            showAlert(title: "Report An APP", message: "Please enter First name and Last name")
        }
        else{
            
            let requestBody: [String: Any] = ["FirstName": FirstName, 
                                              "LastName": LastName,
                                              "EmailID": EmailID,
                                              "Issue": Issue,
                                              "ReportDate" : currentDate,
                                              "UserID" : loginUserID
            ]
            
            
            // Convert the request body to JSON data
            do {
                showActivityIndicator()
                request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
            } catch {
                hideActivityIndicator()
                print("Error encoding request body: \(error)")
                return
            }
            
            // Set the request headers
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            print("Request Body: \(String(data: request.httpBody ?? Data(), encoding: .utf8) ?? "")")
            
            // Perform the request
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Error: \(error)")
                    return
                }
                
                // Handle the response
                if let httpResponse = response as? HTTPURLResponse {
                    print("HTTP Status Code: \(httpResponse.statusCode)")
                    
                    if httpResponse.statusCode == 200 {
                        print("Report submit successfully")
                        DispatchQueue.main.sync {
                            self.hideActivityIndicator()
                            self.alertView.isHidden = false
                            for textField in self.issueTFs {
                                textField.text = ""
                                self.insideView.text = ""
                                self.insideView.tintColor = .clear
                            }
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                            self.hideActivityIndicator()
                            let controller = self.storyboard?.instantiateViewController(identifier: "ResponsePageViewController") as! ResponsePageViewController
                            controller.message = "Report submit successfully"
                            self.present(controller, animated: true)
                        }
                        
                        // You may want to perform additional actions here if needed
                    } else {
                        print("HTTP Status Code: \(httpResponse.statusCode)")
                        
                        // Handle other status codes if needed
                    }
                }
            }.resume()
            
            
        }
    }
    
    
    @IBAction func okBtnAct(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @IBAction func backButtonAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Find the index of the current text field
        if let currentIndex = issueTFs.firstIndex(of: textField) {
            // If it's not the last text field, move focus to the next text field
            if currentIndex < issueTFs.count - 1 {
                let nextTextField = issueTFs[currentIndex + 1]
                nextTextField.becomeFirstResponder()
            } else {
                // If it's the last text field, resign the keyboard
                textField.resignFirstResponder()
            }
        }
        
        return true
    }
}

extension CALayer {
    func applyShadow() {
        shadowColor = UIColor.darkGray.cgColor
        shadowOpacity = 0.5
        shadowOffset = CGSize(width: 0, height: 0)
        shadowRadius = 4
    }
}
extension UIImage {
    class func animatedImage(with gifData: Data) -> UIImage? {
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

extension UIViewController {
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}


