//
//  UserEnquiryViewController.swift
//  TipTap
//
//  Created by ToqSoft on 16/12/23.
//

import UIKit
import SVProgressHUD

class UserEnquiryViewController: UIViewController {
    
    
    @IBOutlet weak var EnquiryTableView: UITableView!
    
    var cellTitle  = ""
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.show()
        fetchUserEnquiry{
            DispatchQueue.main.async {
                self.EnquiryTableView.reloadData()
                SVProgressHUD.dismiss()
            }
            
        }
        // Do any additional setup after loading the view.
        titleLabel.text = cellTitle
        EnquiryTableView.register(UINib(nibName: "EmptyRewardCell", bundle: .main), forCellReuseIdentifier: "EmptyRewardCell")
    }
    
    
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

extension UserEnquiryViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return JsonDataArrays.UserEnquiryArray.isEmpty ? 1 : JsonDataArrays.UserEnquiryArray.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if JsonDataArrays.UserEnquiryArray.isEmpty {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyRewardCell", for: indexPath) as! EmptyRewardCell
            cell.messageLabel.text = "No Rewards found here"
            //cell.Uiimage.image = UIImage(named: "offlineImage")
            // Configure the empty cell if needed
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "USerEnquiryTableViewCell", for: indexPath) as! USerEnquiryTableViewCell
            let data = JsonDataArrays.UserEnquiryArray[indexPath.row]
            cell.UserNameLabel.text = "Name: " + (data.firstName ?? "") + (data.lastName ?? "")
            cell.EmailLabel.text = "Email: " + (data.emailEQ ?? "")
            cell.ContactNumberLabel.text = "Enquiry Type: " + (data.enquiryType ?? "")
            cell.MessageLabel.text = "Message: " + (data.comment ?? "")
            cell.EnquiryDateLabel.text = "Enquiry Date: " + (data.EnquiryDate ?? "")
            return cell
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if JsonDataArrays.UserEnquiryArray.isEmpty {
            
            return 150
        } else {
            
            return UITableView.automaticDimension
        }
        
        
    }
}


