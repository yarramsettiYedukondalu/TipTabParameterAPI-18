import UIKit
import TelrSDK
struct Transaction: Codable {
    var id: String
    var date: Date
    var amount: String
    var transDesc: String
    var waiterIDName : String
}
class PaymentMethodViewController: UIViewController {
    @IBOutlet weak var bottomDesignView: UIView!
    @IBOutlet weak var waiterUIImage: UIImageView!
    var waiterData:String = ""
    var waiterImagesss:String?
    @IBOutlet weak var amountTfld: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var designView: UIView!
    @IBOutlet weak var mesageTF: UITextField!
    var savedCards: [TelrResponseModel] = []
    var transactionHistory: [Transaction] = []
    var waiterName: String?
    var waiterImage :String?
    var datespass:String = ""
    @IBOutlet weak var canNutton: UIButton!
    @IBOutlet weak var cancelButton: UIImageView!
    var animationTimer: Timer?
    //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bottomDesignView.applyGradient(colours: [.blue, UIColor(hex: "#007AFF")], cornerRadius: 20, startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 1, y: 1))
        //  setBackgroundColor()
        designView.isHidden = true
        waiterName = waiterData
        waiterImage = waiterImagesss
        designView.cellBackViewShadow()
        bottomDesignView.cellBackViewShadow()
        amountTfld.tintColor = .black
        mesageTF.tintColor = .black
        
        print(waiterImage)
        
        print("waiterName: \(String(describing: waiterName))") // Debug print
        // Fetch saved cards from UserDefaults
        if let savedCardsData = UserDefaults.standard.data(forKey: "savedCards") {
            do {
                savedCards = try JSONDecoder().decode([TelrResponseModel].self, from: savedCardsData)
                tableView.reloadData()
            } catch {
                print("Error decoding saved cards data: \(error.localizedDescription)")
                showAlert(title: "Error", message: "Failed to load saved cards.")
            }
        } else {
            showAlert(title: "Error", message: "No saved card found.")
        }
        // Load transaction history from UserDefaults
        if let historyData = UserDefaults.standard.data(forKey: "transactionHistory") {
            do {
                transactionHistory = try JSONDecoder().decode([Transaction].self, from: historyData)
            } catch {
                print("Error decoding transaction history data: \(error.localizedDescription)")
            }
        }
        
        if let url = URL(string: waiterImagesss! ) {
            print("Loading image from URL: \(url)")
            loadImage(from: url) { [weak self] image in
                DispatchQueue.main.async {
                    if let image = image {
                        print("Image downloaded successfully")
                        self?.waiterUIImage.image = image
                    } else {
                        print("Failed to download image")
                    }
                }
            }
        } else {
            print("Invalid URL: \(waiterImagesss)")
        }
        
