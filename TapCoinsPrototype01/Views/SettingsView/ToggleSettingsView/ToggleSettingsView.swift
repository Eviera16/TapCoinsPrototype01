//
//  ToggleSettingsView.swift
//  TapCoinsPrototype01
//
//  Created by Eric Viera on 2/18/24.
//

import Foundation
import SwiftUI

struct ToggleSettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = ToggleSettingsViewModel()
    @AppStorage("notifications") var notifications_on:Bool?
    @AppStorage("haptics") var haptics_on:Bool?
    @AppStorage("sounds") var sound_on:Bool?
    @AppStorage("darkMode") var darkMode: Bool?
    var newCustomColorsModel = CustomColorsModel()
    var body: some View {
        ZStack{
            if darkMode ?? false {
                Color(.black).ignoresSafeArea()
            }
            else{
                newCustomColorsModel.colorSchemeOne.ignoresSafeArea()
            }
            VStack{
                Text("Toggle Settings:")
                    .font(.system(size: UIScreen.main.bounds.width * 0.08))
                    .fontWeight(.bold)
                    .frame(width: UIScreen.main.bounds.width , height: UIScreen.main.bounds.height * 0.08)
                    .foregroundColor(newCustomColorsModel.customColor_1)
                    .background(newCustomColorsModel.colorSchemeFour)
                Spacer()
                List{
                    Section(header: Text(viewModel.is_guest ? "Create account to allow notifications" : "Notifications").foregroundColor(newCustomColorsModel.colorSchemeFour)){
                        HStack{
                            Spacer()
                            ToggleSettingsSwitchView(toggle_setting_title: ToggleSettingTitles.NotificationsToggle, toggle_label: "Allow Notifications - ")
                        }
                    }
                    Section(header: Text(viewModel.is_guest ? "Create account to allow location" : "Location").foregroundColor(newCustomColorsModel.colorSchemeFour)){
                        HStack{
                            Spacer()
                            ToggleSettingsSwitchView(toggle_setting_title: ToggleSettingTitles.LocationToggle, toggle_label: "Allow Location - ")
                        }
                    }
                    Section(header: Text("Sounds").foregroundColor(newCustomColorsModel.colorSchemeFour)){
                        HStack{
                            Spacer()
                            ToggleSettingsSwitchView(toggle_setting_title: ToggleSettingTitles.SoundsToggle, toggle_label: "Toggle Sounds - ")
                        }
                    }
                    Section(header: Text("Vibrations").foregroundColor(newCustomColorsModel.colorSchemeFour)){
                        HStack{
                            Spacer()
                            ToggleSettingsSwitchView(toggle_setting_title: ToggleSettingTitles.HapticsToggle, toggle_label: "Toggle Vibrations - ")
                        }
                    }
                    Section(header: Text("Light/Dark Mode").foregroundColor(newCustomColorsModel.colorSchemeFour)){
                        HStack{
                            Spacer()
                            ToggleSettingsSwitchView(toggle_setting_title: ToggleSettingTitles.LightDarkModeToggle, toggle_label: "Toggle Light or Dark Mode - ")
                        }
                    }
                }
                Spacer()
            }
            .scrollContentBackground(.hidden)
        }
    }
}
