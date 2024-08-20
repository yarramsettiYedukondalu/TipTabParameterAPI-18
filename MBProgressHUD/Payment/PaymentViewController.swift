

import UIKit
import TelrSDK
class PaymentViewController: UIViewController {
    // MARK: - Properties
    let KEY: String = "jT4F2^PjBp-n8jbr" // TODO: Fill key
    let STOREID: String = "24717"
    var EMAIL: String = "ashif@toqsoft.com"
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Check for saved card details
        let savedCards = getSavedCards()
        if !savedCards.isEmpty {
            // Directly navigate to payment method screen if there are saved cards
            navigateToPaymentMethodScreen()
        }
    }
    // MARK: - IBActions
    @IBAction func paymentButtonAction(_ sender: Any) {
        // Check for saved card details
        let savedCards = getSavedCards()
        if savedCards.isEmpty {
            // Show card details screen if no saved cards
            showCardDetailsScreen()
        } else {
            // Directly go to payment method screen if there are saved cards
            navigateToPaymentMethodScreen()
        }
    }
    private func startPayment(with paymentRequest: PaymentRequest) {
        let customBackButton = UIButton(type: .custom)
        customBackButton.setTitle("Back", for: .normal)
        customBackButton.setTitleColor(.black, for: .normal)
        let telrController = TelrController()
        telrController.delegate = self
        telrController.customBackButton = customBackButton
        telrController.paymentRequest = paymentRequest
        self.navigationController?.pushViewController(telrController, animated: true)
    }
    private func showCardDetailsScreen() {
        // Assuming card details are entered in the current screen
        let paymentRequest = preparePaymentRequest()
        startPayment(with: paymentRequest)
    }
    
    private func navigateToPaymentMethodScreen() {
        // Navigate to the payment method screen
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "PaymentMethodViewController") as! PaymentMethodViewController
        controller.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(controller, animated: true)
    }
    
    private func preparePaymentRequest() -> PaymentRequest {
        let paymentReq = PaymentRequest()
        
        paymentReq.key = self.KEY
        paymentReq.store = self.STOREID
        paymentReq.appId = "123456789"
        paymentReq.appName = "TelrSDK"
        paymentReq.appUser = "123456"
        paymentReq.appVersion = "0.0.1"
        paymentReq.transTest = "1" // 0 for production
        paymentReq.transType = "paypage"
        paymentReq.transClass = "ecom"
        paymentReq.transCartid = String(arc4random())
        paymentReq.transDesc = "Test API"
        paymentReq.transCurrency = "AED"
        paymentReq.transAmount = "100"
        paymentReq.billingEmail = EMAIL
        paymentReq.billingPhone = "8888888888"
        paymentReq.billingFName =  ""
        paymentReq.billingLName =  ""
        paymentReq.billingTitle = "Mr"
        paymentReq.city = "Dubai"
        paymentReq.country = "AE"
        paymentReq.region = "Dubai"
        paymentReq.address = "line1"
        paymentReq.zip = "414202"
        paymentReq.language = "en"
        
        return paymentReq
    }
    
    private func preparePaymentRequestSaveCard(lastResponse: TelrResponseModel) -> PaymentRequest {
        let paymentReq = PaymentRequest()
        
        paymentReq.key = lastResponse.key ?? ""
        paymentReq.store = lastResponse.store ?? ""
        paymentReq.appId = lastResponse.appId ?? ""
        paymentReq.appName = lastResponse.appName ?? ""
        paymentReq.appUser = lastResponse.appUser ?? ""
        paymentReq.appVersion = lastResponse.appVersion ?? ""
        paymentReq.transTest = "1"
        paymentReq.transType = "paypage"
        paymentReq.transClass = "ecom"
        paymentReq.transFirstRef = lastResponse.transFirstRef ?? ""
        paymentReq.transCartid = String(arc4random())
        paymentReq.transDesc = lastResponse.transDesc ?? ""
        paymentReq.transCurrency = lastResponse.transCurrency ?? ""
        paymentReq.billingFName = lastResponse.billingFName ?? ""
        paymentReq.billingLName = lastResponse.billingLName ?? ""
        paymentReq.billingTitle = lastResponse.billingTitle ?? ""
        paymentReq.city = lastResponse.city ?? ""
        paymentReq.country = lastResponse.country ?? ""
        paymentReq.region = lastResponse.region ?? ""
        paymentReq.address = lastResponse.address ?? ""
        paymentReq.zip = lastResponse.zip ?? ""
        paymentReq.transAmount = "100"
        paymentReq.billingEmail = lastResponse.billingEmail ?? ""
        paymentReq.billingPhone = lastResponse.billingPhone ?? ""
        paymentReq.language = "en"
        
        return paymentReq
    }
    
    // MARK: - Card Management (Save and Retrieve)
    private func saveCardDetails(_ card: TelrResponseModel) {
        var savedCards = getSavedCards()
        savedCards.append(card)
        
        do {
            let encoder = JSONEncoder()
            let encodedCards = try encoder.encode(savedCards)
            UserDefaults.standard.set(encodedCards, forKey: "savedCards")
            UserDefaults.standard.synchronize()
        } catch {
            print("Error saving card details: \(error.localizedDescription)")
        }
    }
    
    private func getSavedCards() -> [TelrResponseModel] {
        guard let savedCardsData = UserDefaults.standard.data(forKey: "savedCards") else {
            return []
        }
        
        do {
            let decoder = JSONDecoder()
            let savedCards = try decoder.decode([TelrResponseModel].self, from: savedCardsData)
            return savedCards
        } catch {
            print("Error decoding saved cards data: \(error.localizedDescription)")
            return []
        }
    }
}

// MARK: - TelrControllerDelegate
extension PaymentViewController: TelrControllerDelegate {
    
    func didPaymentCancel() {
        print("Payment Cancelled")
    }
    
   
    
    func didPaymentFail(messge message: String) {
        print("Payment Failed: \(message)")
    }
    
    
    func didPaymentSuccess(response: TelrResponseModel) {
        // Save the card details for future use
        saveCardDetails(response)
        
        // Print the last 4 digits of the card number
        if let cardLast4 = response.cardLast4 {
            print("Card Last 4 Digits: \(cardLast4)")
        } else {
            print("Card Last 4 Digits not available")
        }
        
        // Assuming the cardholder's name is inputted and stored elsewhere in the app
        if let billingFName = response.billingFName, let billingLName = response.billingLName {
            let cardholderName = "\(billingFName) \(billingLName)"
            print("Cardholder Name: \(cardholderName)")
        } else {
            print("Cardholder Name not available")
        }
        
        // Show completion message or alert
        showPaymentCompletionAlert()
    }
    
    private func showPaymentCompletionAlert() {
        let alert = UIAlertController(title: "Payment Successful", message: "Your payment has been completed.", preferredStyle: .alert)
        self.navigateToPaymentMethodScreen()
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            // Navigate to payment method screen after user acknowledges
            self.navigateToPaymentMethodScreen()
        }))
        
        present(alert, animated: true, completion: nil)
    }
}
