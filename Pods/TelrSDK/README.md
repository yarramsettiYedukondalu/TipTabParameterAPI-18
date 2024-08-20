<p align="center">
<img
src='https://github.com/telrsdk/TelrSDK/blob/master/Example/TelrSDK/Images.xcassets/logo.imageset/Telr-logo-green-rgb-2000w.png' width="200"/>
</p>

# Telr iOS SDK

[![Version](https://img.shields.io/cocoapods/v/TelrSDK.svg?style=flat)](https://cocoapods.org/pods/TelrSDK)
[![License](https://img.shields.io/cocoapods/l/TelrSDK.svg?style=flat)](https://cocoapods.org/pods/TelrSDK)
[![Platform](https://img.shields.io/cocoapods/p/TelrSDK.svg?style=flat)](https://cocoapods.org/pods/TelrSDK)

This SDK enables you to accept payments in your iOS app. You can find our documentation [here](https://docs.telr.com).

## Requirements

Telr iOS SDK requires Xcode 11 or later and is compatible with apps targeting iOS 9 or above. We support Catalyst on macOS 10.15 or later. 

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

The SDK is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby

pod 'TelrSDK', "2.9.1"

```

Make sure you import the sdk where you want use it using below code

```ruby
import TelrSDK
```
Use this to set the details of store. Make sure you are using your store details

```ruby

let tabbyKEY:String = "<Tabby_Key_String>"

let KEY:String = " <YOUR_STORE_AUTH_KEY>" // TODO fill key
let STOREID:String = "<YOUR_STORE_ID>"  // TODO fill store id
let EMAIL:String = "<YOUR_EMAIL>" // TODO fill email id

```

## To call the payment page you can use either of the two methods

```python

//Mark:-If you want to change the back button as custom back button on navigation
let customBackButton = UIButton(type: .custom)
customBackButton.setTitle("Back", for: .normal)
customBackButton.setTitleColor(.black, for: .normal)

//Mark:-Use this to push the telr payment page.
paymentRequest = preparePaymentRequest()
let telrController = TelrController()
telrController.delegate = self
telrController.customBackButton = customBackButton
telrController.paymentRequest = paymentRequest!
self.navigationController?.pushViewController(telrController, animated: true)

//Mark:-Use this to present the telr payment page.
paymentRequest = preparePaymentRequestSaveCard(lastresponse: cardDetails)
let telrController = TelrController()
telrController.delegate = self
telrController.paymentRequest = paymentRequest!
let nav = UINavigationController(rootViewController: telrController)
self.navigationController?.present(nav, animated: true, completion: nil)

```


## Delegate method for get response from payment gateway

```python

//Mark:-This call when the payment is cancelled by user
func didPaymentCancel()
//Mark:-This call when the payment is successful.
func didPaymentSuccess(response:TelrResponseModel)
//Mark:-This call when the payment is declined due to any reason.
func didPaymentFail(messge:String)


```

Also confirm the delegate methods

```ruby
extension ViewController:TelrControllerDelegate{
    
    
    //Mark:- This method will be called when user clicks on back button
    func didPaymentCancel() {
        print("didPaymentCancel")
        
    }
    
    //Mark:- This method will be called when the payment is completed successfully
    func didPaymentSuccess(response: TelrResponseModel) {
        
        print("didPaymentSuccess")
           
        print("month \(String(describing: response.month))")
           
        print("year \(String(describing: response.year))")
              
        print("Trace \(String(describing: response.trace))")
        
        print("Status \(String(describing: response.status))")
        
        print("Avs \(String(describing: response.avs))")
        
        print("Code \(String(describing: response.code))")
        
        print("Ca_valid \(String(describing: response.ca_valid))")
        
        print("Card Code \(String(describing: response.cardCode))")
        
        print("Card Last4 \(String(describing: response.cardLast4))")
        
        print("CVV \(String(describing: response.cvv))")
        
        print("TransRef \(String(describing: response.transRef))")
        
        //To save the card for future transactions, you will be required to store tranRef. 
        //When the customer will be attempting transaction using the previously used card tranRef will be used
        
        self.displaySavedCard() 
    }
    
    //Mark:- This method will be called when user clicks on cancel button and the
    payment gets failed
    func didPaymentFail(messge: String) {
        print("didPaymentFail  \(messge)")
        
    }     
}

```

## Saved cards
It works locally using user default. Masked Card details will be deleted when app is deleted
```python

//Mark:- This returns masked card details of saved card.
let savedCard = TelrResponseModel().getSavedCards()

```

### To use Saved Card without CVV, please use below code while binding the payment request
```python

//Mark:- Set type as ‘sale’, class as ‘cont’ and send previous transaction reference in ‘ref’ parameter

paymentReq.transType = "sale"
paymentReq.transClass = "cont"
paymentReq.transRef = lastresponse.transRef ?? ""

```

### To use Saved Card with CVV, please use below code while binding the payment request
```python

//Mark:- Set type as ‘paypage’ and class as ‘ecom’ and send previous transaction reference in ‘firstref’ parameter

paymentReq.transType = "paypage"
paymentReq.transClass = "ecom"
paymentReq.transFirstRef = lastresponse.transFirstRef ?? ""

```

## Payment request builder for both saved card and new card

```python

//Mark:- Payment Request Builder
extension ViewController{
    
    private func preparePaymentRequest() -> PaymentRequest{
    
    
        let paymentReq = PaymentRequest()
    
        paymentReq.key = KEY
   
        paymentReq.store = STOREID
    
        paymentReq.appId = "123456789"
   
        paymentReq.appName = "TelrSDK"
    
        paymentReq.appUser = "123456"
    
        paymentReq.appVersion = "0.0.1"
    
        paymentReq.transTest = "1"//0
   
        paymentReq.transType = "paypage"
   
        paymentReq.transClass = "ecom"
    
        paymentReq.transCartid = String(arc4random())
    
        paymentReq.transDesc = "Test API"
    
        paymentReq.transCurrency = "AED"
    
        paymentReq.transAmount = amountTxt.text!
    
        paymentReq.billingEmail = EMAIL
        
        paymentReq.billingPhone = "8888888888"
    
        paymentReq.billingFName = self.firstNameTxt.text!
    
        paymentReq.billingLName = self.lastNameTxt.text!
    
        paymentReq.billingTitle = "Mr"
    
        paymentReq.city = "Dubai"
    
        paymentReq.country = "AE"
    
        paymentReq.region = "Dubai"
    
        paymentReq.address = "line 1"
        
        paymentReq.zip = "414202"
    
        paymentReq.language = "en"
    
        return paymentReq

    }
    
    private func preparePaymentRequestSaveCard(lastresponse:TelrResponseModel) -> PaymentRequest{

     
        let paymentReq = PaymentRequest()
     
        paymentReq.key = lastresponse.key ?? ""
     
        paymentReq.store = lastresponse.store ?? ""
     
        paymentReq.appId = lastresponse.appId ?? ""
     
        paymentReq.appName = lastresponse.appName ?? ""
     
        paymentReq.appUser = lastresponse.appUser ?? ""
     
        paymentReq.appVersion = lastresponse.appVersion ?? ""
     
        paymentReq.transTest = lastresponse.transTest ?? ""
        
//        //Mark:- Without CVV
//
//        paymentReq.transType = "sale"
//
//        paymentReq.transClass = "cont"
        
//        paymentReq.transRef = lastresponse.transRef ?? ""
        
        
        //Mark:- With CVV

        paymentReq.transType = "paypage"

        paymentReq.transClass = "ecom"
        
        paymentReq.transFirstRef = lastresponse.transFirstRef ?? ""
        
        //
        
        paymentReq.transCartid = String(arc4random())
     
        paymentReq.transDesc = lastresponse.transDesc ?? ""
     
        paymentReq.transCurrency = lastresponse.transCurrency ?? ""
     
        paymentReq.billingFName = lastresponse.billingFName ?? ""
     
        paymentReq.billingLName = lastresponse.billingLName ?? ""
     
        paymentReq.billingTitle = lastresponse.billingTitle ?? ""
     
        paymentReq.city = lastresponse.city ?? ""
     
        paymentReq.country = lastresponse.country ?? ""
     
        paymentReq.region = lastresponse.region ?? ""
     
        paymentReq.address = lastresponse.address ?? ""
        
        paymentReq.zip = lastresponse.zip ?? ""
     
        paymentReq.transAmount = amountTxt.text!
            
        paymentReq.billingEmail = lastresponse.billingEmail ?? ""
     
        paymentReq.billingPhone = lastresponse.billingPhone ?? ""
     
        paymentReq.language = "en"
     
        return paymentReq

     }
}
```

## Support

If you have questions or need help, please contact support@telr.com.

## License

This repository is available under the [MIT license](LICENSE).
