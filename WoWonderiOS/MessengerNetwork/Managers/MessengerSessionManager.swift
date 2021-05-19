

import Foundation
import Alamofire
import WoWonderTimelineSDK


class MessengerSessionManager{
    
    static let instance = SessionManager()
    
    func getSession( session_Token: String,type: String,completionBlock :@escaping (_ Success:MessengerSessionModel.MessengerSessionSuccessModel?,_ AuthError:MessengerSessionModel.SessionErrorModel?,_ ServerKeyError:MessengerSessionModel.ServerKeyErrorModel?, Error?)->()){
        
        let params = [
            API.Params.ServerKey : API.SERVER_KEY.Server_Key,
            API.Params.sessionType:type
            ] as [String : Any]
        
        let jsonData = try! JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData, encoding: .utf8)!
        log.verbose("Decoded String = \(decoded)")
        log.verbose("API = \(API.SESSION_API.GET_SESSIONS_API)")
        Alamofire.request(API.SESSION_API.GET_SESSIONS_API + "\(session_Token)", method: .post, parameters: params, encoding:URLEncoding.default , headers: nil).responseJSON { (response) in
            if (response.result.value != nil){
                guard let res = response.result.value as? [String:Any] else {return}
                log.verbose("Response = \(res)")
                guard let apiStatus = res["api_status"]  as? Any else {return}
                if apiStatus is Int{
                    log.verbose("apiStatus Int = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value, options: [])
                    let result = try? JSONDecoder().decode(MessengerSessionModel.MessengerSessionSuccessModel.self, from: data!)
                    completionBlock(result,nil,nil,nil)
                }else{
                    let apiStatusString = apiStatus as? String
                    if apiStatusString == "400" {
                        log.verbose("apiStatus String = \(apiStatus)")
                        let data = try? JSONSerialization.data(withJSONObject: response.value, options: [])
                        let result = try? JSONDecoder().decode(MessengerSessionModel.SessionErrorModel.self, from: data!)
                        log.error("AuthError = \(result?.errors?.errorText)")
                        completionBlock(nil,result,nil,nil)
                    }else if apiStatusString == "404" {
                        let data = try? JSONSerialization.data(withJSONObject: response.value, options: [])
                        let result = try? JSONDecoder().decode(MessengerSessionModel.ServerKeyErrorModel.self, from: data!)
                        log.error("AuthError = \(result?.errors!.errorText)")
                        completionBlock(nil,nil,result,nil)
                    }
                }
            }else{
                log.error("error = \(response.error?.localizedDescription)")
                completionBlock(nil,nil,nil,response.error)
            }
        }
    }
    func deleteSession(session_Token: String, type: String,id:String,completionBlock :@escaping (_ Success:MessengerDeleteSessionModel.MessengerDeleteSessionSuccessModel?,_ AuthError:MessengerDeleteSessionModel.DeleteSessionErrorModel?,_ ServerKeyError:MessengerDeleteSessionModel.ServerKeyErrorModel?, Error?)->()){
        let params = [
            
            API.Params.ServerKey : API.SERVER_KEY.Server_Key,
            API.Params.sessionType:type,
            API.Params.Id:id
            ] as [String : Any]
        let jsonData = try! JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData, encoding: .utf8)!
        log.verbose("Decoded String = \(decoded)")
        log.verbose("API = \(API.SESSION_API.DELETE_SESSIONS_API)")
        Alamofire.request(API.SESSION_API.DELETE_SESSIONS_API + "\(session_Token)", method: .post, parameters: params, encoding:URLEncoding.default , headers: nil).responseJSON { (response) in
            if (response.result.value != nil){
                guard let res = response.result.value as? [String:Any] else {return}
                log.verbose("Response = \(res)")
                guard let apiStatus = res["api_status"]  as? Any else {return}
                if apiStatus is Int{
                    log.verbose("apiStatus Int = \(apiStatus)")
                    let data = try! JSONSerialization.data(withJSONObject: response.value, options: [])
                    let result = try! JSONDecoder().decode(MessengerDeleteSessionModel.MessengerDeleteSessionSuccessModel.self, from: data)
                    completionBlock(result,nil,nil,nil)
                }else{
                    let apiStatusString = apiStatus as? String
                    if apiStatusString == "400" {
                        log.verbose("apiStatus String = \(apiStatus)")
                        let data = try! JSONSerialization.data(withJSONObject: response.value, options: [])
                        let result = try! JSONDecoder().decode(MessengerDeleteSessionModel.DeleteSessionErrorModel.self, from: data)
                        log.error("AuthError = \(result.errors?.errorText)")
                        completionBlock(nil,result,nil,nil)
                    }else if apiStatusString == "404" {
                        let data = try! JSONSerialization.data(withJSONObject: response.value, options: [])
                        let result = try! JSONDecoder().decode(MessengerDeleteSessionModel.ServerKeyErrorModel.self, from: data)
                        log.error("AuthError = \(result.errors!.errorText)")
                        completionBlock(nil,nil,result,nil)
                    }
                }
            }else{
                log.error("error = \(response.error?.localizedDescription)")
                completionBlock(nil,nil,nil,response.error)
            }
        }
    }
}
