import Foundation
import UIKit

class alartView: UIView {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.numberOfLines = 0
        label.text = "No results found" // Replace with your message
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSubviews()
        setConstraints()
    }
    
    private func setupSubviews() {
        addSubview(imageView)
        addSubview(label)
    }
    
    private func setConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 6),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
    
    func getGif(image: UIImageView, imageURL: String, speed: Double) {
         if let gifURL = Bundle.main.url(forResource: imageURL, withExtension: "gif"),
            let gifData = try? Data(contentsOf: gifURL) {
             if let source = CGImageSourceCreateWithData(gifData as CFData, nil) {
                 var images = [UIImage]()
                 let count = CGImageSourceGetCount(source)
                 
                 for i in 0..<count {
                     if let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) {
                         images.append(UIImage(cgImage: cgImage))
                     }
                 }
                 
                 let duration = Double(count) / speed
                 let animatedImage = UIImage.animatedImage(with: images, duration: duration)
                 image.image = animatedImage
             }
         }
     }
     func setupNoResultsView(noResultsView:UIView,view:UIView) {
           
           noResultsView.isHidden = true
           noResultsView.translatesAutoresizingMaskIntoConstraints = false
           view.addSubview(noResultsView)
           
           NSLayoutConstraint.activate([
               noResultsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
               noResultsView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
               noResultsView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
               noResultsView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5)
           ])
       }
}
