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
    func turn_on_off_location(){
        
    }
}
