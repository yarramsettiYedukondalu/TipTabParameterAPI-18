//
//  LabelManager.swift
//  TipTapHome_MostSales
//
//  Created by Toqsoft on 31/10/23.
//

import Foundation
import UIKit

enum LabelTextStyle {
    case heading,
         headingSmall,
         subheading,
         description,
         descriptionSmall,
         buttonTitle,
         titleBlack,
         headingBlack,
         smallheadingBlack,
         largeHeadingBlack,
         subTitleLightGray,
         subTitleBlack,
         OfferWhite,
         descriptionSmallBlack,
         descriptionDarkGray,
         descriptionLightGray,
         promotedLabel,
         headinglightGray
}
enum CellBackground{
    case contentview,customUIview
}

extension UILabel {
    /*
     
     [31/10 13:13] Najeebullah Aigali
     navbar:  background: linear-gradient(45deg,#d92662 0%,#e23744
     view all header:    color: #e23744;
     card-title: font-size: 15px; font-weight: 500;
     card-title cuisine: color: #5f5959; font-size:12px;
     promoted(card) :    background-color: #343a40;
     font-family: poppins,sans-serif;
     
     Font-family:Poppins;
     viewAll:13px;color:#669900;
     
     Heading:20px;Color:#000
     Title:15px;color:#5f5959
     Subtitle:12px;color:#5f5959
     promoted:11px;

     */

