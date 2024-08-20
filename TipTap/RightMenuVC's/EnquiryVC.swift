//
//  EnquiryVC.swift
//  TipTap
//
//  Created by sriram on 07/11/23.
//

import UIKit
import SystemConfiguration
class EnquiryVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate,UITextFieldDelegate {
    @IBOutlet weak var designView: UIScrollView!
    
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var enquriyTableView: UITableView!
    @IBOutlet weak var enquiryButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var titlebutton: UIButton!
    @IBOutlet var enquiryTFs: [UITextField]!
    @IBOutlet weak var alertBackView: UIView!
    @IBOutlet weak var imageGif: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var okayBtn: UIButton!
    @IBOutlet weak var enquiryTextView: UITextView!
    
    var internetCheckTimer: Timer?
    var data = ["Pricing", "Maintainance", "Others"]
    var restaurantID : Int?
    var blurEffectView: UIVisualEffectView?
    let userEmail = UserDefaults.standard.string(forKey: "userEmail")
    let userFullName = UserDefaults.standard.string(forKey: "userFullName")
    let userFamilyName = UserDefaults.standard.string(forKey: "userFamilyName")
    var enquiryType : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        showHUD()
        designView?.isHidden = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.designView?.isHidden = false
            self?.hideHUD()
            
            
            // Reload table view after dismissing SVProgressHUD
        }
        enquiryTextView.delegate = self
        enquiryTextView.layer.cornerRadius = 5
        enquiryTextView.layer.borderWidth = 1
        enquiryTextView.layer.borderColor = UIColor.lightGray.cgColor
        backView.layer.cornerRadius = 10
        enquriyTableView.isHidden = true
        enquriyTableView.layer.cornerRadius = 8
        enquriyTableView.layer.borderWidth = 0.5
        enquriyTableView.layer.borderColor = UIColor.lightGray.cgColor
        enquriyTableView.backgroundColor = UIColor.lightGray
        
        submitButton.layer.cornerRadius = 8
        
        enquriyTableView.delegate = self
        enquriyTableView.dataSource = self
        
        alertBackView.isHidden = true
        alertBackView.layer.cornerRadius = 10
        alertBackView.layer.shadowColor = UIColor.darkGray.cgColor
        alertBackView.layer.shadowOpacity = 0.5
        alertBackView.layer.shadowOffset = CGSize(width: 0, height: 0)
        alertBackView.layer.shadowRadius = 4
        blurEffectView?.alpha = 1 // Initially set alpha to 0, making it
        indicator.hidesWhenStopped = true
        internetCheckTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(checkInternet), userInfo: nil, repeats: true)
        internetCheckTimer?.tolerance = 2.0
        if let gifURL = Bundle.main.url(forResource: "animated-green-verified-check-mark-k3et2jz52jyu2v22", withExtension: "GIF"),
           let gifData = try? Data(contentsOf: gifURL),
           let animatedImage = UIImage.animatedImageee(with: gifData) {
            imageGif.image = animatedImage
        }
        
        //        let name = userFullName?.split(separator: " ")
        //        enquiryTFs[0].text = name?.first?.description
        //        enquiryTFs[1].text = name?.last?.description
        //        enquiryTFs[2].text = userEmail
        indicator.hidesWhenStopped = true
        setPlaceholder()
        for textField in enquiryTFs {
            textField.delegate = self
            textField.tintColor = .black
        }
    }
    @objc func checkInternet() {
        if !Reachabilitys.isConnectedToNetwork() {
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
    func setPlaceholder() {
        let placeholderText = "Enter your text here..."
        let attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        enquiryTextView.attributedText = attributedPlaceholder
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Enter your text here..." {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            setPlaceholder()
        }
    }
    
    
    @IBAction func submitBtnAct(_ sender: Any) {
        toggleBlurEffect()
        submitEnquiry()
        
    }
    @IBAction func okayButtonAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func enquiryBtnAct(_ sender: Any) {
        enquriyTableView.isHidden = false
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableView = tableView.dequeueReusableCell(withIdentifier: "enquiryCell", for: indexPath)
        tableView.textLabel?.text = data[indexPath.row]
        return tableView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedText = data[indexPath.row]
        enquiryType = selectedText
        enquiryButton.setTitle(selectedText, for: .normal)
        enquriyTableView.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    func submitEnquiry() {
        // Check for empty text fields and validate email
        guard let firstName = enquiryTFs[0].text, !firstName.isEmpty,
              let lastName = enquiryTFs[1].text, !lastName.isEmpty,
              let emailEQ = enquiryTFs[2].text, !emailEQ.isEmpty, isValidEmail(emailEQ),
              let comment = enquiryTextView.text, !comment.isEmpty,
              let enquiryType = enquiryType, !enquiryType.isEmpty else {
            // Show an alert or handle empty fields as needed
            showAlert(title: "Enquiry", message: "Please fill in all the fields.")
            return
        }
        
        // Construct URL using URLComponents https://appenquiry.azurewebsites.net/api/appUserEnquiry?
        let urlComponents = URLComponents(string: EnquiryURL)!
        
        guard let apiUrl = urlComponents.url else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "POST"
        guard let loginUserID = loginUserID, loginUserID != "" else{return}
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let currentDate = dateFormatter.string(from: Date())
        // Create the request body
        let requestBody: [String: Any] = ["UserID" : loginUserID,
                                          "firstName": firstName,
                                          "lastName": lastName,
                                          "emailEQ": emailEQ,
                                          "enquiryType": enquiryType,
                                          "EnquiryDate": currentDate,
                                          "comment": comment]
        
        do {
            showActivityIndicator() // Show loading indicator
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
            // Your existing response handling code remains the same
            
            // UI updates should be done on the main thread
            DispatchQueue.main.async {
                self.hideActivityIndicator() // Hide loading indicator
                self.alertBackView.isHidden = false
                for textField in self.enquiryTFs {
                    textField.text = ""
                    self.enquiryTextView.text = ""
                    self.enquiryTextView.tintColor = .clear
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    self.hideActivityIndicator()
                    let controller = self.storyboard?.instantiateViewController(identifier: "ResponsePageViewController") as! ResponsePageViewController
                    controller.message = "Enquiry submit successfully"
                    self.present(controller, animated: true)
                }
            }
        }.resume()
    }
    
    
    // Function to hide the activity indicator
    func hideActivityIndicator() {
        indicator.stopAnimating()
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Find the index of the current text field
        if let currentIndex = enquiryTFs.firstIndex(of: textField) {
            // If it's not the last text field, move focus to the next text field
            if currentIndex < enquiryTFs.count - 1 {
                let nextTextField = enquiryTFs[currentIndex + 1]
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
    class func animatedImageee(with gifData: Data) -> UIImage? {
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
public class Reachabilitys {
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


