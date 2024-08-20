//
//  UserReportViewController.swift
//  TipTap
//
//  Created by ToqSoft on 19/12/23.
//

import UIKit

class UserReportViewController: UIViewController {
    @IBOutlet weak var UserReportTableView: UITableView!
    var cellTitle  = ""
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUserReport{
            DispatchQueue.main.async {
                self.UserReportTableView.reloadData()
            }
        }
        // Do any additional setup after loading the view.
        titleLabel.text = cellTitle
        UserReportTableView.register(UINib(nibName: "EmptyRewardCell", bundle: .main), forCellReuseIdentifier: "EmptyRewardCell")
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
extension UserReportViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if JsonDataArrays.UserReportArray.isEmpty{
            return 1
        }else{
            return JsonDataArrays.UserReportArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if JsonDataArrays.UserReportArray.isEmpty {
            // If UserReportArray is empty, dequeue the EmptyRewardCell
            let emptyCell = tableView.dequeueReusableCell(withIdentifier: "EmptyRewardCell", for: indexPath) as! EmptyRewardCell
            emptyCell.textLabel?.textAlignment = .center
            emptyCell.messageLabel?.text = "No User Report"
            return emptyCell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserReportTableViewCell", for: indexPath) as! UserReportTableViewCell
            let data = JsonDataArrays.UserReportArray[indexPath.row]
            cell.RestaurantNameLabel.text = "\(data.EmailID ?? "")"
            cell.ReprotDateLabel.text = "Date: " + (data.ReportDate ?? "")
            cell.ReportTextLabel.text = "Issue: " + (data.Issue ?? "")
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if JsonDataArrays.UserReportArray.isEmpty {
            // Return a fixed height for EmptyRewardCell
            return 130
        } else {
            // Use automatic dimension for UserReportTableViewCell
            return UITableView.automaticDimension
        }
    }
    
}


