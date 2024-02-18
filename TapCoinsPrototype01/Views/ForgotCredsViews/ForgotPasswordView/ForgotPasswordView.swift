//
//  ForgotPasswordView.swift
//  TapCoinsPrototype01
//
//  Created by Eric Viera on 2/18/24.
//

import Foundation
import SwiftUI

struct ForgotPasswordView: View {

    @StateObject private var viewModel = ForgotPasswordViewModel()
    @Environment(\.presentationMode) var presentationMode
    var newCustomColorsModel = CustomColorsModel()

    var body: some View {
        ZStack{
            newCustomColorsModel.colorSchemeOne.ignoresSafeArea()
            if viewModel.send_pressed{
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint:newCustomColorsModel.colorSchemeThree))
                    .scaleEffect(UIScreen.main.bounds.width * 0.01)
            }
            else{
                VStack{
                    Spacer()
                    if viewModel.successfully_sent{
                        Text("Input the code and your new password.")
                            .foregroundColor(newCustomColorsModel.colorSchemeThree)
                            .font(.system(size: UIScreen.main.bounds.width * 0.05))
                            .padding()
                        Rectangle()
                            .fill(newCustomColorsModel.colorSchemeThree)
                            .frame(width: UIScreen.main.bounds.width * 0.95, height: UIScreen.main.bounds.height * 0.01)
                        Form{
                            Section(header: Text("")){
                                if viewModel.is_error{
                                    Label(viewModel.error, systemImage: "xmark.octagon")
                                        .foregroundColor(newCustomColorsModel.colorSchemeFour)
                                }
                                TextField("Code", text: $viewModel.code)
                                SecureField("Password", text: $viewModel.password)
                                if viewModel.is_match_error{
                                    Label("Passwords must match", systemImage: "xmark.octagon")
                                        .foregroundColor(newCustomColorsModel.colorSchemeFour)
                                }
                                if viewModel.is_password_error{
                                    Label("Password can't be blank.", systemImage: "xmark.octagon")
                                        .foregroundColor(newCustomColorsModel.colorSchemeFour)
                                }
                                SecureField("Confirm Password", text: $viewModel.c_password)
                                if viewModel.is_match_error{
                                    Label("Passwords must match", systemImage: "xmark.octagon")
                                        .foregroundColor(newCustomColorsModel.colorSchemeFour)
                                }
                            }
                        }.scrollContentBackground(.hidden)
                        Spacer()
                        if viewModel.submitted{
                            Label("New password saved successfully!", systemImage: "checkmark.seal.fill")
                                .foregroundColor(newCustomColorsModel.colorSchemeThree)
                        }
                        else{
                            Label("Message sent!", systemImage: "checkmark.circle.fill")
                                .foregroundColor(newCustomColorsModel.colorSchemeThree)
                                .padding()
                            Text("If you did not see a message please press")
                                .foregroundColor(newCustomColorsModel.colorSchemeThree)
                            Text("send again.")
                                .foregroundColor(newCustomColorsModel.colorSchemeThree)
                        }
                        Spacer()
                        Button(action: {viewModel.send_pressed ? nil : viewModel.submit()}, label: {
                            Text("Submit")
                                .frame(width: 200, height: 50, alignment: .center)
                                .background(newCustomColorsModel.colorSchemeThree)
                                .foregroundColor(newCustomColorsModel.colorSchemeOne)
                                .cornerRadius(8)
                        }).padding()
                        Button(action: {viewModel.send_pressed ? nil : viewModel.send_code()}, label: {
                            Text("Send Again")
                                .frame(width: 200, height: 50, alignment: .center)
                                .background(newCustomColorsModel.colorSchemeThree)
                                .foregroundColor(newCustomColorsModel.colorSchemeOne)
                                .cornerRadius(8)
                        }).padding()
                    }
                    else{
                        Spacer()
                        Text("Input the phone number associated with your account and we will send you a code to reset your password.")
                            .foregroundColor(newCustomColorsModel.colorSchemeThree)
                            .font(.system(size: UIScreen.main.bounds.width * 0.05))
                            .padding()
                        Rectangle()
                            .fill(newCustomColorsModel.colorSchemeThree)
                            .frame(width: UIScreen.main.bounds.width * 0.95, height: UIScreen.main.bounds.height * 0.01)
                        Form{
                            Section(header: Text("")){
                                TextField("Phone number", text: $viewModel.phone_number)
                                if viewModel.is_phone_error{
                                    Label("Invalid phone number", systemImage: "xmark.octagon")
                                        .foregroundColor(newCustomColorsModel.colorSchemeFour)
                                }
                            }

                        }
                        .scrollContentBackground(.hidden)
                        NavigationLink(destination: {
                            SecurityQuestionsView()
                                .navigationBarBackButtonHidden(true)
                                .navigationBarItems(leading: RedBackButtonView())
                        }, label: {
                            Text("Click here to answer security questions instead.")
                                .foregroundColor(newCustomColorsModel.colorSchemeThree)
                                .underline(true)
                                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.13, alignment: .center)
                                .cornerRadius(UIScreen.main.bounds.width * 0.02)
                        })
                        Button(action: {viewModel.send_pressed ? nil : viewModel.send_code()}, label: {
                            Text("Send")
                                .frame(width: 200, height: 50, alignment: .center)
                                .background(newCustomColorsModel.colorSchemeThree)
                                .foregroundColor(newCustomColorsModel.colorSchemeOne)
                                .cornerRadius(8)
                        }).padding()

                    }

                }
            }
            
        } // ZStack
    }
}
