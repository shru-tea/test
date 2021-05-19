
import Foundation
class GetUserListModel:BaseModel{
    struct GetUserListErrorModel: Codable {
        let apiStatus, apiText: String?
        let errors: Errors?
        
        enum CodingKeys: String, CodingKey {
            case apiStatus = "api_status"
            case apiText = "api_text"
            case errors
        }
    }
    
    struct Errors: Codable {
        let errorID, errorText: String?
        
        enum CodingKeys: String, CodingKey {
            case errorID = "error_id"
            case errorText = "error_text"
        }
    }

   
    
    struct GetUserListSuccessModel: Codable {
        let apiStatus: Int?
        let apiText, apiVersion: String?
        let themeURL: String?
        var users: [User]?
        let videoCall: Bool?
//        let videoCallUser:[JSONAny]?
        let audioCall: Bool?
//        let audioCallUser: [JSONAny]?
        let agoraCall: Bool?
//        var agoraCallData:[JSONAny]?
        
        enum CodingKeys: String, CodingKey {
            case apiStatus = "api_status"
            case apiText = "api_text"
            case apiVersion = "api_version"
            case themeURL = "theme_url"
            case users
            case videoCall = "video_call"
//            case videoCallUser = "video_call_user"
            case audioCall = "audio_call"
//            case audioCallUser = "audio_call_user"
            case agoraCall = "agora_call"
//            case agoraCallData = "agora_call_data"
        }
    }
  
    struct AgoraCallData: Codable {
        let data: DataClass?
        let userID: String?
        let avatar: String?
        let name: String?
        
        enum CodingKeys: String, CodingKey {
            case data
            case userID = "user_id"
            case avatar, name
        }
    }
    
    // MARK: - DataClass
    struct DataClass: Codable {
        let id, fromID, toID, type: String?
        let roomName, time, status: String?
        
        enum CodingKeys: String, CodingKey {
            case id
            case fromID = "from_id"
            case toID = "to_id"
            case type
            case roomName = "room_name"
            case time, status
        }
    }
    
    struct User: Codable {
        let userID, username, name: String?
        let avatar, coverPicture: String?
        let verified, lastseen, lastseenUnixTime, lastseenTimeText: String?
        let url: String?
        let chatColor, chatTime: String?
        let lastMessage: LastMessage?
        
        enum CodingKeys: String, CodingKey {
            case userID = "user_id"
            case username, name
            case avatar = "avatar"
            case coverPicture = "cover_picture"
            case verified, lastseen
            case lastseenUnixTime = "lastseen_unix_time"
            case lastseenTimeText = "lastseen_time_text"
            case url
            case chatColor = "chat_color"
            case chatTime = "chat_time"
            case lastMessage = "last_message"
        }
    }
    struct TwilloAudioCallData: Codable {
        let data: TwilloAudioCallDataClass?
        let userID: String?
        let avatar: String?
        let name: String?
        
        enum CodingKeys: String, CodingKey {
            case data
            case userID = "user_id"
            case avatar, name
        }
    }
    
    // MARK: - DataClass
    struct TwilloAudioCallDataClass: Codable {
        let id, callID, accessToken, callID2: String?
        let accessToken2, fromID, toID, roomName: String?
        let active, called, time, declined: String?
        let url: String?
        
        enum CodingKeys: String, CodingKey {
            case id
            case callID = "call_id"
            case accessToken = "access_token"
            case callID2 = "call_id_2"
            case accessToken2 = "access_token_2"
            case fromID = "from_id"
            case toID = "to_id"
            case roomName = "room_name"
            case active, called, time, declined, url
        }
    }
  
    struct TwilloVideoCallData: Codable {
        let data: TwilloVideoCallDataClass?
        let userID: String?
        let avatar: String?
        let name: String?
        
        enum CodingKeys: String, CodingKey {
            case data
            case userID = "user_id"
            case avatar, name
        }
    }
    
    struct TwilloVideoCallDataClass: Codable {
        let id, accessToken, accessToken2, fromID: String?
        let toID, roomName, active, called: String?
        let time, declined: String?
        let url: String?
        
        enum CodingKeys: String, CodingKey {
            case id
            case accessToken = "access_token"
            case accessToken2 = "access_token_2"
            case fromID = "from_id"
            case toID = "to_id"
            case roomName = "room_name"
            case active, called, time, declined, url
        }
    }
    
