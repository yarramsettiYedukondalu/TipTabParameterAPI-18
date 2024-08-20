import UIKit

class TipsViewController: UIViewController {
    @IBOutlet weak var dateButton: UIButton!
    var transactionHistory: [Transaction] = []
    var fillteredData : [Transaction] = []
    @IBOutlet weak var searchBar: UITextField!
    var filteredWaiterData: [WaiterCompleteData] = []
    @IBOutlet weak var restaurantButton: UIButton!
    @IBOutlet weak var waiterNameButton: UIButton!
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var tipHistoryTableview: UITableView!
    @IBOutlet weak var dismissButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        fetchWaiterData()
        fillteredData = transactionHistory
        if let historyData = UserDefaults.standard.data(forKey: "transactionHistory") {
            do {
                transactionHistory = try JSONDecoder().decode([Transaction].self, from: historyData)
                print(transactionHistory)
            } catch {
                print("Error decoding transaction history data: \(error.localizedDescription)")
            }
        }
        
        filterWaiterData()
        tipHistoryTableview.reloadData()
        
        let myButton = [waiterNameButton, dateButton, restaurantButton, dismissButton]
        for button in myButton {
            button?.layer.cornerRadius = 5
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
                    view.addGestureRecognizer(tapGesture)
    }
    @objc func dismissKeyboard() {
            view.endEditing(true)
        }
    func filterWaiterData() {
        // Filter Waiter Data based on waiterIDName from transactionHistory
        filteredWaiterData = JsonDataArrays.WaiterCompleteDataArray.filter { waiter in
            return transactionHistory.contains { $0.waiterIDName == waiter.waiter.firstName }
        }
    }
    
    @IBAction func dismissButtonAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

extension TipsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return max(1, fillteredData.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historycell") as! TipHistoryTableViewCell
        
        if fillteredData.isEmpty {
            tipHistoryTableview.isHidden = true
            dismissButton.setTitle("Explore", for: .normal)
        } else {
            tipHistoryTableview.isHidden = false
            emptyLabel.isHidden = true
            cell.waiterImage.layer.cornerRadius = 25
            cell.waiterImage.layer.borderWidth = 0.1
            cell.waiterImage.layer.borderColor = UIColor.black.cgColor
            dismissButton.setTitle("Close", for: .normal)
            let data = fillteredData[indexPath.row]
            cell.sarAmountLabel?.text = "SAR: \(data.amount)"
            cell.waiterName?.text = data.transDesc
            
            // Find the corresponding waiter data
            if let waiterData = filteredWaiterData.first(where: { $0.waiter.firstName == data.waiterIDName }) {
                DispatchQueue.main.async {
                    // Handle different cases for the image data
                    if let imageDataString = waiterData.waiter.waiterImage {
                        if let imageData = Data(base64Encoded: imageDataString) { // Assuming the image is Base64 encoded
                            cell.waiterImage.image = UIImage(data: imageData)
                        } else if let url = URL(string: imageDataString), let imageData = try? Data(contentsOf: url) { // Assuming the image is a URL
                            
                            
                            cell.waiterImage.image = UIImage(data: imageData)
                            
                        } else {
                            cell.waiterImage.image = UIImage(named: "placeholder_image") // Use a placeholder image
                        }
                    } else {
                        cell.waiterImage.image = UIImage(named: "placeholder_image") // Use a placeholder image
                    }
                }
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MMMM/yyyy"
            let dateString = dateFormatter.string(from: data.date)
            cell.dateAndTimeLabel.text = dateString
        }
        
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor(red: 234/245, green: 265/245, blue: 243/245, alpha: 1)
        }
        cell.selectionStyle = .none
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Waiter Tips"
    }
}
extension TipsViewController: UITextFieldDelegate {
    func searchTips(_ searchText: String) {
        if searchText.isEmpty {
            fillteredData = transactionHistory
        } else {
            let lowercasedSearchText = searchText.lowercased()
            fillteredData = transactionHistory.filter { transaction in
                return transaction.amount.lowercased().contains(lowercasedSearchText) ||
                transaction.transDesc.lowercased().contains(lowercasedSearchText)
            }
            tipHistoryTableview.isHidden = false
            
        }
        tipHistoryTableview.reloadData()
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = searchBar.text ?? ""
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
        searchTips(updatedText)
        return true
    }
}


