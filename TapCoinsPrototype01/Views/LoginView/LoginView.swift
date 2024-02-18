//
//  LoginView.swift
//  TapCoinsPrototype01
//
//  Created by Eric Viera on 2/18/24.
//

import Foundation
import SwiftUI

struct LoginView: View {
    
    @StateObject private var viewModel = LoginViewModel()
    @Environment(\.presentationMode) var presentationMode
    var newCustomColorsModel = CustomColorsModel()
    
    
    var body: some View {
        ZStack{
            newCustomColorsModel.colorSchemeThree.ignoresSafeArea()
            if (viewModel.log_pressed){
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint:newCustomColorsModel.customColor_1))
                    .scaleEffect(UIScreen.main.bounds.width * 0.01)
            }
            else{
                VStack{
                    Text("Login")
                        .font(.system(size: UIScreen.main.bounds.width * 0.16))
                        .foregroundColor(newCustomColorsModel.customColor_1)
                    Form{
                        Section(header: Text("")){
                            TextField("Username", text: $viewModel.username)
                            if viewModel.is_error{
                                Label(viewModel.user_error?.rawValue ?? "", systemImage: "xmark.octagon")
                                    .foregroundColor(newCustomColorsModel.colorSchemeFour)
                            }
                            SecureField("Password", text: $viewModel.password)
                            if viewModel.is_error {
                                Label(viewModel.password_error?.rawValue ?? "", systemImage: "xmark.octagon")
                                    .foregroundColor(newCustomColorsModel.colorSchemeFour)
                            }
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width , height: UIScreen.main.bounds.height * 0.3, alignment: .bottom)
                    .scrollContentBackground(.hidden)
                    Button(action: {viewModel.log_pressed ? nil : viewModel.login()}, label: {
                        Text("Login")
                            .frame(width: 200, height: 50, alignment: .center)
                            .background(newCustomColorsModel.customColor_1)
                            .foregroundColor(newCustomColorsModel.colorSchemeThree)
                            .cornerRadius(8)
                    }).padding()
                    VStack(alignment: .center, spacing: UIScreen.main.bounds.width * 0.1){
                        HStack{
                            NavigationLink(destination: ForgotUsernameView()
                                .navigationBarBackButtonHidden(true)
                                .navigationBarItems(leading: RedBackButtonView()), label: {Text("Forgot username").foregroundColor(newCustomColorsModel.customColor_1).underline(true)})
                            NavigationLink(destination: ForgotPasswordView().navigationBarBackButtonHidden(true).navigationBarItems(leading: RedBackButtonView()), label: {Text("Forgot password").foregroundColor(newCustomColorsModel.customColor_1).underline(true)})
                        }
                        HStack{
                            Text("Don't have an account? ").foregroundColor(newCustomColorsModel.customColor_1)
                            NavigationLink(destination: {
                                RegistrationView()
                                    .navigationBarBackButtonHidden(true)
                                    .navigationBarItems(leading: BlueBackButtonView())
                            }, label: {
                                Text("Register!")
                                    .underline(true)
                                    .foregroundColor(newCustomColorsModel.customColor_1)
                            })
                        }
                    }
                    
                }
            }
        }
    }
}