    struct LastMessage: Codable {
        let id, fromID, groupID, toID: String?
        let text, media, mediaFileName, mediaFileNames: String?
        let time, seen, deletedOne, deletedTwo: String?
        let sentPush, notificationID, typeTwo, stickers: String?
        let dateTime: String?
        let productId: String?
        
        enum CodingKeys: String, CodingKey {
            case id
            case fromID = "from_id"
            case groupID = "group_id"
            case toID = "to_id"
            case text, media, mediaFileName, mediaFileNames, time, seen
            case deletedOne = "deleted_one"
            case deletedTwo = "deleted_two"
            case sentPush = "sent_push"
            case notificationID = "notification_id"
            case typeTwo = "type_two"
            case stickers
            case dateTime = "date_time"
            case productId = "product_id"
        }
    }
    
    // MARK: Encode/decode helpers
    
    class JSONNull: Codable, Hashable {
        
        public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
            return true
        }
        
        public var hashValue: Int {
            return 0
        }
        
        public init() {}
        
        public required init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if !container.decodeNil() {
                throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
            }
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encodeNil()
        }
    }
    
    class JSONCodingKey: CodingKey {
        let key: String
        
        required init?(intValue: Int) {
            return nil
        }
        
        required init?(stringValue: String) {
            key = stringValue
        }
        
        var intValue: Int? {
            return nil
        }
        
        var stringValue: String {
            return key
        }
    }
    
    class JSONAny: Codable {
        let value: Any
        
        static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
            let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
            return DecodingError.typeMismatch(JSONAny.self, context)
        }
        
        static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
            let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
            return EncodingError.invalidValue(value, context)
        }
        
        static func decode(from container: SingleValueDecodingContainer) throws -> Any {
            if let value = try? container.decode(Bool.self) {
                return value
            }
            if let value = try? container.decode(Int64.self) {
                return value
            }
            if let value = try? container.decode(Double.self) {
                return value
            }
            if let value = try? container.decode(String.self) {
                return value
            }
            if container.decodeNil() {
                return JSONNull()
            }
            throw decodingError(forCodingPath: container.codingPath)
        }
        
        static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
            if let value = try? container.decode(Bool.self) {
                return value
            }
            if let value = try? container.decode(Int64.self) {
                return value
            }
            if let value = try? container.decode(Double.self) {
                return value
            }
            if let value = try? container.decode(String.self) {
                return value
            }
            if let value = try? container.decodeNil() {
                if value {
                    return JSONNull()
                }
            }
            if var container = try? container.nestedUnkeyedContainer() {
                return try decodeArray(from: &container)
            }
            if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
                return try decodeDictionary(from: &container)
            }
            throw decodingError(forCodingPath: container.codingPath)
        }
        
        static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
            if let value = try? container.decode(Bool.self, forKey: key) {
                return value
            }
            if let value = try? container.decode(Int64.self, forKey: key) {
                return value
            }
            if let value = try? container.decode(Double.self, forKey: key) {
                return value
            }
            if let value = try? container.decode(String.self, forKey: key) {
                return value
            }
            if let value = try? container.decodeNil(forKey: key) {
                if value {
                    return JSONNull()
                }
            }
            if var container = try? container.nestedUnkeyedContainer(forKey: key) {
                return try decodeArray(from: &container)
            }
            if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
                return try decodeDictionary(from: &container)
            }
            throw decodingError(forCodingPath: container.codingPath)
        }
        
        static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
            var arr: [Any] = []
            while !container.isAtEnd {
                let value = try decode(from: &container)
                arr.append(value)
            }
            return arr
        }
        
        static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
            var dict = [String: Any]()
            for key in container.allKeys {
                let value = try decode(from: &container, forKey: key)
                dict[key.stringValue] = value
            }
            return dict
        }
        
        static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
            for value in array {
                if let value = value as? Bool {
                    try container.encode(value)
                } else if let value = value as? Int64 {
                    try container.encode(value)
                } else if let value = value as? Double {
                    try container.encode(value)
                } else if let value = value as? String {
                    try container.encode(value)
                } else if value is JSONNull {
                    try container.encodeNil()
                } else if let value = value as? [Any] {
                    var container = container.nestedUnkeyedContainer()
                    try encode(to: &container, array: value)
                } else if let value = value as? [String: Any] {
                    var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
                    try encode(to: &container, dictionary: value)
                } else {
                    throw encodingError(forValue: value, codingPath: container.codingPath)
                }
            }
        }
        
        static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
            for (key, value) in dictionary {
                let key = JSONCodingKey(stringValue: key)!
                if let value = value as? Bool {
                    try container.encode(value, forKey: key)
                } else if let value = value as? Int64 {
                    try container.encode(value, forKey: key)
                } else if let value = value as? Double {
                    try container.encode(value, forKey: key)
                } else if let value = value as? String {
                    try container.encode(value, forKey: key)
                } else if value is JSONNull {
                    try container.encodeNil(forKey: key)
                } else if let value = value as? [Any] {
                    var container = container.nestedUnkeyedContainer(forKey: key)
                    try encode(to: &container, array: value)
                } else if let value = value as? [String: Any] {
                    var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
                    try encode(to: &container, dictionary: value)
                } else {
                    throw encodingError(forValue: value, codingPath: container.codingPath)
                }
            }
        }
        
        static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
            if let value = value as? Bool {
                try container.encode(value)
            } else if let value = value as? Int64 {
                try container.encode(value)
            } else if let value = value as? Double {
                try container.encode(value)
            } else if let value = value as? String {
                try container.encode(value)
            } else if value is JSONNull {
                try container.encodeNil()
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
        
        public required init(from decoder: Decoder) throws {
            if var arrayContainer = try? decoder.unkeyedContainer() {
                self.value = try JSONAny.decodeArray(from: &arrayContainer)
            } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
                self.value = try JSONAny.decodeDictionary(from: &container)
            } else {
                let container = try decoder.singleValueContainer()
                self.value = try JSONAny.decode(from: container)
            }
        }
        
        public func encode(to encoder: Encoder) throws {
            if let arr = self.value as? [Any] {
                var container = encoder.unkeyedContainer()
                try JSONAny.encode(to: &container, array: arr)
            } else if let dict = self.value as? [String: Any] {
                var container = encoder.container(keyedBy: JSONCodingKey.self)
                try JSONAny.encode(to: &container, dictionary: dict)
            } else {
                var container = encoder.singleValueContainer()
                try JSONAny.encode(to: &container, value: self.value)
            }
        }
    }

}
class GetUserListModelSingle:BaseModel{
    struct GetUserListModelSingleErrorModel: Codable {
        let apiStatus, apiText: String?
        let errors: Errors?
        
