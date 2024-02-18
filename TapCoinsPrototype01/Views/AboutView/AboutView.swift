//
//  AboutView.swift
//  TapCoinsPrototype01
//
//  Created by Eric Viera on 2/18/24.
//

import Foundation
import SwiftUI

struct AboutView: View {
    @AppStorage("darkMode") var darkMode: Bool?
    @Environment(\.presentationMode) var presentationMode
//    @AppStorage("session") var logged_in_user: String?
    var newCustomColorsModel = CustomColorsModel()
    
    var body: some View {
        ZStack{
            newCustomColorsModel.colorSchemeThree.ignoresSafeArea()
            HStack{
                Spacer()
                VStack{
                    Text("About")
                        .font(.system(size: UIScreen.main.bounds.width * 0.1))
                        .foregroundColor(newCustomColorsModel.customColor_1)
                        .underline()
                    ScrollView{
                        VStack{
                            VStack(alignment: .leading, spacing: UIScreen.main.bounds.width * 0.14){
                                VStack(alignment: .center){
                                    HStack{
                                        Image("Custom_Color_3_TC")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: UIScreen.main.bounds.width * 0.1, height: UIScreen.main.bounds.width * 0.1, alignment: .center)
                                            .cornerRadius(100)
                                        Image("Custom_Color_1_TC")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: UIScreen.main.bounds.width * 0.1, height: UIScreen.main.bounds.width * 0.1, alignment: .center)
                                            .cornerRadius(100)
                                        Image("Custom_Color_2_TC")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: UIScreen.main.bounds.width * 0.1, height: UIScreen.main.bounds.width * 0.1, alignment: .center)
                                            .cornerRadius(100)
                                    }
                                    VStack(alignment: .leading, spacing: 0){
                                        HStack(alignment: .center, spacing: 0.0){
                                            Text("Tap")
                                                .font(.system(size: UIScreen.main.bounds.width * 0.08))
                                                .foregroundColor(newCustomColorsModel.colorSchemeThree)
                                                .fontWeight(.bold)
                                            Text("Coins")
                                                .font(.system(size: UIScreen.main.bounds.width * 0.08))
                                                .foregroundColor(newCustomColorsModel.colorSchemeFour)
                                                .fontWeight(.bold)
                                        }
                                        Rectangle()
                                            .fill(newCustomColorsModel.customColor_1)
                                            .frame(width: UIScreen.main.bounds.width * 0.35, height: UIScreen.main.bounds.height * 0.01)
                                    }
                                }
                                
                                Text("A high-speed multiplayer game where you have 10 seconds to tap as many coins as you can before your oppenent! Play against friends in Custom Games or build your streak up in public matches to see how many games you can win in a row! But be quick you only have 2 minutes between each game to continue your streak.")
                                    .font(.system(size: UIScreen.main.bounds.width * 0.055))
                                    .foregroundColor(darkMode ?? false ? Color(.white) : Color(.black))
                            }
                            .padding()
                            .frame(width: UIScreen.main.bounds.width * 0.85, height: UIScreen.main.bounds.height * 0.6, alignment: .center)
                            .background(darkMode ?? false ? Color(.black) : newCustomColorsModel.colorSchemeOne)
                            .cornerRadius(UIScreen.main.bounds.width * 0.03)
                            VStack{
                                Rectangle()
                                    .fill(newCustomColorsModel.customColor_1)
                                    .frame(width: UIScreen.main.bounds.width * 0.85, height: UIScreen.main.bounds.height * 0.005)
                            }
                            .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.2, alignment: .center)
//                            VStack(alignment: .leading, spacing: UIScreen.main.bounds.width * 0.03){
//                                Text("Find A Game")
//                                    .font(.system(size: UIScreen.main.bounds.width * 0.08))
//                                    .foregroundColor(newCustomColorsModel.colorSchemeFour)
//                                    .fontWeight(.bold)
//                                Text("and play against an opponent online to tap more coins then they can! Build your streak up, but be quick you only have 2 minutes between each game to continue your streak.")
//                                    .foregroundColor(newCustomColorsModel.colorSchemeThree)
//                            }
//                            .padding()
//                            .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.6, alignment: .center)
//                            .background(darkMode ?? false ? Color(.black) : newCustomColorsModel.colorSchemeOne)
//                            .cornerRadius(UIScreen.main.bounds.width * 0.03)
//                            VStack{
//                                Rectangle()
//                                    .fill(newCustomColorsModel.customColor_1)
//                                    .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.005)
//                            }.frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.2, alignment: .center)
//                            VStack(alignment: .leading, spacing: UIScreen.main.bounds.width * 0.03){
//                                Text("Find A Game")
//                                    .font(.system(size: UIScreen.main.bounds.width * 0.08))
//                                    .foregroundColor(newCustomColorsModel.colorSchemeFour)
//                                    .fontWeight(.bold)
//                                Text("and play against an opponent online to tap more coins then they can! But be quick you only have 2 minutes between each game to continue your streak.")
//                                    .foregroundColor(newCustomColorsModel.colorSchemeThree)
//                            }
//                            .padding()
//                            .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.6, alignment: .center)
//                            .background(darkMode ?? false ? Color(.black) : newCustomColorsModel.colorSchemeOne)
//                            .cornerRadius(UIScreen.main.bounds.width * 0.03)
//                            VStack{
//                                Rectangle()
//                                    .fill(newCustomColorsModel.customColor_1)
//                                    .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.005)
//                            }.frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.1, alignment: .center)
                        }
                    }
                    
//                    VStack(alignment: .leading, spacing: UIScreen.main.bounds.width * 0.03){
//
//                        VStack(alignment: .leading, spacing: UIScreen.main.bounds.width * 0.03){
//                            Text("Find A Game")
//                                .font(.system(size: UIScreen.main.bounds.width * 0.08))
//                                .foregroundColor(newCustomColorsModel.customColor_1)
//                                .fontWeight(.bold)
//                            Text("and play against an opponent online to tap more coins then they can! Build your streak up, but be quick you only have 2 minutes between each game to continue your streak.")
//                                .foregroundColor(newCustomColorsModel.customColor_1)
//                        }
//                        .padding()
//                        .background(newCustomColorsModel.customColor_2)
//                        .cornerRadius(UIScreen.main.bounds.width * 0.03)
//                        VStack(alignment: .leading, spacing: UIScreen.main.bounds.width * 0.03){
//                            Text("Create")
//                                .font(.system(size: UIScreen.main.bounds.width * 0.08))
//                                .foregroundColor(newCustomColorsModel.customColor_1)
//                                .fontWeight(.bold)
//                            Text("a custom game and play against friends!")
//                                .foregroundColor(newCustomColorsModel.customColor_1)
//                        }
//                        .padding()
//                        .background(newCustomColorsModel.customColor_2)
//                        .cornerRadius(UIScreen.main.bounds.width * 0.03)
//                        VStack(alignment: .leading, spacing: UIScreen.main.bounds.width * 0.03){
//                            Text("Practice")
//                                .font(.system(size: UIScreen.main.bounds.width * 0.08))
//                                .foregroundColor(newCustomColorsModel.customColor_1)
//                                .fontWeight(.bold)
//                            Text("against the computer to get your skillz up!")
//                                .foregroundColor(newCustomColorsModel.customColor_1)
//                        }
//                        .padding()
//                        .background(newCustomColorsModel.customColor_2)
//                        .cornerRadius(UIScreen.main.bounds.width * 0.03)
//
//                        VStack(alignment: .leading, spacing: UIScreen.main.bounds.width * 0.03){
//                            Text("View your Profile")
//                                .font(.system(size: UIScreen.main.bounds.width * 0.08))
//                                .foregroundColor(newCustomColorsModel.customColor_1)
//                                .fontWeight(.bold)
//                            Text("to see what your current win streak is and your best overall!")
//                                .foregroundColor(newCustomColorsModel.customColor_1)
//                        }
//                        .padding()
//                        .background(newCustomColorsModel.customColor_2)
//                        .cornerRadius(UIScreen.main.bounds.width * 0.03)
//                    }
//                    VStack(alignment: .center, spacing: UIScreen.main.bounds.width * 0.05){
//                        Text("Good luck and have fun!!")
//                            .font(.system(size: UIScreen.main.bounds.width * 0.08))
//                            .foregroundColor(newCustomColorsModel.customColor_1)
//                            .fontWeight(.bold)
//                    }
//                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.05)
//                    .background(newCustomColorsModel.customColor_2)
//                    Spacer()
                }
                Spacer()
            }
        } //ZStack
    }
    
}

