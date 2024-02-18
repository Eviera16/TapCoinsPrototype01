//
//  PMenuView.swift
//  TapCoinsPrototype01
//
//  Created by Eric Viera on 2/18/24.
//

import Foundation
import SwiftUI

struct PMenuView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = PMenuViewModel()
    @AppStorage("darkMode") var darkMode: Bool?
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
                Spacer()
                Text("Choose Difficulty")
                    .font(.system(size: UIScreen.main.bounds.width * 0.1))
                    .foregroundColor(darkMode ?? false ? newCustomColorsModel.customColor_1 : newCustomColorsModel.colorSchemeThree)
                    .fontWeight(.bold)
                Spacer()
                VStack(alignment: .center, spacing: UIScreen.main.bounds.width * 0.2){
                    NavigationLink(destination: {
                        PGameView()
                            .navigationBarBackButtonHidden(true)
                    }, label: {
                        Text("Easy")
                            .frame(width: UIScreen.main.bounds.width * 0.6, height: UIScreen.main.bounds.height * 0.1, alignment: .center)
                            .fontWeight(.bold)
                            .foregroundColor(newCustomColorsModel.colorSchemeThree)
                            .font(.system(size: UIScreen.main.bounds.width * 0.07))
                            .background(newCustomColorsModel.customColor_1)
                            .cornerRadius(8)
                    })
                    .simultaneousGesture(
                                    TapGesture()
                                        .onEnded {
                                            // Call your function here
                                            viewModel.got_difficulty(diff: "easy")
                                        }
                                )
                    NavigationLink(destination: {
                        PGameView()
                            .navigationBarBackButtonHidden(true)
                    }, label: {
                        Text("Medium")
                            .frame(width: UIScreen.main.bounds.width * 0.6, height: UIScreen.main.bounds.height * 0.1, alignment: .center)
                            .fontWeight(.bold)
                            .foregroundColor(newCustomColorsModel.customColor_1)
                            .font(.system(size: UIScreen.main.bounds.width * 0.07))
                            .background(newCustomColorsModel.colorSchemeThree)
                            .cornerRadius(8)
                    })
                    .simultaneousGesture(
                                    TapGesture()
                                        .onEnded {
                                            // Call your function here
                                            viewModel.got_difficulty(diff: "medium")
                                        }
                                )
                    NavigationLink(destination: {
                        PGameView()
                            .navigationBarBackButtonHidden(true)
                    }, label: {
                        Text("Hard")
                            .frame(width: UIScreen.main.bounds.width * 0.6, height: UIScreen.main.bounds.height * 0.1, alignment: .center)
                            .fontWeight(.bold)
                            .foregroundColor(newCustomColorsModel.customColor_1)
                            .font(.system(size: UIScreen.main.bounds.width * 0.07))
                            .background(newCustomColorsModel.colorSchemeFour)
                            .cornerRadius(8)
                    })
                    .simultaneousGesture(
                                    TapGesture()
                                        .onEnded {
                                            // Call your function here
                                            viewModel.got_difficulty(diff: "hard")
                                        }
                                )
                }
                Spacer()
            }
        } // ZStack
    }

}