        enum CodingKeys: String, CodingKey {
            case apiStatus = "api_status"
            case apiText = "api_text"
            case errors
        }
    }
    
    struct Errors: Codable {
        let errorID, errorText: String?
        
        enum CodingKeys: String, CodingKey {
            case errorID = "error_id"
            case errorText = "error_text"
        }
    }

   
    
    struct GetUserListModelSingleSuccessModel: Codable {
        let apiStatus: Int?
        let apiText, apiVersion: String?
        let themeURL: String?
        var users: User?
        let videoCall: Bool?
//        let videoCallUser:[JSONAny]?
        let audioCall: Bool?
//        let audioCallUser: [JSONAny]?
        let agoraCall: Bool?
//        var agoraCallData:[JSONAny]?
        
        enum CodingKeys: String, CodingKey {
            case apiStatus = "api_status"
            case apiText = "api_text"
            case apiVersion = "api_version"
            case themeURL = "theme_url"
            case users
            case videoCall = "video_call"
//            case videoCallUser = "video_call_user"
            case audioCall = "audio_call"
//            case audioCallUser = "audio_call_user"
            case agoraCall = "agora_call"
//            case agoraCallData = "agora_call_data"
        }
    }
  
    struct AgoraCallData: Codable {
        let data: DataClass?
        let userID: String?
        let avatar: String?
        let name: String?
        
        enum CodingKeys: String, CodingKey {
            case data
            case userID = "user_id"
            case avatar, name
        }
    }
    
    // MARK: - DataClass
    struct DataClass: Codable {
        let id, fromID, toID, type: String?
        let roomName, time, status: String?
        
        enum CodingKeys: String, CodingKey {
            case id
            case fromID = "from_id"
            case toID = "to_id"
            case type
            case roomName = "room_name"
            case time, status
        }
    }
    
    struct User: Codable {
        let userID, username, name: String?
        let avatar, coverPicture: String?
        let verified, lastseen, lastseenUnixTime, lastseenTimeText: String?
        let url: String?
        let chatColor, chatTime: String?
        let lastMessage: LastMessage?
        
        enum CodingKeys: String, CodingKey {
            case userID = "user_id"
            case username, name
            case avatar = "avatar"
            case coverPicture = "cover_picture"
            case verified, lastseen
            case lastseenUnixTime = "lastseen_unix_time"
            case lastseenTimeText = "lastseen_time_text"
            case url
            case chatColor = "chat_color"
            case chatTime = "chat_time"
            case lastMessage = "last_message"
        }
    }
    struct TwilloAudioCallData: Codable {
        let data: TwilloAudioCallDataClass?
        let userID: String?
        let avatar: String?
        let name: String?
        