 //       animationTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(animateBottomDesignViewBounce), userInfo: nil, repeats: true)
        
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        animationTimer?.invalidate() // Invalidate the timer when the view disappears
    }
    
    @objc func animateBottomDesignViewBounce() {
        UIView.animate(withDuration: 0.3, animations: {
            self.bottomDesignView.frame.origin.y -= 20
        }) { _ in
            UIView.animate(withDuration: 0.3, animations: {
                self.bottomDesignView.frame.origin.y += 20
            })
        }
    }
    
    // Set a background color that is a mix of blue and navy blue
    func setBackgroundColor() {
        let blueColor = UIColor.blue
        let navyBlueColor = UIColor(red: 0.0/245, green: 0.0/245, blue: 0.5/245, alpha: 1.0)
        
        // Mix the colors by averaging their components
        let mixColor = UIColor(
            red: (blueColor.cgColor.components?[0] ?? 0.0 + (navyBlueColor.cgColor.components?[0])! ?? 0.0) / 2,
            green: (blueColor.cgColor.components?[1] ?? 0.0 + (navyBlueColor.cgColor.components?[1])! ?? 0.0) / 2,
            blue: (blueColor.cgColor.components?[2] ?? 0.0 + (navyBlueColor.cgColor.components?[2])! ?? 0.0) / 2,
            alpha: 1.0
        )
        
        self.bottomDesignView.backgroundColor = mixColor
    }
    
    
    
    
    @IBOutlet weak var bottomPayButton: UIButton!
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
    
    
    
    
    func setUP(){
        amountTfld.keyboardType = .numberPad
        designView.frame.origin.y = self.view.frame.height
        
        // Ensure the designView is visible
        designView.isHidden = false
        
        // Animate the designView moving from bottom to top
        UIView.animate(withDuration: 0.15, delay: 0, options: [.curveEaseInOut], animations: {
            // Move the designView to its final position
            self.designView.frame.origin.y = self.view.frame.height - self.designView.frame.height
        }, completion: { finished in
            // Optional completion block if needed
        })
        
        // Hide the bottomDesignView
        bottomDesignView.isHidden = true
        amountTfld.becomeFirstResponder()
        amountTfld.selectedTextRange = amountTfld.textRange(from: amountTfld.beginningOfDocument, to: amountTfld.beginningOfDocument)
        self.designView.frame.origin.y = self.view.frame.height
    }
    @IBAction func BottomPayButton(_ sender: UIButton) {
        
        // Set the initial position of the designView off-screen at the bottom
        setUP()
        UIView.animate(withDuration: 0.3) {
            // Adjust this according to your layout constraints
            self.designView.frame.origin.y = self.view.frame.height - self.designView.frame.height
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == amountTfld {
            textField.placeholder = "SAR 0" // Set initial placeholder with currency symbol
        }
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == amountTfld {
            // Get the current text in the text field
            let currentText = (textField.text ?? "") as NSString
            
            // Calculate the new text after the user's input
            let updatedText = currentText.replacingCharacters(in: range, with: string)
            
            // Remove the "SAR" prefix to evaluate just the numeric part
            let numericPart = updatedText.replacingOccurrences(of: "SAR ", with: "")
            
            // Check if the new text is empty
            if numericPart.isEmpty {
                textField.placeholder = "SAR 0" // Reset placeholder if field is empty
                return true
            }
            
            // Ensure the numeric part contains only digits and doesn't exceed 10 digits
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: numericPart)
            
            if !allowedCharacters.isSuperset(of: characterSet) || numericPart.count > 10 {
                return false // Prevent input if it contains non-numeric characters or exceeds 10 digits
            }
            
            // Update the text field with the "SAR" prefix and the numeric part
            textField.text = "SAR \(numericPart)"
            return false // Return false to manually update the text field
        }
        return true
    }
    
    @IBAction func dismiss(_ sender: Any) {
        amountTfld.text = ""
        mesageTF.text = ""
        amountTfld.keyboardType = .numberPad
        designView.isHidden = true
        bottomDesignView.isHidden = false
        amountTfld.resignFirstResponder()
        //  amountTfld.becomeFirstResponder()
    }
    
    @IBAction func submit(_ sender: Any) {
        guard let amountText = amountTfld.text, !amountText.isEmpty else {
            showAlert(title: "Error", message: "Please enter an amount.")
            return
        }
        
        // Remove the "SAR" prefix to evaluate the numeric part
        let numericAmountText = amountText.replacingOccurrences(of: "SAR ", with: "")
        
        // Validate the amount length
        if numericAmountText.count > 8 {
            showAlert(title: "Error", message: "Amount exceeds the maximum allowed length (8 digits).")
            return
        }
        
        let messageText = mesageTF.text ?? ""
        guard let waiterName = waiterName else {
            showAlert(title: "Error", message: "Waiter name not found.")
            return
        }
        
      //  let combinedMessage = "\(waiterName)                           \(messageText)"
        let combinedMessage = "\(waiterName)\n\(messageText)"

        let transformedAmount = transformAmount(amount: amountText)
        
        // Update saved cards with transformed amount and combined message
        for index in savedCards.indices {
            savedCards[index].transAmount = transformedAmount
            savedCards[index].transDesc = combinedMessage
        }
        
        if let imageUrlString = waiterImage {
            UserDefaults.standard.set(imageUrlString, forKey: "waiterImage")
        }
        // Save updated cards to UserDefaults
        saveSavedCards()
        
        // Add transaction to history
        let transaction = Transaction(id: UUID().uuidString, date: Date(), amount: transformedAmount, transDesc: combinedMessage, waiterIDName: waiterName)
        transactionHistory.append(transaction)
        // Save transaction history to UserDefaults
        saveTransactionHistory()
        // Clear amount and message fields after payment
        amountTfld.text = ""
        mesageTF.text = ""
        // Format date for success view
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MMMM/yyyy HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        
        if let firstDate = transactionHistory.first?.date {
            let dateString = dateFormatter.string(from: firstDate)
            print("Formatted date: \(dateString)")
            if let successVC = storyboard?.instantiateViewController(withIdentifier: "PaymentSuccessViewController") as? PaymentSuccessViewController {
                successVC.modalPresentationStyle = .fullScreen
                successVC.name = waiterName
                successVC.amount = transformedAmount
                successVC.personImage = waiterImage ?? ""
                successVC.data = dateString
                successVC.waiterTransction = transaction.id
                present(successVC, animated: true, completion: nil)
            }
        } else {
            print("No date available")
        }
        // Success alert
        showAlert(title: "Success", message: "Payment completed successfully.")
    }
    
    // Helper function to show alerts
    //    func showAlert(title: String, message: String) {
    //        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    //        alert.addAction(UIAlertAction(title: "OK", style: .default))
    //        present(alert, animated: true, completion: nil)
    //    }
    
    func transformAmount(amount: String) -> String {
        // Example transformation: remove currency symbols or format the amount
        return amount.replacingOccurrences(of: "$", with: "")
    }
    func saveSavedCards() {
        do {
            let encoder = JSONEncoder()
            let encodedCards = try encoder.encode(savedCards)
            UserDefaults.standard.set(encodedCards, forKey: "savedCards")
        } catch {
            print("Error encoding saved cards: \(error.localizedDescription)")
        }
    }
    func saveTransactionHistory() {
        do {
            let encoder = JSONEncoder()
            let encodedHistory = try encoder.encode(transactionHistory)
            UserDefaults.standard.set(encodedHistory, forKey: "transactionHistory")
        } catch {
            print("Error encoding transaction history: \(error.localizedDescription)")
        }
    }
}
import UIKit

extension UIView {
    func applyGradient(colours: [UIColor], cornerRadius: CGFloat?, startPoint: CGPoint, endPoint: CGPoint) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        if let cornerRadius = cornerRadius {
            gradient.cornerRadius = cornerRadius
        }
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        gradient.colors = colours.map { $0.cgColor }
        self.layer.insertSublayer(gradient, at: 0)
    }
}
import UIKit

extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
