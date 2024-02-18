//
//  HomeView.swift
//  TapCoinsPrototype01
//
//  Created by Eric Viera on 2/18/24.
//

import Foundation
import SwiftUI

@available(iOS 17.0, *)
struct HomeView: View {

//    @AppStorage("session") var logged_in_user: String?
    @AppStorage("in_queue") var in_queue: Bool?
    @AppStorage("show_security_questions") var show_security_questions:Bool?
    @AppStorage("darkMode") var darkMode: Bool?
    @StateObject private var viewModel = HomeViewModel()
    var newCustomColorsModel = CustomColorsModel()

    var body: some View {
        ZStack{
            if darkMode ?? false {
                Color(.black).ignoresSafeArea()
            }
            else{
                newCustomColorsModel.colorSchemeOne.ignoresSafeArea()
            }
            if viewModel.loaded_get_user ?? false{
                VStack(alignment: .center, spacing: UIScreen.main.bounds.width * 0.1){
                    VStack(alignment: .center, spacing: 0){
                        HStack{
                            Image("Custom_Color_3_TC")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: UIScreen.main.bounds.height < 700.0 ? UIScreen.main.bounds.width * 0.13 : UIScreen.main.bounds.width * 0.15, height: UIScreen.main.bounds.height < 700.0 ? UIScreen.main.bounds.width * 0.13 : UIScreen.main.bounds.width * 0.15, alignment: .center)
                                .cornerRadius(100)
                            Image("Custom_Color_1_TC")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: UIScreen.main.bounds.height < 700.0 ? UIScreen.main.bounds.width * 0.13 : UIScreen.main.bounds.width * 0.15, height: UIScreen.main.bounds.height < 700.0 ? UIScreen.main.bounds.width * 0.13 : UIScreen.main.bounds.width * 0.15, alignment: .center)
                                .cornerRadius(100)
                            Image("Custom_Color_2_TC")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: UIScreen.main.bounds.height < 700.0 ? UIScreen.main.bounds.width * 0.13 : UIScreen.main.bounds.width * 0.15, height: UIScreen.main.bounds.height < 700.0 ? UIScreen.main.bounds.width * 0.13 : UIScreen.main.bounds.width * 0.15, alignment: .center)
                                .cornerRadius(100)
                        }
                        HStack(alignment: .center, spacing: 0.0){
                            Text("Tap")
                                .font(.system(size: UIScreen.main.bounds.width * 0.15))
                                .foregroundColor(newCustomColorsModel.colorSchemeThree)
                                .fontWeight(.bold)
                            Text("Coins")
                                .font(.system(size: UIScreen.main.bounds.width * 0.15))
                                .foregroundColor(newCustomColorsModel.colorSchemeFour)
                                .fontWeight(.bold)
                        }
                        Rectangle()
                            .fill(newCustomColorsModel.customColor_1)
                            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.01)
                    }
    //                        Text(viewModel.iCloud_status)
    //                            .font(.system(size: UIScreen.main.bounds.width * 0.04))
    //                            .foregroundColor(newCustomColorsModel.customColor_1)
    //                            .fontWeight(.bold)
                    Button(action: {
                        print("BUTTON PRESSED")
                        if viewModel.pressed_find_game == false{
                            viewModel.pressed_find_game = true
                            if viewModel.userModel?.has_wallet == true{
                                viewModel.tempFaceIdPopUpButton(showValue:true)
                            }
                            else{
                                in_queue = true
                                viewModel.pressed_find_game = false
                            }
                        }
                    }, label: {
                            Text("Find Game")
                                .font(.system(size: UIScreen.main.bounds.width * 0.1))
                                .fontWeight(.bold)
                                .frame(width: UIScreen.main.bounds.width * 0.65, height: UIScreen.main.bounds.height * 0.1, alignment: .center)
                                .foregroundColor(newCustomColorsModel.customColor_1)
                                .background(newCustomColorsModel.colorSchemeThree)
                                .clipShape(RoundedRectangle(cornerSize: CGSize(width: UIScreen.main.bounds.height * 0.02, height: UIScreen.main.bounds.height * 0.02)))
                                
                    })
                    HomePageButton(_label: "Practice")
                    HomePageButton(_label: "Profile")
                    HomePageButton(_label: "About")
    //                        ReCAPTCHAClientView()
    //                        Button(action: {
    //                            print("Testing ReCAPTCHA")
    //                            viewModel.test_ReCAPTCHA_Function()
    //                        }, label: {Text("Test ReCAPTCHA")})
    //                            .font(.system(size: UIScreen.main.bounds.width * 0.06))
    //                            .fontWeight(.bold)
    //                            .frame(width: UIScreen.main.bounds.width * 0.65, height: UIScreen.main.bounds.height * 0.06, alignment: .center)
    //                            .foregroundColor(newCustomColorsModel.customColor_1)
    //                            .background(.pink)
    //                            .clipShape(RoundedRectangle(cornerSize: CGSize(width: UIScreen.main.bounds.height * 0.02, height: UIScreen.main.bounds.height * 0.02)))
                    HStack(alignment: .bottom){
                        HomePageButton(_label: "Settings")
                        Spacer()
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.7)
                }
                Spacer()
    //            if viewModel.d_ShowAgain == false{
    //                if viewModel.hasPhoneNumber == false{
    //                    HStack{
    //                        Spacer()
    //                        VStack{
    //                            Text("WAIT!")
    //                                .foregroundColor(Color(.yellow))
    //                                .underline()
    //                            Text("You don't have a phone number saved. Go to the settings and update your phone number to secure your account in case of a forgotten username or password.")
    //                                .foregroundColor(Color(.black))
    //                            Rectangle()
    //                                .fill(Color(.yellow))
    //                                .frame(width: UIScreen.main.bounds.width * 0.75, height: UIScreen.main.bounds.height * 0.001)
    //                            HStack{
    //                                Button(action: {viewModel.hasPhoneNumber = true}, label: {
    //                                    Text("Close")
    //                                        .frame(width: UIScreen.main.bounds.width * 0.25, height: UIScreen.main.bounds.height * 0.05, alignment: .center)
    //                                        .background(Color(.yellow))
    //                                        .foregroundColor(Color(.red))
    //                                        .cornerRadius(8)
    //                                }).padding()
    //                                Button(action: {
    //                                    if viewModel.d_ShowAgain ?? false{
    //                                        viewModel.d_ShowAgain = false
    //                                    }
    //                                    else{
    //                                        viewModel.d_ShowAgain = true
    //                                    }
    //                                }, label: {
    //                                    Text("Don't show again")
    //                                        .frame(width: UIScreen.main.bounds.width * 0.25, height: UIScreen.main.bounds.height * 0.05, alignment: .center)
    //                                        .background(viewModel.d_ShowAgain ?? false ? Color(.green) : Color(.yellow))
    //                                        .foregroundColor(viewModel.d_ShowAgain ?? false ? Color(.black) : Color(.red))
    //                                        .cornerRadius(8)
    //                                }).padding()
    //                            }
    //                        }
    //                        Spacer()
    //                    }
    //                    .frame(width: UIScreen.main.bounds.width * 0.75, height: viewModel.smaller_screen ? UIScreen.main.bounds.height * 0.24 : UIScreen.main.bounds.height * 0.26, alignment: .center)
    //                    .background(Color(.red))
    //                    .border(Color(.yellow), width: UIScreen.main.bounds.width * 0.005)
    //                    .offset(x: 0, y: viewModel.smaller_screen ? -25 : -40)
    //                }
    //            }
            if viewModel.showFaceIdPopUp{
                VStack{
                    Text("Press button to pass FaceId.")
                        .font(.system(size: UIScreen.main.bounds.width * 0.05))
                        .foregroundColor(newCustomColorsModel.customColor_1)
                        .fontWeight(.bold)
                    Text(viewModel.passedFaceId ? "PASSED!" : viewModel.failedFaceId ? viewModel.failedFaceIdMessage : "Temporary only for Dev side.")
                        .foregroundColor(newCustomColorsModel.customColor_1)
                        .underline()
                    Button(action: {viewModel.pressed_face_id_button ? nil : viewModel.tempFaceIdPopUpButton(showValue:false)}, label: {
                        Text("Pass")
                            .frame(width: UIScreen.main.bounds.width * 0.1, height: UIScreen.main.bounds.height * 0.04, alignment: .center)
                            .background(newCustomColorsModel.customColor_1)
                            .foregroundColor(newCustomColorsModel.customColor_2)
                            .fontWeight(.bold)
                            .cornerRadius(8)
                    }).padding()
                }
                .background(newCustomColorsModel.customColor_2)
            }
            if show_security_questions ?? true{
                if viewModel.userModel?.is_guest == false{
                    SecurityQuestionsComponentView(is_settings:false)
                }
            }
//                LocationView() implement Location later
            }
            else{
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint:newCustomColorsModel.colorSchemeThree))
                    .scaleEffect(UIScreen.main.bounds.width * 0.01)
            }
        }
        
        
    }
}