        enum CodingKeys: String, CodingKey {
            case data
            case userID = "user_id"
            case avatar, name
        }
    }
    
    // MARK: - DataClass
    struct TwilloAudioCallDataClass: Codable {
        let id, callID, accessToken, callID2: String?
        let accessToken2, fromID, toID, roomName: String?
        let active, called, time, declined: String?
        let url: String?
        
        enum CodingKeys: String, CodingKey {
            case id
            case callID = "call_id"
            case accessToken = "access_token"
            case callID2 = "call_id_2"
            case accessToken2 = "access_token_2"
            case fromID = "from_id"
            case toID = "to_id"
            case roomName = "room_name"
            case active, called, time, declined, url
        }
    }
  
    struct TwilloVideoCallData: Codable {
        let data: TwilloVideoCallDataClass?
        let userID: String?
        let avatar: String?
        let name: String?
        
        enum CodingKeys: String, CodingKey {
            case data
            case userID = "user_id"
            case avatar, name
        }
    }
    
    struct TwilloVideoCallDataClass: Codable {
        let id, accessToken, accessToken2, fromID: String?
        let toID, roomName, active, called: String?
        let time, declined: String?
        let url: String?
        
        enum CodingKeys: String, CodingKey {
            case id
            case accessToken = "access_token"
            case accessToken2 = "access_token_2"
            case fromID = "from_id"
            case toID = "to_id"
            case roomName = "room_name"
            case active, called, time, declined, url
        }
    }
    
    struct LastMessage: Codable {
        let id, fromID, groupID, toID: String?
        let text, media, mediaFileName, mediaFileNames: String?
        let time, seen, deletedOne, deletedTwo: String?
        let sentPush, notificationID, typeTwo, stickers: String?
        let dateTime: String?
        let productId: String?
        
        enum CodingKeys: String, CodingKey {
            case id
            case fromID = "from_id"
            case groupID = "group_id"
            case toID = "to_id"
            case text, media, mediaFileName, mediaFileNames, time, seen
            case deletedOne = "deleted_one"
            case deletedTwo = "deleted_two"
            case sentPush = "sent_push"
            case notificationID = "notification_id"
            case typeTwo = "type_two"
            case stickers
            case dateTime = "date_time"
            case productId = "product_id"
        }
    }
    
    // MARK: Encode/decode helpers
    
    class JSONNull: Codable, Hashable {
        
        public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
            return true
        }
        
        public var hashValue: Int {
            return 0
        }
        
        public init() {}
        
