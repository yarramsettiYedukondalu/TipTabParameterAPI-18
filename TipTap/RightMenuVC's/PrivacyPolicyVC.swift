//
//  PrivacyPolicyVC.swift
//  TipTap
//
//  Created by sriram on 08/11/23.
//

import UIKit

class PrivacyPolicyVC: UIViewController {
    
    @IBOutlet weak var titleButton: UIButton!

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var backButton: UIButton!
    
    
    var policyData = """
 <style>
     h1 { font-size: 24px; }
     h5 { font-size: 20px; }
     p { font-size: 16px; }
     ul { font-size: 16px; }
     li { font-size: 16px; }
   </style>
 <p>Welcome to the Privacy Policy for TipTab. Protecting your privacy and the security of your personal information is a top priority for us. This document explains how we collect, use, and safeguard your data, ensuring your trust and data security.</p>
 <h5>Data Collection</h5>
 <p>We collect various types of information, including personal data such as your name, email address, and location. We also gather usage data and may use cookies to enhance your app experience.</p>
 <h5>Data Usage</h5>
 <p>The data we collect is used to provide app functionality, personalize your experience, and send marketing communications if you opt to receive them. Rest assured that we only use your data for purposes outlined in this policy.</p>
 <h5>Data Protection</h5>
 <p>We take data security seriously and have implemented measures to protect your data from unauthorized access and maintain data integrity.  </p>
 <h5>Data Sharing</h5>
 <p>Your data may be shared with third parties only in specific circumstances, such as for analytics or advertising purposes. We will never sell your personal information.</p>
 <h5>User Rights</h5>
 <p>You have the right to access, rectify, or delete your data. For any data-related requests, please contact us at info@thetiptab.com.</p>
 <h5>Cookies and Tracking</h5>
 <p>We use cookies and tracking technologies to improve app performance. You can manage your preferences for these technologies in your app settings.</p>
 <h5>Third-Party Links</h5>
 <p>Our app may contain links to third-party websites or services. Please note that this Privacy Policy applies solely to TipTab, and we are not responsible for the privacy practices of external sites.</p>
 <h5>Children's Privacy</h5>
 <p>Our app is intended for use by individuals aged 13 and older. We do not knowingly collect data from children under the age of 13. If you believe your child's information has been collected, please contact us immediately.</p>
 <h5>Policy Updates</h5>
 <p>We may update our Privacy Policy periodically. Changes will be communicated through app notifications or email. The updated policy becomes effective on the date specified in the notification.</p>
 <h5>Contact Information</h5>
 <p>If you have any questions or concerns regarding our Privacy Policy, please contact us at info@thetiptab.com, Your privacy and data security are important to us, and we are here to address your inquiries.</p>
 """
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         setUI()
        backView.layer.cornerRadius = 10
        textView.layer.cornerRadius = 10
        
        if let attributedString = try? NSAttributedString(data: policyData.data(using: .utf8)!, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil) {
                    // Set the attributed string to the UITextView
                    textView.attributedText = attributedString
                }
    }
    func setUI(){
        titleButton.imagefollowedByTextButtonStyle(withImage: nil, systemImageName: "lock.doc", title: "Privacy and Policys")
       // textView.applySmallTextViewStyle()
    }
    @IBAction func backButtonAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
   

}
