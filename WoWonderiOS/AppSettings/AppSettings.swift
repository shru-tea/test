

import Foundation
import UIKit
import WoWonderTimelineSDK
struct AppConstant {
    //cert key for WoWonder
    //Demo Key
    /*
     VjFaV2IxVXdNVWhVYTJ4VlZrWndUbHBXVW5OamJHUnpXVE5vYTJFemFERlhhMmhoWVRBeGNXSkVSbGhoTWxKWVdsWldOR1JHVW5WWGJXeFdWa1JCTlNOV01uUlRVV3N3ZDA1VlZsZFdSVXBQVldwR1YwMUdaSEphUlhCUFZsUlZNVlJWVWtOWlYwWnlWMjVHVlZKc1NubFVWM2h6VG0xRmVsVnJPV2hoZWtWNlZqSjBVMkZ0VmxkaVJsWm9Vak5TVUZsc1ZYZGxRVDA5UURFek1XTTBOekZqT0dJMFpXUm1Oall5WkdRd1pXSm1OMkZrWmpOak0yUTNNelkxT0RNNFlqa2tNVGszTURNeU1UWT0=
     
    
     
     */
    
//    static let key = "VjFaV2IxVXdNVWhVYTJ4VlZrWndUbHBXVW5OamJHUnpXVE5vYTJFemFERlhhMmhoWVRBeGNXSkVSbGhoTWxKWVdsWldOR1JHVW5WWGJXeFdWa1JCTlNOV01uUlRVV3N3ZDA1VlZsZFdSVXBQVldwR1YwMUdaSEphUlhCUFZsUlZNVlJWVWtOWlYwWnlWMjVHVlZKc1NubFVWM2h6VG0xRmVsVnJPV2hoZWtWNlZqSjBVMkZ0VmxkaVJsWm9Vak5TVUZsc1ZYZGxRVDA5UURFek1XTTBOekZqT0dJMFpXUm1Oall5WkdRd1pXSm1OMkZrWmpOak0yUTNNelkxT0RNNFlqa2tNVGszTURNeU1UWT0="
//}
    
        static let key = "VjFaV2IxVXdNVWhVYTJ4VlZrWndUbHBXVW5Oa01XeDBUVmRHYTJKVmNGbFdiVEV3VkZkS1ZsZHFUbHBOUlZVMVZVWkZPVkJSUFQwalZqSjBVMUpyTlZaTlZWWlRWMGhDWVZaclduTk5SbVJ6Vld0a2FHRjZSa1ZVVlZKRFZERlplRmR0T1ZWU2JFcDZXVlJCTlZaWFJYcFZhelZPWWtWWk1WWXlkR3RTYXpWV1RWaFNXRmRIYUdGV2FrRjNaV2M5UFVCbFlqUTFPV0V4TlRjMVpEa3laVFUwWW1Rd05HWTJOak16WldWbFpqa3lPQ1F5TnpZek5UY3lPQT09"
    }

//struct ControlSettings {
//
//    static let showSocicalLogin = true
//    static let googleClientKey = "497109148599-u0g40f3e5uh53286hdrpsj10v505tral.apps.googleusercontent.com"
//     static let googleApiKey = "AIzaSyCdzU_y3YKo12pjsa3HBSCwqeLjbqf4zjc"
//    static let oneSignalAppId = "cebbb7d2-0f27-4e41-ab21-457fd841df34"
//    static let addUnitId = "ca-app-pub-3940256099942544/2934735716"
//      static let  interestialAddUnitId = "ca-app-pub-3940256099942544/4411468910"
//    static let BrainTreeURLScheme = "WoWonder-iOS-Timeline.iOS.App.ID.payments"
//     static let paypalAuthorizationToken = "sandbox_zjzj7brd_fzpwr2q9pk2m568s"
//
//    static var showFacebookLogin:Bool = false
//       static var showGoogleLogin:Bool = false
//    static var isShowSocicalLogin:Bool = false
//    static var ShowDownloadButton:Bool = true
//    static var shouldShowAddMobBanner:Bool = true
//    static var interestialCount:Int? = 3
//    static var showPaymentVC = true
//}



struct ControlSettings {
    
    static let showSocicalLogin = true
    static let googleClientKey = "497109148599-u0g40f3e5uh53286hdrpsj10v505tral.apps.googleusercontent.com"
     static let googleApiKey = "AIzaSyCdzU_y3YKo12pjsa3HBSCwqeLjbqf4zjc"
    static let oneSignalAppId = "cebbb7d2-0f27-4e41-ab21-457fd841df34"
    static let addUnitId = "ca-app-pub-3940256099942544/2934735716"
      static let  interestialAddUnitId = "ca-app-pub-3940256099942544/4411468910"
    static let BrainTreeURLScheme = "WoWonder-iOS-Timeline.iOS.App.ID.payments"
     static let paypalAuthorizationToken = "sandbox_zjzj7brd_fzpwr2q9pk2m568s"
    static let agoraCallingToken = "cea80c3b9a744f69ba90a68d07ca9167"
    static let merchantId = " merchant.com.WoWonderTimeline.Combine"
    static let applePayStat = true
    

    static let  inviteFriendText = "Please vist our website \(API.baseURL)"

    static var showFacebookLogin:Bool = false
       static var showGoogleLogin:Bool = false
    static var isShowSocicalLogin:Bool = false
    static var ShowDownloadButton:Bool = true
    static var shouldShowAddMobBanner:Bool = true
    static var interestialCount:Int? = 3
    static var showPaymentVC = true
    static let twilloCall = true
    static let agoraCall = false;
}


extension UIColor {
    @nonobjc class var mainColor: UIColor {
        return UIColor.hexStringToUIColor(hex: "#984243")
    }
    
    @nonobjc class var ButtonColor: UIColor {
        return UIColor.hexStringToUIColor(hex: "#984243")
    }
}
