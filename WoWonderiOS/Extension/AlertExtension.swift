import WoWonderTimelineSDK

import UIKit

extension UIViewController {
    func showAlert (title : String,message : String){
        let alert = UIAlertController(title: title, message:message , preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        self.present(alert, animated: true,completion: nil)
}

}
extension Double {
  func asString(style: DateComponentsFormatter.UnitsStyle) -> String {
    let formatter = DateComponentsFormatter()
    formatter.allowedUnits = [.hour, .minute, .second, .nanosecond]
    formatter.unitsStyle = style
    guard let formattedString = formatter.string(from: self) else { return "" }
    return formattedString
  }
}
extension Float {
    func toInt() -> Int? {
        if self > Float(Int.min) && self < Float(Int.max) {
            return Int(self)
        } else {
            return nil
        }
    }
}

extension UINavigationController {
    
    func popToViewController(ofClass: AnyClass, animated: Bool = true) {
        if let vc = viewControllers.filter({$0.isKind(of: ofClass)}).last {
            popToViewController(vc, animated: animated)
        }
    }
    
    func popViewControllers(viewsToPop: Int, animated: Bool = true) {
        if viewControllers.count > viewsToPop {
            let vc = viewControllers[viewControllers.count - viewsToPop - 1]
            popToViewController(vc, animated: animated)
        }
    }
}

