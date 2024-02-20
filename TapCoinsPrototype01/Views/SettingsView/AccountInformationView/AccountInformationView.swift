//
//  AccountInformationView.swift
//  TapCoinsPrototype01
//
//  Created by Eric Viera on 2/18/24.
//

import Foundation
import SwiftUI

@available(iOS 17.0, *)
struct AccountInformationView: View {
    @AppStorage("darkMode") var darkMode: Bool?
    @StateObject private var viewModel = AccountInformationViewModel()
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
                Text("Account Information")
                    .font(.system(size: UIScreen.main.bounds.width * 0.05))
                    .fontWeight(.bold)
                    .frame(width: UIScreen.main.bounds.width , height: UIScreen.main.bounds.height * 0.08)
                    .foregroundColor(newCustomColorsModel.colorSchemeThree)
                    .background(newCustomColorsModel.customColor_1)
                VStack{
                    Text("View or Change your account information below.").foregroundColor(darkMode ?? false ? Color(.white) : Color(.black))
                    Text("Tap 'Update password' to change your password.").foregroundColor(darkMode ?? false ? Color(.white) : Color(.black))
                }
                if viewModel.set_page_data{
                    Form{
                        Section(header: Text("First name").foregroundColor(newCustomColorsModel.colorSchemeThree)){
                            TextField(viewModel.first_name, text: $viewModel.first_name)
                        }
                        Section(header: Text("Last name").foregroundColor(newCustomColorsModel.colorSchemeThree)){
                            TextField(viewModel.last_name, text: $viewModel.last_name)
                        }
                        Section(header: Text("Phone number").foregroundColor(newCustomColorsModel.colorSchemeThree)){
                            TextField(viewModel.phone_number == "" ? "" : viewModel.phone_number, text: $viewModel.phone_number)
                            if viewModel.is_phone_error{
                                Label(viewModel.phone_error?.rawValue ?? "", systemImage: "xmark.octagon")
                                    .foregroundColor(newCustomColorsModel.colorSchemeFour)
                            }
                        }
                        Section(header: Text("Username (this is what public users will see)").foregroundColor(newCustomColorsModel.colorSchemeThree)){
                            TextField(viewModel.username, text: $viewModel.username)
                            if viewModel.is_uName_error{
                                Label(viewModel.username_error?.rawValue ?? "", systemImage: "xmark.octagon")
                                    .foregroundColor(newCustomColorsModel.colorSchemeFour)
                            }
                        }
                        Section{
                            if viewModel.is_guest{
                                if viewModel.gsave_pressed ?? false{
                                    NavigationLink(destination: CreatePasswordView().navigationBarBackButtonHidden(true)
                                        .navigationBarItems(leading: YellowBackButtonView())
                                                   , label: {Text("Create password").foregroundColor(newCustomColorsModel.colorSchemeThree).underline(true)})
                                }
                                else{
                                    Button(action: {
                                        viewModel.message = "Must save data before creating a password."
                                        viewModel.show_guest_message = true
                                    }, label: {Text("Create password").foregroundColor(newCustomColorsModel.colorSchemeThree).underline(true)})
                                }
                            }
                            else{
                                NavigationLink(destination: CreatePasswordView().navigationBarBackButtonHidden(true)
                                    .navigationBarItems(leading: YellowBackButtonView()), label: {Text("Update password").foregroundColor(newCustomColorsModel.colorSchemeThree).underline(true)})
                            }
                            NavigationLink(destination: SecurityQuestionsComponentView(is_settings:true).navigationBarBackButtonHidden(true)
                                .navigationBarItems(leading: YellowBackButtonView()), label: {Text("Show Security Questions").foregroundColor(newCustomColorsModel.colorSchemeThree).underline(true)})
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width , height: UIScreen.main.bounds.height * 0.6, alignment: .bottom)
                    .background(newCustomColorsModel.customColor_1)
                }
                else{
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint:newCustomColorsModel.customColor_1))
                        .scaleEffect(UIScreen.main.bounds.width * 0.01)
                }
                
                Button(action: {viewModel.save_pressed ? nil : viewModel.save()}, label: {
                    Text("Save")
                        .frame(width: 200, height: 50, alignment: .center)
                        .background(newCustomColorsModel.customColor_1)
                        .foregroundColor(newCustomColorsModel.colorSchemeThree)
                        .cornerRadius(8)
                })
            }.scrollContentBackground(.hidden)
            if viewModel.saved{
                Label(viewModel.message, systemImage: "checkmark.seal")
                    .foregroundColor(newCustomColorsModel.customColor_1)
                    .offset(y: UIScreen.main.bounds.height * -0.29)
            }
            if viewModel.show_guest_message{
                Label(viewModel.message, systemImage: "xmark.seal")
                    .foregroundColor(newCustomColorsModel.colorSchemeFour)
                    .offset(y: UIScreen.main.bounds.height * 0.31)
            }
        } // ZStack
    }
}

