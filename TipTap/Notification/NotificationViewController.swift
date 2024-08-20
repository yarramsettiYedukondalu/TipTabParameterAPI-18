//
//  NotificationViewController.swift
//  TipTap
//
//  Created by ToqSoft on 09/11/23.
//
import UIKit
class NotificationViewController: UIViewController {
    var isCellExpanded = [Bool](repeating: false, count: 5)
    @IBOutlet weak var backView: UIView!
    var images = ["bell.badge","bell","bell"]
    var titleName = ["Spice up your day🍔","Meal for you","Showering discount"]
    var descriptionLabel = ["Spice heaven chicken  ","Non veg Thali with discount 10%","Heavy discounts on nuggets on order of SAR 150"]
    @IBOutlet weak var NoticaficationTableView: UITableView!
    var internetCheckTimer : Timer?
    override func viewDidLoad() {
        super.viewDidLoad()
        internetCheckTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(checkInternet), userInfo: nil, repeats: true)
               internetCheckTimer?.tolerance = 2.0
        backView.layer.cornerRadius = 10
        
        NoticaficationTableView.delegate = self
        NoticaficationTableView.dataSource = self
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
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true)
    }


}
extension NotificationViewController:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)as? notificationTVC
        
        cell?.notificationImageView.image = UIImage(systemName: images[indexPath.row])
        cell?.descriptionName.textColor = .black
        cell?.descriptionName.text = descriptionLabel[indexPath.row]
        
        cell?.notificationTitleName.text = titleName[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
            return 10
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  100 //isCellExpanded[indexPath.row] ? UITableView.automaticDimension : 50
       }

       func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           
//           let controller = storyboard?.instantiateViewController(identifier: "PaymentDetailsViewController") as! PaymentDetailsViewController
//           self.present(controller, animated: true)
           let controller = storyboard?.instantiateViewController(identifier: "PaymentViewController") as! PaymentViewController
           //controller.telrResponseModel = cardDetails[indexPath.row]
           self.present(controller, animated: true)
////           isCellExpanded[indexPath.row].toggle()
////           tableView.reloadRows(at: [indexPath], with: .automatic)
////           
////           //tableView.cellForRow(at: indexPath)?.backgroundColor = UIColor.blue
//           
//           
      }
//   

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)as? notificationTVC
        cell?.MainView.backgroundColor = UIColor.white
          
       }
}
