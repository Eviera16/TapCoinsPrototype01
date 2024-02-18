//
//  RegistrationView.swift
//  TapCoinsPrototype01
//
//  Created by Eric Viera on 2/18/24.
//

import Foundation
import SwiftUI

struct RegistrationView: View {
    
    @StateObject private var viewModel = RegistrationViewModel()
    var newCustomColorsModel = CustomColorsModel()
    
//    init(){
//            UITableView.appearance().backgroundColor = .clear
//        }
    
    var body: some View {
        ZStack{
            newCustomColorsModel.colorSchemeOne.ignoresSafeArea()
            if (viewModel.reg_pressed){
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint:newCustomColorsModel.colorSchemeThree))
                    .scaleEffect(UIScreen.main.bounds.width * 0.01)
            }
            else{
                VStack(alignment: .center, spacing: 0){
                    ScrollView{
                        Text("Register")
                            .font(.system(size: UIScreen.main.bounds.width * 0.14))
                            .foregroundColor(newCustomColorsModel.colorSchemeThree)
                        Form{
                            Section(header: Text("")){
                                TextField("First Name (optional)", text: $viewModel.first_name)
    //                            if viewModel.is_fName_error{
    //                                Label(viewModel.first_name_error?.rawValue ?? "", systemImage: "xmark.octagon")
    //                                    .foregroundColor(newCustomColorsModel.customColor_2)
    //                            }

                                TextField("Last Name (optional)", text: $viewModel.last_name)
    //                            if viewModel.is_lName_error{
    //                                Label(viewModel.last_name_error?.rawValue ?? "", systemImage: "xmark.octagon")
    //                                    .foregroundColor(newCustomColorsModel.customColor_2)
    //                            }
                                HStack{
                                    TextField("Phone number (optional)", text: $viewModel.phone_number)
                                    Button(action: {
                                        viewModel.phone_info = !viewModel.phone_info
                                    }, label: {
                                        Label("", systemImage: "info.circle.fill")
                                            .foregroundColor(newCustomColorsModel.colorSchemeThree)
                                    })
                                }
                                if viewModel.is_phone_error{
                                    Label(viewModel.phone_error?.rawValue ?? "", systemImage: "xmark.octagon")
                                        .foregroundColor(newCustomColorsModel.colorSchemeFour)
                                }
                                if viewModel.phone_info{
                                    Label("Your phone number will be used to recover your account information in case of forgotten username or password.", systemImage: "info.circle")
                                        .foregroundColor(newCustomColorsModel.colorSchemeThree)
                                }
                            }
                            if viewModel.register_error{
                                Label(viewModel.register_error_string, systemImage: "info.circle")
                                    .foregroundColor(newCustomColorsModel.colorSchemeFour)
                            }
                            Section{
                                TextField("Username", text: $viewModel.username)
                                if viewModel.is_uName_error{
                                    Label(viewModel.username_error?.rawValue ?? "", systemImage: "xmark.octagon")
                                        .foregroundColor(newCustomColorsModel.colorSchemeFour)
                                }
                                SecureField("Password", text: $viewModel.password)
                                if viewModel.is_password_error{
                                    Label(viewModel.password_error?.rawValue ?? "", systemImage: "xmark.octagon")
                                        .foregroundColor(newCustomColorsModel.colorSchemeFour)
                                }
                                SecureField("Confirm password", text: $viewModel.confirm_password)
                                if viewModel.is_password_error{
                                    Label(viewModel.password_error?.rawValue ?? "", systemImage: "xmark.octagon")
                                        .foregroundColor(newCustomColorsModel.colorSchemeFour)
                                }
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width , height: UIScreen.main.bounds.height * 0.6, alignment: .bottom)
                        .scrollContentBackground(.hidden)
                        Button(action: {viewModel.reg_pressed ? nil : viewModel.register()}, label: {
                            Text("Register")
                                .frame(width: 200, height: 50, alignment: .center)
                                .background(newCustomColorsModel.colorSchemeThree)
                                .foregroundColor(newCustomColorsModel.colorSchemeOne)
                                .cornerRadius(8)
                        })
                        HStack{
                            Text("By registering you agree to our ")
                                .foregroundColor(newCustomColorsModel.colorSchemeThree)
                                .font(.system(size: UIScreen.main.bounds.width * 0.04))
                            Link("Privacy Policy", destination: URL(string: "https://app.websitepolicies.com/policies/view/dgg6h68x") ?? URL(string: "")!)
                        }
                        .padding()
                    }
                }
            }
            
//            Button(action: {
//                viewModel.phone_info = !viewModel.phone_info
//            }, label: {
//                Label("", systemImage: "info.circle.fill")
//                    .foregroundColor(newCustomColorsModel.customColor_3)
//            })
//            .offset(x: UIScreen.main.bounds.width * 0.4, y: UIScreen.main.bounds.height * -0.135)
        } // ZStack
    }
}
