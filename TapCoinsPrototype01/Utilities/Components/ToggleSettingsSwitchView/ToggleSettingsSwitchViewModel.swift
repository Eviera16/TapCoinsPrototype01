//
//  ToggleSettingsSwitchViewModel.swift
//  TapCoinsPrototype01
//
//  Created by Eric Viera on 2/18/24.
//

import Foundation
import SwiftUI
//import CloudKit
final class ToggleSettingsSwitchViewModel: ObservableObject {
    @AppStorage("notifications") var notifications_on:Bool?
    @AppStorage("haptics") var haptics_on:Bool?
    @AppStorage("sounds") var sound_on:Bool?
    @AppStorage("location_on") var location_on:Bool?
    @AppStorage("user") private var userViewModel: Data?
    @AppStorage("darkMode") var darkMode: Bool?
    @Published var userModel:UserViewModel?
    @Published var is_guest:Bool = false
    
    init(){
        print("INITIAL VALUES BELOW")
        print(haptics_on)
        print(sound_on)
//        if UIScreen.main.bounds.height < 750.0{
//            smaller_screen = true
//        }
        self.userModel = UserViewModel(self.userViewModel ?? Data())
        if self.userModel?.is_guest == true{
            is_guest = true
        }
        if is_guest == true {
            notifications_on = false
        }
    }
    
    func turn_on_off_notifications(){
        if is_guest == false{
            if notifications_on == nil{
//                subscribeToNotifications()
            }
            else if notifications_on!{
//                unsubscribeToNotifications()
            }
            else {
//                subscribeToNotifications()
            }
        }
    }
    
//    func subscribeToNotifications(){
//        var username_given:String = ""
//        if self.userModel?.username != nil || self.userModel?.username != ""{
//            username_given = self.userModel?.username ?? ""
//        }
//        else{
//            return
//        }
//        if username_given == ""{
//            return
//        }
//        let predicate = NSPredicate(format: "receiver = %@", argumentArray: [username_given])
//        let subscription = CKQuerySubscription(recordType: "FriendRequest", predicate: predicate, subscriptionID: "friend_request_received", options: .firesOnRecordCreation)
//        
//        let notification = CKSubscription.NotificationInfo()
//        notification.title = "Friend request received!"
//        notification.alertBody = "Go to your Profile to accept or decline."
//        notification.soundName = "default"
//        
//        subscription.notificationInfo = notification
//        
//        CKContainer(identifier: "iCloud.com.ericviera.TapTapCoin").publicCloudDatabase.save(subscription) { [weak self] returnedSubscription, returnedError in
//            if let error = returnedError{
//                print(error)
//            }
//            else{
//                DispatchQueue.main.async {
//                    self?.notifications_on = true
//                }
//            }
//        }
//        let subscription2 = CKQuerySubscription(recordType: "GameInvite", predicate: predicate, subscriptionID: "game_invite_received", options: .firesOnRecordCreation)
//        
//        let notification2 = CKSubscription.NotificationInfo()
//        notification2.title = "Game invite received!"
//        notification2.alertBody = "Go to your Profile to accept or decline."
//        notification2.soundName = "default"
//        
//        subscription2.notificationInfo = notification2
//        
//        CKContainer(identifier: "iCloud.com.ericviera.TapTapCoin").publicCloudDatabase.save(subscription2) { [weak self] returnedSubscription, returnedError in
//            if let error = returnedError{
//                print(error)
//            }
//            else{
//                DispatchQueue.main.async {
//                    self?.notifications_on = true
//                }
//            }
//        }
//    }
//    
//    func unsubscribeToNotifications(){
//        
//        CKContainer(identifier: "iCloud.com.ericviera.TapTapCoin").publicCloudDatabase.delete(withSubscriptionID: "friend_request_received") { [weak self] returnedID, returnedError in
//            if let error = returnedError{
//                print(error)
//            }
//            else{
//                DispatchQueue.main.async{
//                    self?.notifications_on = false
//                }
//            }
//        }
//        CKContainer(identifier: "iCloud.com.ericviera.TapTapCoin").publicCloudDatabase.delete(withSubscriptionID: "game_invite_received") { [weak self] returnedID, returnedError in
//            if let error = returnedError{
//                print(error)
//            }
//            else{
//                DispatchQueue.main.async{
//                    self?.notifications_on = false
//                }
//            }
//        }
//    }
//    
    func turn_on_off_location(){
        
    }
}