        public required init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if !container.decodeNil() {
                throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
            }
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encodeNil()
        }
    }
    
    class JSONCodingKey: CodingKey {
        let key: String
        
        required init?(intValue: Int) {
            return nil
        }
        
        required init?(stringValue: String) {
            key = stringValue
        }
        
        var intValue: Int? {
            return nil
        }
        
        var stringValue: String {
            return key
        }
    }
    
    class JSONAny: Codable {
        let value: Any
        
        static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
            let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
            return DecodingError.typeMismatch(JSONAny.self, context)
        }
        
        static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
            let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
            return EncodingError.invalidValue(value, context)
        }
        
        static func decode(from container: SingleValueDecodingContainer) throws -> Any {
            if let value = try? container.decode(Bool.self) {
                return value
            }
            if let value = try? container.decode(Int64.self) {
                return value
            }
            if let value = try? container.decode(Double.self) {
                return value
            }
            if let value = try? container.decode(String.self) {
                return value
            }
            if container.decodeNil() {
                return JSONNull()
            }
            throw decodingError(forCodingPath: container.codingPath)
        }
        
        static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
            if let value = try? container.decode(Bool.self) {
                return value
            }
            if let value = try? container.decode(Int64.self) {
                return value
            }
            if let value = try? container.decode(Double.self) {
                return value
            }
            if let value = try? container.decode(String.self) {
                return value
            }
            if let value = try? container.decodeNil() {
                if value {
                    return JSONNull()
                }
            }
            if var container = try? container.nestedUnkeyedContainer() {
                return try decodeArray(from: &container)
            }
            if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
                return try decodeDictionary(from: &container)
            }
            throw decodingError(forCodingPath: container.codingPath)
        }
        
        static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
            if let value = try? container.decode(Bool.self, forKey: key) {
                return value
            }
            if let value = try? container.decode(Int64.self, forKey: key) {
                return value
            }
            if let value = try? container.decode(Double.self, forKey: key) {
                return value
            }
            if let value = try? container.decode(String.self, forKey: key) {
                return value
            }
            if let value = try? container.decodeNil(forKey: key) {
                if value {
                    return JSONNull()
                }
            }
            if var container = try? container.nestedUnkeyedContainer(forKey: key) {
                return try decodeArray(from: &container)
            }
            if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
                return try decodeDictionary(from: &container)
            }
            throw decodingError(forCodingPath: container.codingPath)
        }
        
        static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
            var arr: [Any] = []
            while !container.isAtEnd {
                let value = try decode(from: &container)
                arr.append(value)
            }
            return arr
        }
        
        static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
            var dict = [String: Any]()
            for key in container.allKeys {
                let value = try decode(from: &container, forKey: key)
                dict[key.stringValue] = value
            }
            return dict
        }
        
        static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
            for value in array {
                if let value = value as? Bool {
                    try container.encode(value)
                } else if let value = value as? Int64 {
                    try container.encode(value)
                } else if let value = value as? Double {
                    try container.encode(value)
                } else if let value = value as? String {
                    try container.encode(value)
                } else if value is JSONNull {
                    try container.encodeNil()
                } else if let value = value as? [Any] {
                    var container = container.nestedUnkeyedContainer()
                    try encode(to: &container, array: value)
                } else if let value = value as? [String: Any] {
                    var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
                    try encode(to: &container, dictionary: value)
                } else {
                    throw encodingError(forValue: value, codingPath: container.codingPath)
                }
            }
        }
        
        static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
            for (key, value) in dictionary {
                let key = JSONCodingKey(stringValue: key)!
                if let value = value as? Bool {
                    try container.encode(value, forKey: key)
                } else if let value = value as? Int64 {
                    try container.encode(value, forKey: key)
                } else if let value = value as? Double {
                    try container.encode(value, forKey: key)
                } else if let value = value as? String {
                    try container.encode(value, forKey: key)
                } else if value is JSONNull {
                    try container.encodeNil(forKey: key)
                } else if let value = value as? [Any] {
                    var container = container.nestedUnkeyedContainer(forKey: key)
                    try encode(to: &container, array: value)
                } else if let value = value as? [String: Any] {
                    var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
                    try encode(to: &container, dictionary: value)
                } else {
                    throw encodingError(forValue: value, codingPath: container.codingPath)
                }
            }
        }
        
        static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
            if let value = value as? Bool {
                try container.encode(value)
            } else if let value = value as? Int64 {
                try container.encode(value)
            } else if let value = value as? Double {
                try container.encode(value)
            } else if let value = value as? String {
                try container.encode(value)
            } else if value is JSONNull {
                try container.encodeNil()
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
        
        public required init(from decoder: Decoder) throws {
            if var arrayContainer = try? decoder.unkeyedContainer() {
                self.value = try JSONAny.decodeArray(from: &arrayContainer)
            } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
                self.value = try JSONAny.decodeDictionary(from: &container)
            } else {
                let container = try decoder.singleValueContainer()
                self.value = try JSONAny.decode(from: container)
            }
        }
        
        public func encode(to encoder: Encoder) throws {
            if let arr = self.value as? [Any] {
                var container = encoder.unkeyedContainer()
                try JSONAny.encode(to: &container, array: arr)
            } else if let dict = self.value as? [String: Any] {
                var container = encoder.container(keyedBy: JSONCodingKey.self)
                try JSONAny.encode(to: &container, dictionary: dict)
            } else {
                var container = encoder.singleValueContainer()
                try JSONAny.encode(to: &container, value: self.value)
            }
        }
    }

}
struct CallDataModel: Codable {
    let agoraCallData: AgoraCallData?
    enum CodingKeys: String, CodingKey {
        case agoraCallData = "agora_call_data"
    }
}

// MARK: - AgoraCallData
struct AgoraCallData: Codable {
    let data: DataClass?
    let userID: String?
    let avatar: String?
    let name: String?
    
    enum CodingKeys: String, CodingKey {
        case data
        case userID = "user_id"
        case avatar, name
    }
}

// MARK: - DataClass
struct DataClass: Codable {
    let id, fromID, toID, type: String?
    let roomName, time, status: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case fromID = "from_id"
        case toID = "to_id"
        case type
        case roomName = "room_name"
        case time, status
    }
}
