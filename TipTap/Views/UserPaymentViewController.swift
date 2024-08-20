//
//  UserPaymentViewController.swift
//  TipTap
//
//  Created by ToqSoft on 16/12/23.
//


import UIKit

class UserPaymentViewController: UIViewController {
    @IBOutlet weak var paymentTableView: UITableView!
    var cellTitle  = ""
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchUserPayments()
        // Do any additional setup after loading the view.
        //titleLabel.text = cellTitle
    }
    
    
    func fetchUserPayments(){
        let url = URL(string:userPaymentURL)
        
        fetchJSONData(from: url!)  { (result: Result<fetchUserPaymentsApiResponse, APIError>) in
            switch result {
            case .success(let jsondata):
                
                DispatchQueue.main.async {
                    print(jsondata)
                    print("Before filtering: \(jsondata)")
                    //                    JsonDataArrays.userPaymentArray = jsondata.Records.filter { $0.UserID == loginUserID }
                    
                    if let records = jsondata.records{
                        JsonDataArrays.userPaymentArray = records.filter { $0.UserID == loginUserID }
                    }else{
                        JsonDataArrays.userPaymentArray = []
                    }
                    print("After filtering: \(JsonDataArrays.userPaymentArray)")
                    
                    
                    
                    for i in JsonDataArrays.userPaymentArray{
                        if let matchingRestaurant = JsonDataArrays.restaurantModel.first(where: { $0.RestaurantID  ==
                            i.RestaurantID
                        }){
                            let payment = UserPaymentData(payment: i, restaurantTitle: matchingRestaurant.RestaurantTitle ?? "")
                            
                            print("Paymeny: \(payment)")
                            JsonDataArrays.userPaymentDataArray.append(payment)
                        }
                    }
                    self.paymentTableView.reloadData()
                    
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
        
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

extension UserPaymentViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if JsonDataArrays.userPaymentDataArray.isEmpty{
            return 1
        }else{
            return JsonDataArrays.userPaymentDataArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentTableViewCell", for: indexPath) as! PaymentTableViewCell
        if JsonDataArrays.userPaymentDataArray.isEmpty{
            let emptyCell = UITableViewCell(style: .default, reuseIdentifier: nil)
            emptyCell.textLabel?.textAlignment = .center
            emptyCell.textLabel?.text =  "No Payments"
            return emptyCell
        }else{
            let data = JsonDataArrays.userPaymentDataArray[indexPath.row]
            print(data)
            cell.RestaurantNameLabel.text = "Restaurant: " + (data.restaurantTitle ?? "")
            cell.PaymentDateLabel.text = "PaymentDate: " + (data.payment.PaymentDate ?? "")
            cell.PaymentMethodLabel.text = "PaymentMethod: " + (data.payment.PaymentMethod ?? "")
            cell.PaymentStatusLabel.text = "PaymentStatus: " + (data.payment.PaymentStatus ?? "")
            cell.AmountLabel.text = "Amount: " + "\(data.payment.Amount ?? 0.0)"
            return cell
        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
