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
                    Button(action: {
                        print("BUTTON PRESSED")
                        if viewModel.pressed_find_game == false{
                            viewModel.pressed_find_game = true
                            in_queue = true
                            viewModel.pressed_find_game = false
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
                    HStack(alignment: .bottom){
                        HomePageButton(_label: "Settings")
                        Spacer()
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.7)
                }
                Spacer()
                if show_security_questions ?? true{
                    if viewModel.userModel?.is_guest == false{
                        SecurityQuestionsComponentView(is_settings:false)
                    }
                }
                if viewModel.show_user_streak_pop_up == true{
                    VStack(alignment: .center, spacing: UIScreen.main.bounds.width * 0.03){
                        Image(systemName: "hourglass")
                            .background(newCustomColorsModel.colorSchemeSix)
                            .foregroundColor(newCustomColorsModel.colorSchemeThree)
                            .font(.system(size: UIScreen.main.bounds.width * 0.12))
                        VStack{
                            Text("You have a win streak!")
                                .foregroundColor(newCustomColorsModel.colorSchemeThree)
                                .font(.system(size: UIScreen.main.bounds.width * 0.045))
                            Text("You have 2 minutes before losing your streak.")
                                .foregroundColor(newCustomColorsModel.colorSchemeThree)
                                .font(.system(size: UIScreen.main.bounds.width * 0.038))
                        }
                        Button(action: {viewModel.show_user_streak_pop_up = false}, label: {
                            HStack{
                                Text("Close")
                                    .foregroundColor(newCustomColorsModel.colorSchemeSix)
                                    .font(.system(size: UIScreen.main.bounds.width * 0.04))
                                Image(systemName: "x.square")
                                    .background(newCustomColorsModel.colorSchemeThree)
                                    .foregroundColor(newCustomColorsModel.colorSchemeSix)
                                    .font(.system(size: UIScreen.main.bounds.width * 0.04))
                            }
                            .background(newCustomColorsModel.colorSchemeThree)
                            .cornerRadius(UIScreen.main.bounds.width * 0.02)
                        })
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.16, alignment: .center)
                    .background(newCustomColorsModel.colorSchemeSix)
                    .cornerRadius(UIScreen.main.bounds.width * 0.02)
                }
            }
            else{
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint:newCustomColorsModel.colorSchemeThree))
                    .scaleEffect(UIScreen.main.bounds.width * 0.01)
            }
        }
    }
}
