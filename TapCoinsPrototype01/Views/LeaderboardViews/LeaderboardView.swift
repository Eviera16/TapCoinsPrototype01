//
//  LeaderboardView.swift
//  TapCoinsPrototype01
//
//  Created by Eric Viera on 2/18/24.
//

import Foundation
import SwiftUI

struct LeaderboardView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = LeaderboardViewModel()
    var newCustomColorsModel = CustomColorsModel()
    @State private var sortOrder = [KeyPathComparator(\TableUserModel.win_percentage)]
    @Environment(\.horizontalSizeClass) var sizeClass
    var body: some View {
            if viewModel.loaded_users{
                VStack{
                    Text("Leaderboards")
                        .font(.system(size: UIScreen.main.bounds.width * 0.06, weight: .semibold))
                        .multilineTextAlignment(.center)
                        .foregroundColor(newCustomColorsModel.customColor_2)
//                    if sizeClass == .compact {
//                        HStack{
//                            Spacer()
//                            Text("Username")
//                            Spacer()
//                            Text("Wins")
//                            Spacer()
//                            Text("loses")
//                            Spacer()
//                            Text("Win%")
//                            Spacer()
//                            Text("Total Games")
//                            Spacer()
//                        }
//                    }
                    Table(viewModel.users_list, sortOrder: $sortOrder){
                        // Add value to Star
//                        if sizeClass != .compact {
//                            TableColumn("🌟"){ user in
//                                Text("NB")
//                            }
//                        }
                        TableColumn("Username", value: \.username){ user in
                            if sizeClass == .compact {
                                ZStack{
                                    if user.username == viewModel.first_user {
                                        VStack(alignment: .leading){
                                            HStack(alignment: .center, spacing: UIScreen.main.bounds.width * 0.03){
                                                Text("🌟")
                                                Text("UName")
                                                    .font(.caption2)
                                                Text("W")
                                                    .font(.caption2)
                                                Text("L")
                                                    .font(.caption2)
                                                Text("W%")
                                                    .font(.caption2)
                                                Text("TGames")
                                                    .font(.caption2)
                                            }
                                            Rectangle()
                                                .fill(Color(.black))
                                                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 0.005)
                                                .offset(x: UIScreen.main.bounds.width * -0.05)
                                            LeaderBoardRowView(user: user)
                                        }
                                    }
                                    else{
                                        LeaderBoardRowView(user: user)
                                    }
                                }
                            } else{
                                HStack{
                                    Text(user.username)
                                    Spacer()
                                }
                            }
                        }
                        TableColumn("Wins", value: \.wins){ user in
                            Text("\(user.wins)")
                        }
                        TableColumn("Losses", value: \.losses){ user in
                            Text("\(user.losses)")
                        }
                        TableColumn("Win%"){ user in
                            Text("\(user.win_percentage)")
                        }
                        TableColumn("Total Games"){ user in
                            Text("\(user.total_games)")
                        }
                    } // Table
                    .onChange(of: sortOrder) { newOrder in
                        viewModel.users_list.sort(using: newOrder)
                    }
                }.frame(width: UIScreen.main.bounds.width * 0.4, height: UIScreen.main.bounds.height * 0.2, alignment: .center)
            } // if
            else{
                Spacer()
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint:newCustomColorsModel.customColor_1))
                    .scaleEffect(4)
                Spacer()
            } // else
    } // Second View
} // First View
