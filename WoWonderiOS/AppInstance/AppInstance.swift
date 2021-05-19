import WoWonderTimelineSDK
import Foundation
import CoreLocation
class AppInstance{
    static let instance  = AppInstance()
    var profile:FetchUserModel.FetchUserSuccessModel?
//    var siteSettings:Get_Site_SettingModel.Site_Setting_SuccessModel?
    var siteSettings = [String:Any]()
    var isBackGroundSelected:Bool = false
    var  musicSelected:Bool = false
    var isAlbumVisible:Bool = false
    var locationManager: CLLocationManager!
    var addCount:Int? = 0
    var longitude:Double? = 0.0
    var latitude:Double? = 0.0
    var is_SharePost: String? = nil
    var index: Int? = nil
    var connectivity_setting = "1"
    var userId:String? = UserData.getUSER_ID() ?? ""
    var sessionId:String? = UserData.getAccess_Token() ?? ""
    var genderText:String? = "all"
    var profilePicText:String? = "all"
    var statusText:String? = "all"
    
    
    var commingBackFromAddPost = false
    var vc: String? = nil
    
     func getProfile(){
               DispatchQueue.main.async {
                   FetchUserManager.instance.fetchProfile { (success, authError, error) in
                       if success != nil {
                        AppInstance.instance.profile = success
                        UserData.setUSER_NAME(AppInstance.instance.profile?.userData?.name)
                        UserData.setWallet(AppInstance.instance.profile?.userData?.wallet)
                        UserData.SetImage(AppInstance.instance.profile?.userData?.avatar)
                        UserData.SetisPro(AppInstance.instance.profile?.userData?.isPro)
                           }
                       else if authError != nil {
                       }
                       else if error != nil {
                           print(error?.localizedDescription)
                       }
                   }
               }
       }
    
    func utcToLocal(dateStr: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        if let date = dateFormatter.date(from: dateStr) {
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = "dd MMM yyyy"
            return dateFormatter.string(from: date)
        }
        return nil
    }
    
    func getUserSession()->Bool{
             log.verbose("getUserSession = \(UserDefaults.standard.getUserSessions(Key: Local.USER_SESSION.User_Session))")
             let localUserSessionData = UserDefaults.standard.getUserSessions(Key: Local.USER_SESSION.User_Session)
             if localUserSessionData.isEmpty{
                 return false
                 
             }else {
                 self.userId = localUserSessionData[Local.USER_SESSION.User_id] as? String
                 self.userId = UserData.getUSER_ID() ?? ""
                 self.sessionId = localUserSessionData[Local.USER_SESSION.Access_token] as? String
                 self.sessionId = UserData.getAccess_Token() ?? ""
                 return true
             }
             
         }
}