    func applyLabelStyle(for style: LabelTextStyle) {
          switch style {
              
          case .heading:
              
                
              self.font = UIFont(name: "Poppins-Bold", size: 24) ?? UIFont.boldSystemFont(ofSize: 20)
              self.textColor = UIColor.white
          case .headingSmall:
              self.font = UIFont(name: "Poppins-Bold", size: 15) ?? UIFont.boldSystemFont(ofSize: 20)
              self.textColor = UIColor.white
          case .subheading:
              self.font = UIFont(name: "Poppins-Regular", size: 20) ?? UIFont.boldSystemFont(ofSize: 20)
              self.textColor = UIColor.white
          case .description:
              self.font = UIFont(name: "Poppins-Light", size: 15) ?? UIFont.boldSystemFont(ofSize: 20)
              self.textColor = UIColor.white
          case .descriptionSmall:
              self.font = UIFont(name: "Poppins-Light", size: 12) ?? UIFont.boldSystemFont(ofSize: 20)
              self.textColor = UIColor.white
          case .buttonTitle:
              self.font = UIFont(name: "Poppins-SemiBold", size: 14) ?? UIFont.boldSystemFont(ofSize: 20)
              self.textColor = UIColor.white
          case .titleBlack:
              
              
              self.font = UIFont(name: "Poppins-Bold", size: 17) ?? UIFont.boldSystemFont(ofSize: 20)
              self.textColor = UIColor.black

          case .headingBlack:
              self.font = UIFont(name: "Poppins-SemiBold", size: 15) ?? UIFont.boldSystemFont(ofSize: 15)
              self.textColor = UIColor(red: 0/245, green: 0/245, blue: 0/245, alpha: 1)
          case .smallheadingBlack:
              self.font = UIFont(name: "Poppins-SemiBold", size: 14) ?? UIFont.boldSystemFont(ofSize: 20)
              self.textColor = UIColor.black
          case .largeHeadingBlack:
              self.font = UIFont(name: "Poppins-Regular", size: 34) ?? UIFont.boldSystemFont(ofSize: 20)
              self.textColor = UIColor.black
          case .subTitleLightGray:
              self.font = UIFont(name: "Poppins-Regular", size: 13) ?? UIFont.boldSystemFont(ofSize: 12)
              self.textColor = UIColor.lightGray
          case .subTitleBlack:
              self.font = UIFont(name: "Poppins-Regular", size: 15) ?? UIFont.boldSystemFont(ofSize: 20)
              self.textColor = UIColor.black
          case .OfferWhite:
              self.font = UIFont(name: "Poppins-Medium", size: 15) ?? UIFont.boldSystemFont(ofSize: 20)
              self.textColor = UIColor.white
              self.textAlignment = .center
          case .descriptionSmallBlack:
              self.font = UIFont(name: "Poppins-Medium", size: 12) ?? UIFont.boldSystemFont(ofSize: 20)
              self.textColor = UIColor.black
          case .descriptionDarkGray:
              self.font = UIFont(name: "Poppins-Regular", size: 16) ?? UIFont.boldSystemFont(ofSize: 20)
              self.textColor = UIColor.darkGray
          case .descriptionLightGray:
              self.font = UIFont(name: "Poppins-Regular", size: 12) ?? UIFont.boldSystemFont(ofSize: 20)
              self.textColor = UIColor.lightGray
          case .promotedLabel:
              self.backgroundColor = UIColor(cgColor: CGColor(red: 52/245, green: 58/245, blue: 64/245, alpha: 1)) // #343A40
              self.font = UIFont(name: "Poppins-Bold", size: 11)
              self.text = "Promoted  "
              self.textColor = .white
              self.layer.cornerRadius = 3
              self.clipsToBounds = true
          case.headinglightGray:
              self.font = UIFont(name: "Poppins-SemiBold", size: 15) ?? UIFont.boldSystemFont(ofSize: 15)
              self.textColor = UIColor.lightGray
          }
         
      }
}
extension UIButton {
    func NavigationButtonImageStyle(withImage image: UIImage?, systemImageName: String?){
        let tintColor = UIColor.white

               if let customImage = image {
                   setImage(customImage.withRenderingMode(.alwaysTemplate), for: .normal)
               } else if let systemImage = systemImageName {
                   setImage(UIImage(systemName: systemImage)?.withRenderingMode(.alwaysTemplate), for: .normal)
               }

        let imageSize = CGSize(width: 34, height: 34)
           frame = CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height)
           layer.cornerRadius = 5
           backgroundColor = UIColor.clear
    }
    func favoriteButtonImageStyle(systemImageName: String?){
        let tintColor = UIColor.red

               if let systemImage = systemImageName {
                   setImage(UIImage(systemName: systemImage)?.withRenderingMode(.alwaysTemplate), for: .normal)
               }

           backgroundColor = UIColor.white
    }

    func viewAllButtonStyle(title: String, systemImageName: String) {
        let customColor =  UIColor(cgColor: CGColor(red: 102/245, green: 153/245, blue: 0/245, alpha: 1))
        
        // Create an attributed string with the system image and title
        let attributedString = NSMutableAttributedString()
        
        // Add the title to the attributed string
        let titleString = NSAttributedString(string: title, attributes: [NSAttributedString.Key.font: UIFont(name: "Poppins-SemiBold", size: 15) ?? UIFont.systemFont(ofSize: 12, weight: .bold), NSAttributedString.Key.foregroundColor: customColor])
        attributedString.append(titleString)
        
        // Add a space between the title and the image
        attributedString.append(NSAttributedString(string: " "))
        
        // Create a tinted system image with the custom color
        // Create a tinted and resized system image with the custom color
        if let image = UIImage(systemName: systemImageName)?.withTintColor(customColor).withRenderingMode(.alwaysTemplate) {
            let imageAttachment = NSTextAttachment()
            let imageSize = CGSize(width: 8, height: 8) // Adjust the size as needed
            imageAttachment.image = image.resized(to: imageSize)
            let imageString = NSAttributedString(attachment: imageAttachment)
            attributedString.append(imageString)
        }
        // Set the attributed string as the button's title
        DispatchQueue.main.async {
            self.setAttributedTitle(attributedString, for: .normal)
        }
    }
    func imagefollowedByTextButtonStyle(withImage image: UIImage?, systemImageName: String?, title: String) {
        let customColor = UIColor.black
           
           // Create an attributed string with the image, system image, and title
           let attributedString = NSMutableAttributedString()
           
           if let customImage = image {
               // Add the custom image to the attributed string
               let imageAttachment = NSTextAttachment()
               let imageSize = CGSize(width: 24, height: 20) // Adjust the size as needed
               imageAttachment.image = customImage.resized(to: imageSize)
               let imageString = NSAttributedString(attachment: imageAttachment)
               
               attributedString.append(imageString)
               
               // Add a space between the image and the text
               attributedString.append(NSAttributedString(string: " "))
           } else if let systemImage = systemImageName {
               // Add the system image to the attributed string
               if let systemImage = UIImage(systemName: systemImage)?.withTintColor(customColor).withRenderingMode(.alwaysTemplate) {
                   let imageAttachment = NSTextAttachment()
                   let imageSize = CGSize(width: 24, height: 20) // Adjust the size as needed
                   imageAttachment.image = systemImage.resized(to: imageSize)
                   let imageString = NSAttributedString(attachment: imageAttachment)
                   
                   attributedString.append(imageString)
                   
                   // Add a space between the image and the text
                   attributedString.append(NSAttributedString(string: " "))
               }
           }

           // Add the title to the attributed string with centered alignment
           let titleString = NSAttributedString(string: title, attributes: [NSAttributedString.Key.font: UIFont(name: "Poppins-SemiBold", size: 16) ?? UIFont.systemFont(ofSize: 12, weight: .bold), NSAttributedString.Key.foregroundColor: customColor, NSAttributedString.Key.baselineOffset: 3.0]) // Adjust the baselineOffset as needed
           attributedString.append(titleString)
        // Set the auto-shrink properties
           self.titleLabel?.numberOfLines = 1
           self.titleLabel?.adjustsFontSizeToFitWidth = true
           self.titleLabel?.minimumScaleFactor = 0.5 // Adjust as needed
           // Set the attributed string as the button's title
           self.setAttributedTitle(attributedString, for: .normal)
    }




    func backButtonStyle() {
        let customColor = UIColor.white
        
        // Create an attributed string with the system image and title
        let attributedString = NSMutableAttributedString()
        
        // Add the system image to the attributed string
        if let chevronImage = UIImage(systemName: "chevron.backward")?.withTintColor(customColor).withRenderingMode(.alwaysTemplate) {
            let imageAttachment = NSTextAttachment()
            let imageSize = CGSize(width: 8, height: 8) // Adjust the size as needed
            imageAttachment.image = chevronImage.resized(to: imageSize)
            let imageString = NSAttributedString(attachment: imageAttachment)
            
            attributedString.append(imageString)
            
            // Add a space between the image and the text
            attributedString.append(NSAttributedString(string: " "))
        }
        
        // Add the title ("back") to the attributed string
        let titleString = NSAttributedString(string: "Back", attributes: [NSAttributedString.Key.font: UIFont(name: "Poppins-SemiBold", size: 12) ?? UIFont.systemFont(ofSize: 12, weight: .bold), NSAttributedString.Key.foregroundColor: customColor])
        attributedString.append(titleString)

        // Set the attributed string as the button's title
        self.setAttributedTitle(attributedString, for: .normal)
    }
    func applyCustomStartButton() {
 
        if let customFont = UIFont(name: "Poppins-SemiBold", size: 25) {
            self.titleLabel?.font = customFont
            self.titleLabel?.adjustsFontSizeToFitWidth = true
            self.titleLabel?.minimumScaleFactor = 0.5

        } else {
            self.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        }
       
        self.setTitleColor(UIColor.black, for: .normal)
        self.setTitle("   Get Started", for: .normal)
       }
}
extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext() ?? self
    }
}
extension UITextField {
    func setIcon(_ image: UIImage) {
       let iconView = UIImageView(frame:
                      CGRect(x: 10, y: 5, width: 20, height: 20))
       iconView.image = image
       let iconContainerView: UIView = UIView(frame:
                      CGRect(x: 20, y: 0, width: 30, height: 30))
       iconContainerView.addSubview(iconView)
       leftView = iconContainerView
       leftViewMode = .always
    }
    func applyCustomPlaceholderStyle(size: String) {
        var placeholderAttributes: [NSAttributedString.Key: Any] = [:]
        if size == "large"{
            placeholderAttributes = [
                .foregroundColor: UIColor.lightGray,
                .font: UIFont(name: "Poppins-Regular", size: 10) ?? UIFont.systemFont(ofSize: 10)
            ]
        }else{
            placeholderAttributes = [
                .foregroundColor: UIColor.lightGray,
                .font: UIFont(name: "Poppins-Regular", size: 10) ?? UIFont.systemFont(ofSize: 10)
            ]
        }
           if let placeholder = self.placeholder {
               attributedPlaceholder = NSAttributedString(string: placeholder, attributes: placeholderAttributes)
           }
       }
    }

