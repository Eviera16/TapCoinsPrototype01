//
//  FriendsView.swift
//  TapCoinsPrototype01
//
//  Created by Eric Viera on 2/18/24.
//

import Foundation
import SwiftUI

struct FriendsView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = FriendsViewModel()
    @AppStorage("darkMode") var darkMode: Bool?
    var newCustomColorsModel = CustomColorsModel()
    var body: some View {
        ZStack{
            if darkMode ?? false{
                Color(.black).ignoresSafeArea()
            }
            else{
                newCustomColorsModel.colorSchemeOne.ignoresSafeArea()
            }
            VStack{
                Text("Friends")
                    .font(.system(size: UIScreen.main.bounds.width * 0.1))
                    .fontWeight(.bold)
                    .frame(width: UIScreen.main.bounds.width , height: UIScreen.main.bounds.height * 0.08)
                    .foregroundColor(newCustomColorsModel.customColor_1)
                    .background(newCustomColorsModel.colorSchemeThree)

                ScrollView{
                    VStack{
                        if viewModel.userModel?.fArrayCount == 0{
                            HStack{
                                Text("No friends yet")
                                    .font(.system(size: UIScreen.main.bounds.width * 0.06))
                                    .foregroundColor(newCustomColorsModel.colorSchemeFour)
                                    .fontWeight(.bold)
                            }
                            Rectangle()
                                .fill(newCustomColorsModel.colorSchemeFour)
                                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.001)
                        }
                        else{
                            ForEach(Array(viewModel.userModel?.friends?.enumerated() ?? ["NO FRIENDS"].enumerated()), id: \.element) { index, friend in
                                FriendsListItemView(friend: friend, index: index)
                            }
                        }
                    }
                }
            }
        } //ZStack
    }
}
