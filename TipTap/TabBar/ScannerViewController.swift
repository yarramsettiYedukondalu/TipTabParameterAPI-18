//


import UIKit
import SwiftQRCodeScanner
class ScannerViewController: UIViewController {
    @IBOutlet weak var scanQRcodeLabel: UILabel!
    @IBOutlet weak var waiterProfileView: UIView!
    @IBOutlet weak var CVVTF: UITextField!
    @IBOutlet weak var expiryTF: UITextField!
    @IBOutlet weak var cardNoTF: UITextField!
    @IBOutlet weak var selectCardButton: UIButton!
    @IBOutlet weak var tipAmountTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var tipForWaiterLabel: UILabel!
    @IBOutlet weak var profileDetailsLabel: UILabel!
    @IBOutlet weak var goBackButton: UIButton!
    @IBOutlet weak var qrView: UIView!
    
    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var payBtn: UIButton!
    @IBOutlet weak var barcodeView: UIView!
    var internetCheckTimer : Timer?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        qrView.layer.cornerRadius = 10
        qrView.clipsToBounds = true
        payBtn.layer.cornerRadius = 5
        payBtn.clipsToBounds = true
        barcodeView.layer.cornerRadius = 10
        barcodeView.clipsToBounds = true
        qrView.isHidden = true
        
        
        scanButton.layer.cornerRadius = 5
        scanButton.clipsToBounds = true
        internetCheckTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(checkInternet), userInfo: nil, repeats: true)
        internetCheckTimer?.tolerance = 2.0
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
    func setUI(){
        scanQRcodeLabel.applyLabelStyle(for: .headingBlack)
        scanButton.titleLabel?.applyLabelStyle(for: .buttonTitle)
        payBtn.titleLabel?.applyLabelStyle(for: .buttonTitle)
        profileDetailsLabel.applyLabelStyle(for: .headingBlack)
        tipForWaiterLabel.applyLabelStyle(for: .smallheadingBlack)
        nameTF.applyCustomPlaceholderStyle(size: "small")
        expiryTF.applyCustomPlaceholderStyle(size: "small")
        CVVTF.applyCustomPlaceholderStyle(size: "small")
        tipAmountTF.applyCustomPlaceholderStyle(size: "small")
        cardNoTF.applyCustomPlaceholderStyle(size: "small")
        selectCardButton.titleLabel?.applyLabelStyle(for: .subTitleBlack)
    }
    @IBAction func goBackBtnAct(_ sender: UIButton) {
        barcodeView.isHidden = false
        qrView.isHidden = true
        
    }
    @IBAction func backButtonAct(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @IBAction func backButtonAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @IBAction func ScannerButtonAction(_ sender: UIButton) {
        
        let scanner = QRCodeScannerController()
        scanner.modalPresentationStyle = .formSheet
        if let popoverController = scanner.popoverPresentationController {
            popoverController.sourceRect = CGRect(x: 0, y: 0, width: 1, height: 1)
            popoverController.sourceView = self.view
        }
        
        scanner.delegate = self
        present(scanner, animated: true, completion: nil)
        barcodeView.isHidden = true
        qrView.isHidden = false
        
        
        
    }
    
    
    @IBAction func pay(_ sender: Any)
    {
        let alertController = UIAlertController(title: "Success!!!", message: "Thank you, It is sincerely appreciated.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            // Handle OK button tap
            self.dismiss(animated: true)
            
        }
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func showDetailsViewController(pa: String, pn: String) {
        
    }
    
}

extension ScannerViewController: QRScannerCodeDelegate {
    func qrScannerDidFail(_ controller: UIViewController, error: QRCodeError) {
        print("Error: \(error.localizedDescription)")
    }
    func qrScanner(_ controller: UIViewController, scanDidComplete result: String) {
        print("Result: \(result)")
        
        if let pa = extractParameter(from: result, key: "pa"),
           let pn = extractParameter(from: result, key: "pn") {
            nameTF.text = extractParameter(from: result, key: "pn")
            tipAmountTF.text = extractParameter(from: result, key: "pa")
            
            showDetailsViewController(pa: pa, pn: pn)
        } else {
            print("Error extracting parameters from QR code result.")
        }
        
        controller.dismiss(animated: true, completion: nil)
    }
    
    func qrScannerDidCancel(_ controller: UIViewController) {
        print("QR Scanner did cancel")
        controller.dismiss(animated: true, completion: nil)
    }
    
    func extractParameter(from link: String, key: String) -> String? {
        guard let url = URL(string: link), let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return nil
        }
        
        if let queryItems = components.queryItems {
            for item in queryItems {
                if item.name.lowercased() == key.lowercased() {
                    return item.value
                }
            }
        }
        
        return nil
    }
    
    func showDetailsViewController(pa: String, pn: String, imageUrl: String?) {
        
    }
}
