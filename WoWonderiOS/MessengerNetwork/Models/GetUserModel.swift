//
//  GetUserModel.swift
//  WoWonderiOS
//
//  Created by Muhammad Haris Butt on 8/20/20.
//  Copyright © 2020 clines329. All rights reserved.
//

import Foundation
class GetUserMModel:BaseModel{
 
 struct GetUserSuccessModel: Codable {
     let apiStatus: Int?
     let userData: UserData?

     enum CodingKeys: String, CodingKey {
         case apiStatus = "api_status"
         case userData = "user_data"
     }
 }

    struct GetUserErrorModel: Codable {
          let apiStatus: String?
          let errors: Errors?
          
          enum CodingKeys: String, CodingKey {
              case apiStatus = "api_status"
              case errors
          }
      }
      
      struct Errors: Codable {
          let errorID: Int?
          let errorText: String?
          
          enum CodingKeys: String, CodingKey {
              case errorID = "error_id"
              case errorText = "error_text"
          }
      }
 // MARK: - UserData
 struct UserData: Codable {
     let userID, username, email, firstName: String?
     let lastName: String?
     let avatar, cover: String?
     let backgroundImage, relationshipID, address, working: String?
     let workingLink, about, school, gender: String?
     let birthday, countryID, website, facebook: String?
     let google, twitter, linkedin, youtube: String?
     let vk, instagram, language, ipAddress: String?
     let followPrivacy, friendPrivacy, postPrivacy, messagePrivacy: String?
     let confirmFollowers, showActivitiesPrivacy, birthPrivacy, visitPrivacy: String?
     let verified, lastseen, emailNotification, eLiked: String?
     let eWondered, eShared, eFollowed, eCommented: String?
     let eVisited, eLikedPage, eMentioned, eJoinedGroup: String?
     let eAccepted, eProfileWallPost, eSentmeMsg, eLastNotif: String?
     let notificationSettings, status, active, admin: String?
     let registered, phoneNumber, isPro, proType: String?
     let timezone, referrer, refUserID, balance: String?
     let paypalEmail, notificationsSound, orderPostsBy, androidMDeviceID: String?
     let iosMDeviceID, androidNDeviceID, iosNDeviceID, webDeviceID: String?
     let wallet, lat, lng, lastLocationUpdate: String?
     let shareMyLocation, lastDataUpdate: String?
     let details: Details?
     let lastAvatarMod, lastCoverMod, points, dailyPoints: String?
     let pointDayExpire, lastFollowID, shareMyData, lastLoginData: String?
     let twoFactor, newEmail, twoFactorVerified, newPhone: String?
     let infoFile, city, state, zip: String?
     let schoolCompleted, weatherUnit, paystackRef, userPlatform: String?
     let url: String?
     let name: String?
     let mutualFriendsData: [String]?
     let lastseenUnixTime, lastseenStatus: String?
     let isFollowing, canFollow, isFollowingMe: Int?
     let genderText, lastseenTimeText: String?
     let isBlocked: Bool?

     enum CodingKeys: String, CodingKey {
         case userID = "user_id"
         case username, email
         case firstName = "first_name"
         case lastName = "last_name"
         case avatar, cover
         case backgroundImage = "background_image"
         case relationshipID = "relationship_id"
         case address, working
         case workingLink = "working_link"
         case about, school, gender, birthday
         case countryID = "country_id"
         case website, facebook, google, twitter, linkedin, youtube, vk, instagram, language
         case ipAddress = "ip_address"
         case followPrivacy = "follow_privacy"
         case friendPrivacy = "friend_privacy"
         case postPrivacy = "post_privacy"
         case messagePrivacy = "message_privacy"
         case confirmFollowers = "confirm_followers"
         case showActivitiesPrivacy = "show_activities_privacy"
         case birthPrivacy = "birth_privacy"
         case visitPrivacy = "visit_privacy"
         case verified, lastseen, emailNotification
         case eLiked = "e_liked"
         case eWondered = "e_wondered"
         case eShared = "e_shared"
         case eFollowed = "e_followed"
         case eCommented = "e_commented"
         case eVisited = "e_visited"
         case eLikedPage = "e_liked_page"
         case eMentioned = "e_mentioned"
         case eJoinedGroup = "e_joined_group"
         case eAccepted = "e_accepted"
         case eProfileWallPost = "e_profile_wall_post"
         case eSentmeMsg = "e_sentme_msg"
         case eLastNotif = "e_last_notif"
         case notificationSettings = "notification_settings"
         case status, active, admin, registered
         case phoneNumber = "phone_number"
         case isPro = "is_pro"
         case proType = "pro_type"
         case timezone, referrer
         case refUserID = "ref_user_id"
         case balance
         case paypalEmail = "paypal_email"
         case notificationsSound = "notifications_sound"
         case orderPostsBy = "order_posts_by"
         case androidMDeviceID = "android_m_device_id"
         case iosMDeviceID = "ios_m_device_id"
         case androidNDeviceID = "android_n_device_id"
         case iosNDeviceID = "ios_n_device_id"
         case webDeviceID = "web_device_id"
         case wallet, lat, lng
         case lastLocationUpdate = "last_location_update"
         case shareMyLocation = "share_my_location"
         case lastDataUpdate = "last_data_update"
         case details
         case lastAvatarMod = "last_avatar_mod"
         case lastCoverMod = "last_cover_mod"
         case points
         case dailyPoints = "daily_points"
         case pointDayExpire = "point_day_expire"
         case lastFollowID = "last_follow_id"
         case shareMyData = "share_my_data"
         case lastLoginData = "last_login_data"
         case twoFactor = "two_factor"
         case newEmail = "new_email"
         case twoFactorVerified = "two_factor_verified"
         case newPhone = "new_phone"
         case infoFile = "info_file"
         case city, state, zip
         case schoolCompleted = "school_completed"
         case weatherUnit = "weather_unit"
         case paystackRef = "paystack_ref"
         case userPlatform = "user_platform"
         case url, name
         case mutualFriendsData = "mutual_friends_data"
         case lastseenUnixTime = "lastseen_unix_time"
         case lastseenStatus = "lastseen_status"
         case isFollowing = "is_following"
         case canFollow = "can_follow"
         case isFollowingMe = "is_following_me"
         case genderText = "gender_text"
         case lastseenTimeText = "lastseen_time_text"
         case isBlocked = "is_blocked"
     }
 }

 // MARK: - Details
 struct Details: Codable {
     let postCount, albumCount, followingCount, followersCount: String?
     let groupsCount, likesCount: String?
     let mutualFriendsCount: Int?

     enum CodingKeys: String, CodingKey {
         case postCount = "post_count"
         case albumCount = "album_count"
         case followingCount = "following_count"
         case followersCount = "followers_count"
         case groupsCount = "groups_count"
         case likesCount = "likes_count"
         case mutualFriendsCount = "mutual_friends_count"
     }
 }

}
