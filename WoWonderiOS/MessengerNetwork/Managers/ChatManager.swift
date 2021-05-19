
import Foundation
import Alamofire
import WoWonderTimelineSDK
class ChatManager{
    
    static let instance = ChatManager()
    
    func getUserChats(user_id: String, session_Token: String,receipent_id:String, completionBlock: @escaping (_ Success:UserChatModel.UserChatSuccessModel?,_ AuthError:UserChatModel.UserChatErrorModel?,_ ServerKeyError:UserChatModel.ServerKeyErrorModel?, Error?) ->()){
        let convertUserId = Int(user_id)
        let covertedReceipientId = Int(receipent_id)
        let params = [
            API.Params.session_token : session_Token,
            API.Params.user_id : convertUserId,
            API.Params.RecipientId : covertedReceipientId,
            API.Params.ServerKey : API.SERVER_KEY.Server_Key
            ] as [String : Any]
        
        let jsonData = try! JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData, encoding: .utf8)!
        log.verbose("Decoded String = \(decoded)")
         log.verbose("API  = \(API.Chat_Methods.GET_USER_CHATS_API)")
        
        Alamofire.request(API.Chat_Methods.GET_USER_CHATS_API, method: .post, parameters: params, encoding:URLEncoding.default , headers: nil).responseJSON { (response) in
            print(params)
            if (response.result.value != nil){
                guard let res = response.result.value as? [String:Any] else {return}
                log.verbose("Response = \(res)")
                guard let apiStatus = res["api_status"]  as? Any else {return}
                if apiStatus is String{
                    log.verbose("apiStatus Int = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value, options: [])
                    let result = try? JSONDecoder().decode(UserChatModel.UserChatSuccessModel.self, from: data!)
                    log.debug("Success = \(result?.messages ?? nil)")
                    completionBlock(result,nil,nil,nil)
                }else{
                    let apiStatusString = apiStatus as? String
                    if apiStatusString == "400" {
                        log.verbose("apiStatus String = \(apiStatus)")
                        let data = try? JSONSerialization.data(withJSONObject: response.value, options: [])
                        let result = try? JSONDecoder().decode(UserChatModel.UserChatErrorModel.self, from: data!)
                        log.error("AuthError = \(result?.errors!.errorText)")
                        completionBlock(nil,result,nil,nil)
                    }else if apiStatusString == "404" {
                        let data = try? JSONSerialization.data(withJSONObject: response.value, options: [])
                        let result = try? JSONDecoder().decode(UserChatModel.ServerKeyErrorModel.self, from: data!)
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
    func deleteChat(user_id: String,session_Token: String, completionBlock: @escaping (_ Success:DeleteChatModel.DeleteChatSuccessModel?,_ AuthError:DeleteChatModel.DeleteChatErrorModel?,_ ServerKeyError:DeleteChatModel.ServerKeyErrorModel?, Error?) ->()){
        let convertUserId = Int(user_id)
     
        let params = [
            API.Params.user_id : convertUserId,
            API.Params.ServerKey : API.SERVER_KEY.Server_Key
            ] as [String : Any]
        
        let jsonData = try! JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData, encoding: .utf8)!
        log.verbose("Decoded String = \(decoded)")
        Alamofire.request(API.Chat_Methods.DELETE_CHAT_API + "\(session_Token)", method: .post, parameters: params, encoding:URLEncoding.default , headers: nil).responseJSON { (response) in
            if (response.result.value != nil){
                guard let res = response.result.value as? [String:Any] else {return}
                log.verbose("Response = \(res)")
                guard let apiStatus = res["api_status"]  as? Any else {return}
                if apiStatus is Int{
                    log.verbose("apiStatus Int = \(apiStatus)")
                    let data = try! JSONSerialization.data(withJSONObject: response.value, options: [])
                    let result = try! JSONDecoder().decode(DeleteChatModel.DeleteChatSuccessModel.self, from: data)
                    log.debug("Success = \(result.message ?? nil)")
                    completionBlock(result,nil,nil,nil)
                }else{
                    let apiStatusString = apiStatus as? String
                    if apiStatusString == "400" {
                        log.verbose("apiStatus String = \(apiStatus)")
                        let data = try! JSONSerialization.data(withJSONObject: response.value, options: [])
                        let result = try! JSONDecoder().decode(DeleteChatModel.DeleteChatErrorModel.self, from: data)
                        log.error("AuthError = \(result.errors!.errorText)")
                        completionBlock(nil,result,nil,nil)
                    }else if apiStatusString == "404" {
                        let data = try! JSONSerialization.data(withJSONObject: response.value, options: [])
                        let result = try! JSONDecoder().decode(DeleteChatModel.ServerKeyErrorModel.self, from: data)
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
    func sendMessage(message_hash_id: Int,receipent_id:String,text:String,session_Token:String, completionBlock: @escaping (_ Success:SendMessageModel.SendMessageSuccessModel?,_ AuthError:SendMessageModel.SendMessageErrorModel?,_ ServerKeyError:SendMessageModel.ServerKeyErrorModel?, Error?) ->()){
        
        let covertedReceipientId = Int(receipent_id)
        let convertedHashID = "\(message_hash_id)"
        let params = [
            API.Params.MessageHashId : convertedHashID,
            API.Params.user_id : covertedReceipientId,
            API.Params.Text : text,
            API.Params.ServerKey : API.SERVER_KEY.Server_Key
            ] as [String : Any]
        
        let jsonData = try! JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData, encoding: .utf8)!
        log.verbose("Decoded String = \(decoded)")
        Alamofire.request(API.Chat_Methods.SEND_MESSAGE_API + "\(session_Token)", method: .post, parameters: params, encoding:URLEncoding.default , headers: nil).responseJSON { (response) in
            log.verbose("Response = \(response.result.value)")
            if (response.result.value != nil){
                guard let res = response.result.value as? [String:Any] else {return}
                
                guard let apiStatus = res["api_status"]  as? Any else {return}
                if apiStatus is Int{
                    log.verbose("apiStatus Int = \(apiStatus)")
                    let data = try! JSONSerialization.data(withJSONObject: response.value, options: [])
                    let result = try! JSONDecoder().decode(SendMessageModel.SendMessageSuccessModel.self, from: data)
                    log.debug("Success = \(result.messageData ?? nil)")
                    completionBlock(result,nil,nil,nil)
                }else{
                    let apiStatusString = apiStatus as? String
                    if apiStatusString == "400" {
                        log.verbose("apiStatus String = \(apiStatus)")
                        let data = try! JSONSerialization.data(withJSONObject: response.value, options: [])
                        let result = try! JSONDecoder().decode(SendMessageModel.SendMessageErrorModel.self, from: data)
                        log.error("AuthError = \(result.errors!.errorText)")
                        completionBlock(nil,result,nil,nil)
                    }else if apiStatusString == "404" {
                        let data = try! JSONSerialization.data(withJSONObject: response.value, options: [])
                        let result = try! JSONDecoder().decode(SendMessageModel.ServerKeyErrorModel.self, from: data)
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
    func sendChatData(message_hash_id: Int,receipent_id:String,session_Token: String,type:String,image_data:Data?,video_data:Data?,imageMimeType:String?,videoMimeType:String?,text:String,file_data:Data?,file_Extension:String?,fileMimeType:String?, completionBlock: @escaping (_ Success:SendMessageModel.SendMessageSuccessModel?,_ AuthError:SendMessageModel.SendMessageErrorModel?,_ ServerKeyError:SendMessageModel.ServerKeyErrorModel?, Error?) ->()){
        
        let covertedReceipientId = Int(receipent_id)
        let params = [
//             API.Params.Text : text,
            API.Params.MessageHashId : message_hash_id,
            API.Params.user_id : receipent_id,
            API.Params.ServerKey : API.SERVER_KEY.Server_Key
            ] as [String : Any]
        
        let jsonData = try! JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData, encoding: .utf8)!
        log.verbose("Decoded String = \(decoded)")
        let headers: HTTPHeaders = [
            "Content-type": "multipart/form-data"
        ]
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in params {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            if type == "image"{
                if let data = image_data{
                    multipartFormData.append(data, withName:"file", fileName: "image.jpg", mimeType: imageMimeType ?? "")
                }
                
            }else if type == "video"{
                if let data = video_data{
                    multipartFormData.append(data, withName: "file", fileName: "video.mp4", mimeType: videoMimeType ?? "")
                }
                
            }else{
                if let fileData = file_data{
                    multipartFormData.append(fileData, withName: "file", fileName: "file.\(file_Extension ?? "")", mimeType: fileMimeType ?? "")
                }
                
            }
            
        }, usingThreshold: UInt64.init(), to: API.Chat_Methods.SEND_MESSAGE_API + "\(session_Token)", method: .post, headers: headers) { (result) in
            switch result{
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    print("Succesfully uploaded")
                    log.verbose("response = \(response.result.value)")
                    if (response.result.value != nil){
                        guard let res = response.result.value as? [String:Any] else {return}
                        log.verbose("Response = \(res)")
                        guard let apiStatus = res["api_status"]  as? Any else {return}
                        if apiStatus is Int{
                            log.verbose("apiStatus Int = \(apiStatus)")
                            let data = try! JSONSerialization.data(withJSONObject: response.value, options: [])
                            let result = try! JSONDecoder().decode(SendMessageModel.SendMessageSuccessModel.self, from: data)
                            log.debug("Success = \(result.apiStatus ?? nil)")
                            completionBlock(result,nil,nil,nil)
                        }else{
                            let apiStatusString = apiStatus as? String
                            if apiStatusString == "400" {
                                log.verbose("apiStatus String = \(apiStatus)")
                                let data = try! JSONSerialization.data(withJSONObject: response.value, options: [])
                                let result = try! JSONDecoder().decode(SendMessageModel.SendMessageErrorModel.self, from: data)
                                log.error("AuthError = \(result.errors!.errorText)")
                                completionBlock(nil,result,nil,nil)
                            }else if apiStatusString == "404" {
                                let data = try! JSONSerialization.data(withJSONObject: response.value, options: [])
                                let result = try! JSONDecoder().decode(SendMessageModel.ServerKeyErrorModel.self, from: data)
                                log.error("AuthError = \(result.errors!.errorText)")
                                completionBlock(nil,nil,result,nil)
                            }
                        }
                    }else{
                        log.error("error = \(response.error?.localizedDescription)")
                        completionBlock(nil,nil,nil,response.error)
                    }
                    
                }
            case .failure(let error):
                log.verbose("Error in upload: \(error.localizedDescription)")
                completionBlock(nil,nil,nil,error)
                
            }
        }
    }
    func sendContact(message_hash_id: Int,receipent_id:String,jsonPayload:String,session_Token:String,Contact:String = "1", completionBlock: @escaping (_ Success:SendMessageModel.SendMessageSuccessModel?,_ AuthError:SendMessageModel.SendMessageErrorModel?,_ ServerKeyError:SendMessageModel.ServerKeyErrorModel?, Error?) ->()){
        
        let covertedReceipientId = Int(receipent_id)
        let convertedHashID = "\(message_hash_id)"
        let params = [
            API.Params.MessageHashId : convertedHashID,
            API.Params.user_id : covertedReceipientId,
            API.Params.Text : jsonPayload,
            API.Params.Contact : Contact,
            API.Params.ServerKey : API.SERVER_KEY.Server_Key
            ] as [String : Any]
        
        let jsonData = try! JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData, encoding: .utf8)!
        log.verbose("Decoded String = \(decoded)")
        Alamofire.request(API.Chat_Methods.SEND_MESSAGE_API + "\(session_Token)", method: .post, parameters: params, encoding:URLEncoding.default , headers: nil).responseJSON { (response) in
            log.verbose("Response = \(response.result.value)")
            if (response.result.value != nil){
                guard let res = response.result.value as? [String:Any] else {return}
                
                guard let apiStatus = res["api_status"]  as? Any else {return}
                if apiStatus is Int{
                    log.verbose("apiStatus Int = \(apiStatus)")
                    let data = try! JSONSerialization.data(withJSONObject: response.value, options: [])
                    let result = try! JSONDecoder().decode(SendMessageModel.SendMessageSuccessModel.self, from: data)
                    log.debug("Success = \(result.messageData ?? nil)")
                    completionBlock(result,nil,nil,nil)
                }else{
                    let apiStatusString = apiStatus as? String
                    if apiStatusString == "400" {
                        log.verbose("apiStatus String = \(apiStatus)")
                        let data = try! JSONSerialization.data(withJSONObject: response.value, options: [])
                        let result = try! JSONDecoder().decode(SendMessageModel.SendMessageErrorModel.self, from: data)
                        log.error("AuthError = \(result.errors!.errorText)")
                        completionBlock(nil,result,nil,nil)
                    }else if apiStatusString == "404" {
                        let data = try! JSONSerialization.data(withJSONObject: response.value, options: [])
                        let result = try! JSONDecoder().decode(SendMessageModel.ServerKeyErrorModel.self, from: data)
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
    func deleteChatMessage(messageId: String,session_Token: String, completionBlock: @escaping (_ Success:DeleteChatModel.DeleteChatSuccessModel?,_ AuthError:DeleteChatModel.DeleteChatErrorModel?,_ ServerKeyError:DeleteChatModel.ServerKeyErrorModel?, Error?) ->()){
        
           let params = [
               API.Params.message_id : messageId,
               API.Params.ServerKey : API.SERVER_KEY.Server_Key
               ] as [String : Any]
           
           let jsonData = try! JSONSerialization.data(withJSONObject: params, options: [])
           let decoded = String(data: jsonData, encoding: .utf8)!
           log.verbose("Decoded String = \(decoded)")
           Alamofire.request(API.Chat_Methods.DELETE_MESSAGE_API + "\(session_Token)", method: .post, parameters: params, encoding:URLEncoding.default , headers: nil).responseJSON { (response) in
               if (response.result.value != nil){
                   guard let res = response.result.value as? [String:Any] else {return}
                   log.verbose("Response = \(res)")
                   guard let apiStatus = res["api_status"]  as? Any else {return}
                   if apiStatus is Int{
                       log.verbose("apiStatus Int = \(apiStatus)")
                       let data = try! JSONSerialization.data(withJSONObject: response.value, options: [])
                       let result = try! JSONDecoder().decode(DeleteChatModel.DeleteChatSuccessModel.self, from: data)
                       log.debug("Success = \(result.message ?? nil)")
                       completionBlock(result,nil,nil,nil)
                   }else{
                       let apiStatusString = apiStatus as? String
                       if apiStatusString == "400" {
                           log.verbose("apiStatus String = \(apiStatus)")
                           let data = try! JSONSerialization.data(withJSONObject: response.value, options: [])
                           let result = try! JSONDecoder().decode(DeleteChatModel.DeleteChatErrorModel.self, from: data)
                           log.error("AuthError = \(result.errors!.errorText)")
                           completionBlock(nil,result,nil,nil)
                       }else if apiStatusString == "404" {
                           let data = try! JSONSerialization.data(withJSONObject: response.value, options: [])
                           let result = try! JSONDecoder().decode(DeleteChatModel.ServerKeyErrorModel.self, from: data)
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
    
    
    func sendGIF(message_hash_id: Int,receipent_id:String,URl:String,session_Token:String, completionBlock: @escaping (_ Success:SendMessageModel.SendMessageSuccessModel?,_ AuthError:SendMessageModel.SendMessageErrorModel?,_ ServerKeyError:SendMessageModel.ServerKeyErrorModel?, Error?) ->()){
        
        let covertedReceipientId = Int(receipent_id)
        let convertedHashID = "\(message_hash_id)"
        let params = [
            API.Params.MessageHashId : convertedHashID,
            API.Params.user_id : covertedReceipientId,
            "gif" : URl,
            API.Params.ServerKey : API.SERVER_KEY.Server_Key
            ] as [String : Any]
        
        let jsonData = try! JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData, encoding: .utf8)!
        log.verbose("Decoded String = \(decoded)")
        Alamofire.request(API.Chat_Methods.SEND_MESSAGE_API + "\(session_Token)", method: .post, parameters: params, encoding:URLEncoding.default , headers: nil).responseJSON { (response) in
            log.verbose("Response = \(response.result.value)")
            if (response.result.value != nil){
                guard let res = response.result.value as? [String:Any] else {return}
                
                guard let apiStatus = res["api_status"]  as? Any else {return}
                if apiStatus is Int{
                    log.verbose("apiStatus Int = \(apiStatus)")
                    let data = try! JSONSerialization.data(withJSONObject: response.value, options: [])
                    let result = try! JSONDecoder().decode(SendMessageModel.SendMessageSuccessModel.self, from: data)
                    log.debug("Success = \(result.messageData ?? nil)")
                    completionBlock(result,nil,nil,nil)
                }else{
                    let apiStatusString = apiStatus as? String
                    if apiStatusString == "400" {
                        log.verbose("apiStatus String = \(apiStatus)")
                        let data = try! JSONSerialization.data(withJSONObject: response.value, options: [])
                        let result = try! JSONDecoder().decode(SendMessageModel.SendMessageErrorModel.self, from: data)
                        log.error("AuthError = \(result.errors!.errorText)")
                        completionBlock(nil,result,nil,nil)
                    }else if apiStatusString == "404" {
                        let data = try! JSONSerialization.data(withJSONObject: response.value, options: [])
                        let result = try! JSONDecoder().decode(SendMessageModel.ServerKeyErrorModel.self, from: data)
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


