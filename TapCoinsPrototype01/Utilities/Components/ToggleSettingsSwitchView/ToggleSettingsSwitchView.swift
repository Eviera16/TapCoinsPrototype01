//
//  ToggleSettingsSwitchView.swift
//  TapCoinsPrototype01
//
//  Created by Eric Viera on 2/18/24.
//

import Foundation
import SwiftUI

struct ToggleSettingsSwitchView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = ToggleSettingsSwitchViewModel()
    var newCustomColorsModel = CustomColorsModel()
    var toggle_setting_title:ToggleSettingTitles
    var toggle_label:String
    var body: some View {
        switch (toggle_setting_title){
        case ToggleSettingTitles.NotificationsToggle:
            Toggle(isOn:Binding(
                get: { viewModel.notifications_on ?? false },
                set: { viewModel.notifications_on = $0 }
            ),
            label: {
                Text(toggle_label).foregroundColor(newCustomColorsModel.colorSchemeFour)
            })
            .disabled(viewModel.is_guest)
            .onTapGesture {
                viewModel.turn_on_off_notifications()
            }
        case ToggleSettingTitles.SoundsToggle:
            Toggle(isOn: Binding(
                get: { viewModel.sound_on ?? false },
                set: { viewModel.sound_on = $0 }
            ),
                   label: {
                       Text(toggle_label).foregroundColor(newCustomColorsModel.colorSchemeFour)
                   })
        case ToggleSettingTitles.HapticsToggle:
            Toggle(isOn: Binding(
                get: { viewModel.haptics_on ?? false },
                set: { viewModel.haptics_on = $0 }
            ),
                   label: {
                       Text(toggle_label).foregroundColor(newCustomColorsModel.colorSchemeFour)
                   })
        case ToggleSettingTitles.LocationToggle:
            Toggle(isOn: Binding(
                get: { viewModel.location_on ?? false },
                set: { viewModel.location_on = $0 }
            ),
                   label: {
                       Text(toggle_label).foregroundColor(newCustomColorsModel.colorSchemeFour)
                   })
            .disabled(viewModel.is_guest)
            .onTapGesture {
                if viewModel.location_on ?? false{
//                    LocationManager.instance.requestLocation()
                }
            }
        case ToggleSettingTitles.LightDarkModeToggle:
            Toggle(isOn: Binding(
                get: { viewModel.darkMode ?? false },
                set: { viewModel.darkMode = $0 }
            ),
                   label: {
                       Text(toggle_label).foregroundColor(newCustomColorsModel.colorSchemeFour)
                   })
        default:
            Text("Something Went Wrong.")
        }
    }
}
