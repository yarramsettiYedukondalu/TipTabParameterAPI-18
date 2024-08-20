//
//  PaymentDetailsPageViewController.swift
//  TipTap
//
//  Created by yarramsetti yedukondalu on 09/08/24.
//

import UIKit
class PaymentDetailsPageViewController: UIViewController {
    var transactionHistory: [Transaction] = []
    @IBOutlet weak var detailsTableView: UITableView!
    @IBOutlet weak var designView: UIView!
    var waiterProfileImage:String?
    var waiterName :String?
    var waiterAmount:String?
    var waiterTransction:String?
    var  dateFiled : String?
    @IBOutlet weak var waiterNameLabel: UILabel!
    @IBOutlet weak var sarAmountLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        sarAmountLabel.text = "SAR: \(waiterAmount ?? "") "
        dateLabel.text = dateFiled
        waiterNameLabel.text = waiterName
        detailsTableView.dataSource = self
        detailsTableView.delegate = self
        transactionHistory.count
        detailsTableView.reloadData()
        designView.cellBackViewShadow()
        if let url = URL(string: waiterProfileImage ?? "") {
               print("Loading image from URL: \(url)")
               loadImage(from: url) { [weak self] image in
                   DispatchQueue.main.async {
                       if let image = image {
                           print("Image downloaded successfully")
                           self?.image.image = image
                       } else {
                           print("Failed to download image")
                       }
                   }
               }
           } else {
               print("Invalid URL: \(waiterProfileImage)")
           }
    }
   
    @IBAction func back(_ sender: Any) {
        let controller = self.storyboard?.instantiateViewController(identifier: "PaymentSuccessViewController")as! PaymentSuccessViewController
        controller.modalTransitionStyle = .flipHorizontal
        controller.modalPresentationStyle = .fullScreen
        controller.personImage = waiterProfileImage
        self.present(controller, animated: true)
    }
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error downloading image: \(error)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("No data returned from server")
                completion(nil)
                return
            }
            
            let image = UIImage(data: data)
            if image == nil {
                print("Unable to create image from data")
            }
            
            completion(image)
        }.resume()
    }

   
}
extension PaymentDetailsPageViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

       
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)as! ViewDetailsTableViewCell
        cell.transctionIdLabel.text = waiterTransction
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