extension UITextView {
    func applySmallTextViewStyle() {
        if let customFont = UIFont(name: "Poppins-Medium", size: 11) {
            self.font = customFont
        } else {
            self.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        }
    
        self.textColor = UIColor.lightGray
    }
    func applyMediumTextViewStyle() {
        if let customFont = UIFont(name: "Poppins-Medium", size: 15) {
            self.font = customFont
        } else {
            self.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        }
    
        self.textColor = UIColor.black
    }
    func applySubtitleStyle() {
            self.font = UIFont.systemFont(ofSize: 12)
            self.textColor = UIColor.darkGray
           
        }
        func applyOFFERStyle() {
            self.font = UIFont.systemFont(ofSize: 12, weight: .bold)
            self.textColor = UIColor.white
            self.textAlignment = .center
           
        }
}
extension UIView{
    func cellBackViewShadow(){
        // Remove any existing shadows
               self.layer.shadowOpacity = 0.0
               self.layer.shadowOffset = CGSize(width: 0, height: 0)
               self.layer.shadowRadius = 0

               // Add shadow only to trailing and bottom edges
               self.layer.cornerRadius = 5
               self.layer.shadowColor = UIColor.darkGray.cgColor
               self.layer.shadowOpacity = 0.5
               self.layer.shadowOffset = CGSize(width: 3, height: 3)
               self.layer.shadowRadius = 4
               self.layer.masksToBounds = false
    }
}
extension Double {
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
func convertDateFormat(dateString: String) -> String? {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    
    let formats = ["yyyy/MM/dd", "yyyy-MM-dd"]
    
    for format in formats {
        dateFormatter.dateFormat = format
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "E, dd MMM yyyy"
            return dateFormatter.string(from: date)
        }
    }
    
    return nil
}
