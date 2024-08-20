
import UIKit

class OffersPopupViewController: UIViewController {
   
    @IBOutlet weak var offerDetailsLAbel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var offerImagesView: UIImageView!
    var OfferrestaurantName: String?
    var offerDescription : String?
    var offerDiscount : String?
    var startDate: String?
    var endDate : String?
    var ooferTitle:String?
    var imageString: String?
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var offerRestaurantNameLabel: UILabel!
    @IBOutlet weak var offerTitle: UILabel!
    
    @IBOutlet weak var endDateLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        descriptionLabel.text = offerDescription
        offerRestaurantNameLabel.text = OfferrestaurantName
        offerTitle.text = ooferTitle
        startDateLabel.text = startDate
        endDateLabel.text = endDate
        
        backView.layer.cornerRadius = 10
        loadOfferImage()
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    func setUI() {
        titleLabel.applyLabelStyle(for: .headingBlack)
        offerDetailsLAbel.applyLabelStyle(for: .smallheadingBlack)
       
    }
    
    func loadOfferImage() {
        guard let imageUrlString = imageString, let imageUrl = URL(string: imageUrlString) else {
            offerImagesView.image = UIImage(named: "placeholderImage")
            return
        }
        
        let task = URLSession.shared.dataTask(with: imageUrl) { (data, response, error) in
            if let error = error {
                print("Error downloading image: \(error)")
                DispatchQueue.main.async {
                    self.offerImagesView.image = UIImage(named: "placeholderImage")
                }
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    self.offerImagesView.image = UIImage(named: "placeholderImage")
                }
                return
            }
            
            DispatchQueue.main.async {
                self.offerImagesView.image = image
            }
        }
        task.resume()
    }
}
