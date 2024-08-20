//
//  waiterListViewController.swift
//  
//
//  Created by ToqSoft on 01/08/24.
//

import UIKit

class waiterListViewController: UIViewController {
var waiterModelForSearch =  [WaiterCompleteData]()
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var waiterListTableView: UITableView!
    @IBOutlet weak var dismissButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showHUD()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [self] in
            waiterListTableView.delegate = self
            waiterListTableView.dataSource = self
            waiterListTableView.reloadData()
            self.hideHUD()
        }
        
       
        baseView.layer.shadowColor = UIColor.black.cgColor
        baseView.layer.shadowOpacity = 0.8
        baseView.layer.shadowOffset = CGSize(width: 0, height: 4)
        baseView.layer.shadowRadius = 10
        baseView.layer.masksToBounds = false
        
    }
    @IBAction func dismissButtonAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}
extension waiterListViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return waiterModelForSearch.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let waiterCell = tableView.dequeueReusableCell(withIdentifier: "waiterlistcell", for: indexPath) as! WaiterListTableViewCell
        
        let waiter = waiterModelForSearch[indexPath.row]
      
        waiterCell.waiterNameLabel.text = "\(waiter.waiter.firstName ?? "")  \(waiter.waiter.lastName ?? "")"
        
        return waiterCell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Available Waiters (\(waiterModelForSearch.count))"
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !waiterModelForSearch.isEmpty{
            let waiterCell = storyboard?.instantiateViewController(identifier: "WaiterDetailsVC") as! WaiterDetailsVC
            let waiter = waiterModelForSearch[indexPath.row]
           
            waiterCell.userDataArray = JsonDataArrays.userDataArray
            waiterCell.waiterData = [waiter]
            waiterCell.waiterData = [waiter]
            
            waiterCell.modalPresentationStyle = .fullScreen
            waiterCell.modalTransitionStyle = .coverVertical
            
            self.present(waiterCell, animated: true, completion: nil)
        }
    }
}
