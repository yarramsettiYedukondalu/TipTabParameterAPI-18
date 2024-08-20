//
//  UserLogsViewController.swift
//  TipTap
//
//  Created by ToqSoft on 16/12/23.
//

import UIKit

class UserLogsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var userLogTableView: UITableView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var cellTitle  = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        userLogTableView.delegate = self
        userLogTableView.dataSource = self
        titleLabel.text = cellTitle
        userLogTableView.register(UINib(nibName: "EmptyRewardCell", bundle: .main), forCellReuseIdentifier: "EmptyRewardCell")
        fetchUserLogs{
            DispatchQueue.main.async {
                self.userLogTableView.reloadData()
            }
        }
    }
    
    
    
    
    @IBAction func backButtonAction(_ sender: Any) {
        dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let records = JsonDataArrays.userLogArray
        let count = records.isEmpty ? 1 : records.count
        return count
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard  !JsonDataArrays.userLogArray.isEmpty else {
            let emptyCell = tableView.dequeueReusableCell(withIdentifier: "EmptyRewardCell", for: indexPath) as! EmptyRewardCell
            emptyCell.textLabel?.textAlignment = .center
            emptyCell.textLabel?.text = "No UserLogs"
            return emptyCell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserLogsTableViewCell", for: indexPath) as! UserLogsTableViewCell
        let data = JsonDataArrays.userLogArray[indexPath.row]
        
        
        cell.LogTypeLabel.text = "LogType: " + (data.LogType ?? "")
        cell.LogDateLabel.text = "DateTime: " + (data.LogDateTime ?? "")
        cell.LogDetailsLabel.text = "Details: " + (data.LogDetails ?? "")
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if JsonDataArrays.userLogArray.isEmpty{
            return 130
        }else{
            return UITableView.automaticDimension
        }
        
    }
    
}
