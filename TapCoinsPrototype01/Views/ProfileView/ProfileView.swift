//
//  ProfileView.swift
//  TapCoinsPrototype01
//
//  Created by Eric Viera on 2/18/24.
//

import Foundation
import SwiftUI

struct ProfileView: View {
    @AppStorage("num_friends") public var num_friends:Int?
    @AppStorage("darkMode") var darkMode: Bool?
    @StateObject private var viewModel = ProfileViewModel()
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
                VStack(spacing: UIScreen.main.bounds.width * 0.01){
                    Spacer()
                    Text(viewModel.userModel.username ?? "No USERNAME")
                        .font(.system(size: UIScreen.main.bounds.width * 0.12))
                        .foregroundColor(darkMode ?? false ? .white : .black)
                        .fontWeight(.bold)
                    Text("RANK: " + viewModel.league_title)
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.033, alignment: .leading)
                        .background(viewModel.leagueColor)
                        .foregroundColor(viewModel.leageForeground)
                        .border(Color(.black), width: UIScreen.main.bounds.width * 0.005)
                    
                        VStack(spacing: UIScreen.main.bounds.width * 0.02){
                            Spacer()
                            Text("Persnoal Stats")
                                .foregroundColor(newCustomColorsModel.colorSchemeThree)
                                .font(.system(size: UIScreen.main.bounds.width * 0.05))
                                .underline()
                            HStack(alignment: .center, spacing: UIScreen.main.bounds.width * 0.2){
                                VStack(alignment: .leading, spacing: UIScreen.main.bounds.width * 0.008){
                                    Text("Wins:")
                                        .foregroundColor(newCustomColorsModel.colorSchemeThree)
                                        .font(.system(size: UIScreen.main.bounds.width * 0.03))
                                        .underline()
                                    Text(String(viewModel.userModel.wins ?? 0))
                                        .bold()
                                        .font(.system(size: UIScreen.main.bounds.width * 0.044))
                                    Rectangle()
                                        .fill(newCustomColorsModel.colorSchemeThree)
                                        .frame(width: UIScreen.main.bounds.width * 0.2, height: UIScreen.main.bounds.height * 0.005)
                                }
                                VStack(alignment: .leading, spacing: UIScreen.main.bounds.width * 0.008){
                                    Text("Losses:")
                                        .foregroundColor(newCustomColorsModel.colorSchemeThree)
                                        .font(.system(size: UIScreen.main.bounds.width * 0.03))
                                        .underline()
                                    Text(String(viewModel.userModel.losses ?? 0))
                                        .bold()
                                        .font(.system(size: UIScreen.main.bounds.width * 0.044))
                                    Rectangle()
                                        .fill(newCustomColorsModel.colorSchemeThree)
                                        .frame(width: UIScreen.main.bounds.width * 0.2, height: UIScreen.main.bounds.height * 0.005)
                                }
                            }
                            HStack(alignment: .center, spacing: UIScreen.main.bounds.width * 0.2){
                                VStack(alignment: .leading, spacing: UIScreen.main.bounds.width * 0.008){
                                    Text("Best Streak:")
                                        .foregroundColor(newCustomColorsModel.colorSchemeThree)
                                        .font(.system(size: UIScreen.main.bounds.width * 0.03))
                                        .underline()
                                    Text(String(viewModel.userModel.best_streak  ?? 0))
                                        .bold()
                                        .font(.system(size: UIScreen.main.bounds.width * 0.044))
                                    Rectangle()
                                        .fill(newCustomColorsModel.colorSchemeThree)
                                        .frame(width: UIScreen.main.bounds.width * 0.2, height: UIScreen.main.bounds.height * 0.005)
                                }
                                VStack(alignment: .leading, spacing: UIScreen.main.bounds.width * 0.008){
                                    Text("Current Streak:")
                                        .foregroundColor(newCustomColorsModel.colorSchemeThree)
                                        .font(.system(size: UIScreen.main.bounds.width * 0.03))
                                        .underline()
                                    Text(String(viewModel.userModel.win_streak  ?? 0))
                                        .bold()
                                        .font(.system(size: UIScreen.main.bounds.width * 0.044))
                                    Rectangle()
                                        .fill(newCustomColorsModel.colorSchemeThree)
                                        .frame(width: UIScreen.main.bounds.width * 0.2, height: UIScreen.main.bounds.height * 0.005)
                                }
                            }
                            Spacer()
                        }
                        .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.25, alignment: .center)
                        .background(newCustomColorsModel.customColor_1)
                        .border(newCustomColorsModel.colorSchemeThree, width: UIScreen.main.bounds.width * 0.04)
                        .cornerRadius(UIScreen.main.bounds.width * 0.06)
                    
                    if viewModel.has_streak {
                        HStack(alignment: .center){
                            Spacer()
                            VStack{
                                Image(systemName: "hourglass")
                                    .background(newCustomColorsModel.colorSchemeThree)
                                    .foregroundColor(newCustomColorsModel.customColor_1)
                                Text("You have 2 minutes to keep this streak")
                                    .foregroundColor(newCustomColorsModel.customColor_1)
                            }
                            .frame(width: UIScreen.main.bounds.width * 0.35, height: UIScreen.main.bounds.height * 0.07, alignment: .center)
                            .font(.system(size: UIScreen.main.bounds.width * 0.035))
                            .background(newCustomColorsModel.colorSchemeThree)
                            .cornerRadius(UIScreen.main.bounds.width * 0.02)
                            .offset(x:UIScreen.main.bounds.width * -0.05)
                        }
                        .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.07)
                    }
                    Spacer()
                    BannerAd(unitID: "ca-app-pub-3940256099942544/2934735716") // Fake Ad Unit
                    Spacer()
                    HStack{
                        VStack(alignment: .leading, spacing: 0.0){
                            HStack(alignment: .center, spacing: 0.0){
                                Text("Friends: ")
                                    .font(.system(size: UIScreen.main.bounds.width * 0.1))
                                    .fontWeight(.bold)
                                    .foregroundColor(darkMode ?? false ? .white : .black)
                                    .padding(UIScreen.main.bounds.width * 0.003)
                                Text(String(num_friends ?? 0))
                                    .font(.system(size: UIScreen.main.bounds.width * 0.1))
                                    .fontWeight(.bold)
                                    .foregroundColor(newCustomColorsModel.colorSchemeThree)
                                    .padding(UIScreen.main.bounds.width * 0.003)
                            }
                            Rectangle()
                                .fill(newCustomColorsModel.colorSchemeThree)
                                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.01)
                            Spacer().frame(height: UIScreen.main.bounds.height * 0.009)
                            Button(action: {viewModel.showRequest = !viewModel.showRequest}, label: {
                                Text("Add Friend")
                                    .font(.system(size: UIScreen.main.bounds.width * 0.05))
                                    .fontWeight(.bold)
                                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.05, alignment: .center)
                                    .background(newCustomColorsModel.customColor_1)
                                    .foregroundColor(.black)
                                    .cornerRadius(10)
                            })
                            Spacer().frame(height: UIScreen.main.bounds.height * 0.009)
                            NavigationLink(destination: {
                                FriendsView()
                                    .navigationBarBackButtonHidden(true)
                                    .navigationBarItems(leading: YellowBackButtonView())
                            }, label: {
                                HStack{
                                    Text("View Friends")
                                        .font(.system(size: UIScreen.main.bounds.width * 0.05))
                                        .fontWeight(.bold)
                                    if viewModel.userModel.hasRQ ?? false{
                                        Text("!")
                                            .font(.system(size: UIScreen.main.bounds.width * 0.03))
                                            .fontWeight(.bold)
                                            .frame(width: UIScreen.main.bounds.width * 0.2, height: UIScreen.main.bounds.height * 0.02, alignment: .center)
                                            .background(newCustomColorsModel.colorSchemeFour)
                                            .foregroundColor(newCustomColorsModel.customColor_1)
                                            .cornerRadius(30)
                                    }
                                    else if viewModel.userModel.hasGI ?? false{
                                        Text("!")
                                            .font(.system(size: UIScreen.main.bounds.width * 0.03))
                                            .fontWeight(.bold)
                                            .frame(width: UIScreen.main.bounds.height * 0.02, height: UIScreen.main.bounds.height * 0.02, alignment: .center)
                                            .background(newCustomColorsModel.colorSchemeFour)
                                            .foregroundColor(newCustomColorsModel.customColor_1)
                                            .cornerRadius(30)
                                    }
                                }
                                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.05, alignment: .center)
                                .background(newCustomColorsModel.colorSchemeThree)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                            })
                        }.padding()
                    }
                }
                if viewModel.showRequest{
                    HStack{
                        Spacer()
                        if viewModel.userModel.is_guest ?? false{
                            VStack{
                                Text("Guest cannot add friends!")
                                    .font(.system(size: UIScreen.main.bounds.width * 0.05))
                                    .foregroundColor(newCustomColorsModel.colorSchemeFour)
                                    .fontWeight(.bold)
                                Text("Go to the settings and add your account information first.")
                                    .foregroundColor(newCustomColorsModel.colorSchemeThree)
                                    .underline()
                                Button(action: {viewModel.showRequest = false}, label: {
                                    Text("Exit")
                                        .frame(width: UIScreen.main.bounds.width * 0.1, height: UIScreen.main.bounds.height * 0.04, alignment: .center)
                                        .background(newCustomColorsModel.customColor_1)
                                        .foregroundColor(newCustomColorsModel.colorSchemeThree)
                                        .fontWeight(.bold)
                                        .cornerRadius(8)
                                }).padding()
                            }
                        }
                        else{
                            VStack{
                                Text("Search for username")
                                    .foregroundColor(.black)
                                    .underline()
                                TextField("Search", text: $viewModel.sUsername)
                                    .foregroundColor(.black)
                                Rectangle()
                                    .fill(newCustomColorsModel.colorSchemeTwo)
                                    .frame(width: UIScreen.main.bounds.width * 0.75, height: UIScreen.main.bounds.height * 0.001)
                                if viewModel.usernameRes{
                                    Text(viewModel.result)
                                        .foregroundColor(newCustomColorsModel.colorSchemeSix)
                                        .font(.system(size: UIScreen.main.bounds.width * 0.04))
                                }
                                if viewModel.invalid_entry{
                                    Text(viewModel.result)
                                        .foregroundColor(newCustomColorsModel.colorSchemeFour)
                                        .font(.system(size: UIScreen.main.bounds.width * 0.04))
                                }
                                HStack{
                                    Button(action: {viewModel.showRequest = false}, label: {
                                        Text("Cancel")
                                            .frame(width: UIScreen.main.bounds.width * 0.25, height: UIScreen.main.bounds.height * 0.05, alignment: .center)
                                            .background(newCustomColorsModel.colorSchemeThree)
                                            .foregroundColor(newCustomColorsModel.customColor_1)
                                            .cornerRadius(8)
                                    }).padding()
                                    Button(action: {viewModel.pressed_send_request ? nil : viewModel.sendRequest()}, label: {
                                        Text("Send")
                                            .frame(width: UIScreen.main.bounds.width * 0.25, height: UIScreen.main.bounds.height * 0.05, alignment: .center)
                                            .background(newCustomColorsModel.colorSchemeThree)
                                            .foregroundColor(newCustomColorsModel.customColor_1)
                                            .cornerRadius(8)
                                    }).padding()
                                }
                            }
                        }
                        Spacer()
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.75, height: viewModel.smaller_screen ? UIScreen.main.bounds.height * 0.24 : UIScreen.main.bounds.height * 0.26, alignment: .center)
                    .background(newCustomColorsModel.customColor_1)
                    .border(newCustomColorsModel.colorSchemeThree, width: UIScreen.main.bounds.width * 0.005)
                    .offset(x: 0, y: viewModel.smaller_screen ? -125 : -140)
                }
            }
            else{
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint:newCustomColorsModel.colorSchemeThree))
                    .scaleEffect(UIScreen.main.bounds.width * 0.01)
            }
        }
    } //Some View
} //View

