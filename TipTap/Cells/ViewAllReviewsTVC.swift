import UIKit
 
protocol commandOptionsProtocal: AnyObject {
    func openOptions(cell: ViewAllReviewsTVC,options: commandOptions)
}
 
enum commandOptions {
    case Edit
    case Delete
}
 
class ViewAllReviewsTVC: UITableViewCell {
    var delegate: commandOptionsProtocal?
    var currentUserId: String? // Property for the current user ID
    var restaurantRateID: String? // Property for the restaurant rating ID
    var particianKeyID: String? // Property for the partition key
    var itemID : String?
   
    @IBOutlet weak var dislikeButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var reviewText: UITextView!
    @IBOutlet weak var ratingDate: UILabel!
    @IBOutlet weak var personName: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var ratingPersonImage: UIImageView!
    @IBOutlet weak var optionButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        optionButton?.isHidden = true
        likeButton.isHidden = true
        dislikeButton.isHidden = true
        likeButton.layer.borderWidth = 2
   // /?/    likeButton.layer.borderColor =  colorLiteral(red: 0.2039215686, green: 0.3058823529, blue: 0.2549019608, alpha: 1)
        likeButton.layer.cornerRadius = 5
        dislikeButton.layer.borderWidth = 2
        //dislikeButton.layer.borderColor =  colorLiteral(red: 0.2039215686, green: 0.3058823529, blue: 0.2549019608, alpha: 1)
        dislikeButton.layer.cornerRadius = 5
        setCellUI()
        ratingPersonImage.layer.cornerRadius = 25
        openMenu()
    }
    
    @IBAction func options(_ sender: Any) {
        // Option button action
    }
    
    func openMenu() {
        let menu = UIMenu(title: "", children: [
            UIAction(title: "Edit", image: UIImage(systemName: "highlighter"), handler: { [weak self] (_) in
                self?.editFunc()
            }),
            UIAction(title: "Delete", image: UIImage(systemName: "eye"), handler: { [weak self] (_) in
                self?.deleteFunc()
            })
        ])
        optionButton?.menu = menu
        self.optionButton?.showsMenuAsPrimaryAction = true
    }
    
    func deleteFunc() {
        delegate?.openOptions(cell: self, options: .Delete)
    }
    
    func editFunc() {
        delegate?.openOptions(cell: self, options: .Edit)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setCellUI() {
        ratingView.settings.fillMode = .precise
        personName.applyLabelStyle(for: .subTitleBlack)
        ratingDate.applyLabelStyle(for: .descriptionLightGray)
        reviewText.applySmallTextViewStyle()
    }
    
    func configure(with review: RestaurantRatingData, currentUserId: String) {
        self.currentUserId = currentUserId
    
        setImage(from: review.UserImage)
        restaurantRateID = review.RestaurantratingID
        
       // particianKeyID = review.PartitionKey
        let ratingDouble = Double(review.Rating ?? 0)
        ratingView.rating = ratingDouble
        ratingView.text = "\(ratingDouble)"
        personName.text = review.UserTitle
        reviewText.text = review.Review
      
        if let convertedDate = convertDateFormat(dateString: review.RatingDate ?? "") {
            ratingDate.text = convertedDate
        } else {
            ratingDate.text = "N/A"
        }
        
        optionButton?.isHidden = review.UserID != currentUserId
    }
    
    func configureWithItem(with review: ItemRatingReviewData, currentUserId: String) {
        self.currentUserId = currentUserId
        setImage(from: review.UserImage)
        let ratingDouble = Double(review.Rating ?? 0)
        ratingView.rating = ratingDouble
        ratingView.text = "\(ratingDouble )"
        personName.text = review.UserTitle
        reviewText.text = review.Review
        itemID = review.RowKey
       let dateFormat = DateFormatter()
        dateFormat.dateFormat = "dd/mm/yyyy"
        if let convertedDate = dateFormat.date(from: review.RateDate ?? "") {
            ratingDate.text = convertedDate.description
        } else {
            ratingDate.text = "N/A"
        }
        
        
        optionButton?.isHidden = review.UserID != currentUserId
    }
    
    func configureWithWaiter(with waiter: waiterRatingUserData, currentUserId: String) {
        self.currentUserId = currentUserId
        setImage(from: waiter.UserImage)
        let ratingDouble = Double(waiter.rating ?? 0)
        ratingView.rating = ratingDouble
        ratingView.text = "\(ratingDouble )"
        personName.text = waiter.UserTitle
        reviewText.text = waiter.comments
        optionButton?.isHidden = waiter.userID != currentUserId
    }
    
    private func setImage(from imageUrlString: String?) {
        guard let imageUrlString = imageUrlString, let imageUrl = URL(string: imageUrlString) else {
            DispatchQueue.main.async {
                self.ratingPersonImage.image = UIImage(systemName: "person")
                self.ratingPersonImage.tintColor = .black
            }
            return
        }
        
        ImageLoader.shared.loadImage(from: imageUrl) { image in
            DispatchQueue.main.async {
                self.ratingPersonImage.image = image ?? UIImage(systemName: "person")
                self.ratingPersonImage.tintColor = .black
            }
        }
    }
}

