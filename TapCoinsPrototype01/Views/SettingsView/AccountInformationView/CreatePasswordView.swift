//
//  CreatePasswordView.swift
//  TapCoinsPrototype01
//
//  Created by Eric Viera on 2/18/24.
//

import Foundation
import SwiftUI

struct CreatePasswordView: View {
    @StateObject private var viewModel = AccountInformationViewModel()
    var newCustomColorsModel = CustomColorsModel()
    var body: some View {
        ZStack{
            newCustomColorsModel.colorSchemeThree.ignoresSafeArea()
            if (viewModel.save_p_pressed){
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint:newCustomColorsModel.customColor_1))
                    .scaleEffect(UIScreen.main.bounds.width * 0.01)
            }
            else{
                if viewModel.confirmed_current_password || viewModel.is_guest {
                    VStack{
                        Spacer()
                        VStack{
                            Text("Create Password")
                                .foregroundColor(newCustomColorsModel.customColor_1)
                                .font(.system(size: UIScreen.main.bounds.width * 0.05))
                                .padding()
                        }
                        Rectangle()
                            .fill(newCustomColorsModel.customColor_1)
                            .frame(width: UIScreen.main.bounds.width * 0.95, height: UIScreen.main.bounds.height * 0.01)
                        Form{
                            Section(header: Text("New Password").foregroundColor(newCustomColorsModel.customColor_1)){
                                if viewModel.is_error{
                                    Label(viewModel.error, systemImage: "xmark.octagon")
                                        .foregroundColor(newCustomColorsModel.colorSchemeFour)
                                }
                                SecureField("password", text: $viewModel.password)
                                if viewModel.is_match_error{
                                    Label("Passwords must match", systemImage: "xmark.octagon")
                                        .foregroundColor(newCustomColorsModel.colorSchemeFour)
                                }
                                if viewModel.is_password_error{
                                    Label("Password can't be blank.", systemImage: "xmark.octagon")
                                        .foregroundColor(newCustomColorsModel.colorSchemeFour)
                                }
                            }
                            Section(header: Text("Confirm New Password").foregroundColor(newCustomColorsModel.customColor_1)){
                                SecureField("confirm password", text: $viewModel.cpassword)
                                if viewModel.is_match_error{
                                    Label("Passwords must match", systemImage: "xmark.octagon")
                                        .foregroundColor(newCustomColorsModel.colorSchemeFour)
                                }
                            }
                        }
                        .scrollContentBackground(.hidden)
                        if viewModel.psaved{
                            Spacer()
                            Label("Password Saved.", systemImage: "checkmark.circle.fill")
                                .foregroundColor(newCustomColorsModel.customColor_1)
                            Spacer()
                        }
                        Button(action: {viewModel.save_p_pressed ? nil : viewModel.save_password()}, label: {
                            Text("Save")
                                .frame(width: 200, height: 50, alignment: .center)
                                .background(newCustomColorsModel.customColor_1)
                                .foregroundColor(newCustomColorsModel.colorSchemeThree)
                                .cornerRadius(8)
                        }).padding()
                    }// VStack
                }
                else{
                    VStack(alignment: .center, spacing: UIScreen.main.bounds.width * 0.05){
                        Text("Confirm Password to change password.")
                            .frame(width: UIScreen.main.bounds.width * 0.8, alignment: .center)
                            .font(.system(size: UIScreen.main.bounds.width * 0.037))
                            .foregroundColor(newCustomColorsModel.customColor_1)
                            .bold()
                            .underline(true)
                        SecureField("Password", text: $viewModel.password)
                            .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.04, alignment: .center)
                            .foregroundColor(Color(.black))
                            .background(Color(.white))
                        if viewModel.confirm_password_error {
                            Label("Invalid Password.", systemImage: "xmark.octagon")
                                .foregroundColor(newCustomColorsModel.colorSchemeFour)
                        }
                        Button(action: {viewModel.pressed_confirm_password ? nil : viewModel.confirm_password()}, label: {
                            Text("Confirm")
                                .frame(width: UIScreen.main.bounds.width * 0.3, height: UIScreen.main.bounds.height * 0.04, alignment: .center)
                                .background(newCustomColorsModel.customColor_1)
                                .foregroundColor(newCustomColorsModel.colorSchemeThree)
                                .fontWeight(.bold)
                                .cornerRadius(8)
                        }).padding()
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.25, alignment: .center)
                    .padding(3)
                }
            }
        } // ZStack
    }
}
