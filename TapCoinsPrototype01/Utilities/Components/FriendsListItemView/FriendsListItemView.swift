//
//  FriendsListItemView.swift
//  TapCoinsPrototype01
//
//  Created by Eric Viera on 2/18/24.
//

import Foundation
import SwiftUI

struct FriendsListItemView: View {
    @AppStorage("num_friends") public var num_friends:Int?
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = FriendsListItemViewModel()
    var newCustomColorsModel = CustomColorsModel()
    var friend:String
    var index:Int
    var body: some View {
        VStack{
            if viewModel.friend_state == FriendItemState.NormalFriend {
                if viewModel.loading_the_switch {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint:newCustomColorsModel.colorSchemeThree))
                        .scaleEffect(UIScreen.main.bounds.width * 0.003)
                }
                else{
                    VStack{
                        HStack(spacing: 0){
                            Text(viewModel.active_friends_index_list.contains(index) ? "🟢"  : "🔴")
                                .frame(width:UIScreen.main.bounds.width * 0.1, height: UIScreen.main.bounds.height * 0.1)
                            Rectangle()
                                .fill(newCustomColorsModel.customColor_1)
                                .frame(width: UIScreen.main.bounds.width * 0.001, height: UIScreen.main.bounds.height * 0.08)
                            VStack(spacing:0){
                                Button(action: {viewModel.show_hide_friend_actions(index:index, friend: friend)}, label:{
                                    HStack(spacing:0){
                                        Spacer()
                                        Text(viewModel.normalFriendName)
                                            .font(.system(size: UIScreen.main.bounds.width * 0.045))
                                            .foregroundColor(newCustomColorsModel.customColor_1)
                                            .fontWeight(.bold)
                                            .frame(width: UIScreen.main.bounds.width * 0.6, height: UIScreen.main.bounds.height * 0.02)
                                            .padding()
                                        Image(systemName: viewModel.show_friend_actions_bool ? "arrowtriangle.up" : "arrowtriangle.down")
                                            .background(newCustomColorsModel.colorSchemeThree)
                                            .foregroundColor(newCustomColorsModel.customColor_1)
                                        Spacer()
                                    }
                                })
                                if viewModel.show_friend_actions_bool {
                                    HStack(alignment: .center, spacing: UIScreen.main.bounds.width * 0.01){
                                        Button(action: {viewModel.pressed_send_invite ? nil : viewModel.sendInvite(inviteName: viewModel.normalFriendName)}, label: {
                                            HStack{
                                                Text("Custom game")
                                                Image(systemName: "arrow.up.square.fill")
                                                    .background(newCustomColorsModel.customColor_1)
                                            }
                                            .foregroundColor(newCustomColorsModel.colorSchemeThree)
                                        })
                                        .frame(width: UIScreen.main.bounds.width * 0.38, height: UIScreen.main.bounds.height * 0.03, alignment: .center)
                                        .background(newCustomColorsModel.customColor_1)
                                        .cornerRadius(UIScreen.main.bounds.width * 0.005)
                                        // Hide View to Mimick Deleting Friend
                                        Button(action: {
                                            if !viewModel.pressed_remove_friend{
                                                print("IN DYNAMIC FRIEND BUTTON")
                                                viewModel.removeFriendTask(friend: viewModel.normalFriendName)
                                            }
                                        }, label: {
                                            HStack(alignment: .center, spacing: UIScreen.main.bounds.width * 0.01){
                                                Text("Remove Friend")
                                                    .font(.system(size: UIScreen.main.bounds.width * 0.04))
                                                Image(systemName: "delete.right.fill")
                                                    .background(newCustomColorsModel.customColor_1)
                                            }
                                            .background(newCustomColorsModel.customColor_1)
                                            .foregroundColor(newCustomColorsModel.colorSchemeFour)
                                        })
                                        .frame(width: UIScreen.main.bounds.width * 0.35, height: UIScreen.main.bounds.height * 0.03, alignment: .center)
                                        .background(newCustomColorsModel.customColor_1)
                                    }
                                    .frame(width: UIScreen.main.bounds.width * 0.4, height: UIScreen.main.bounds.height * 0.02, alignment: .center)
                                }
                            }
                            
                            
                        }
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.08)
                        Rectangle()
                            .fill(newCustomColorsModel.customColor_1)
                            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.001)
                    } // VStack
                    .background(newCustomColorsModel.colorSchemeThree)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.1)
//                    VStack{
//                        HStack(spacing: UIScreen.main.bounds.width * 0.03){
//                            Text(viewModel.active_friends_index_list.contains(index) ? "🟢"  : "🔴")
//                            Rectangle()
//                                .fill(newCustomColorsModel.customColor_1)
//                                .frame(width: UIScreen.main.bounds.width * 0.001, height: UIScreen.main.bounds.height * 0.06)
//                            Text(viewModel.adjustNormalFriendName(input_name: friend))
//                                .font(.system(size: UIScreen.main.bounds.width * 0.045))
//                                .foregroundColor(newCustomColorsModel.customColor_1)
//                                .fontWeight(.bold)
//                                .frame(width: viewModel.show_friend_actions_bool  ? UIScreen.main.bounds.width * 0.3 : UIScreen.main.bounds.width * 0.6, height: UIScreen.main.bounds.height * 0.03)
//                                .padding()
//                            HStack{
//                                Rectangle()
//                                    .fill(newCustomColorsModel.customColor_1)
//                                    .frame(width: UIScreen.main.bounds.width * 0.001, height: UIScreen.main.bounds.height * 0.06)
//                                Button(action: {viewModel.show_hide_friend_actions(index:index, friend: friend)}, label:{
//                                    Image(systemName: viewModel.show_friend_actions_bool ? "arrowtriangle.right" : "arrowtriangle.left")
//                                        .background(newCustomColorsModel.customColor_2)
//                                        .foregroundColor(newCustomColorsModel.customColor_1)
//                                        .frame(width: UIScreen.main.bounds.width * 0.08, height: UIScreen.main.bounds.height * 0.03)
//                                })
//                                if viewModel.show_friend_actions_bool {
//                                    VStack(alignment: .center, spacing: UIScreen.main.bounds.width * 0.01){
//                                        Button(action: {viewModel.pressed_send_invite ? nil : viewModel.sendInvite(inviteName: friend)}, label: {
//                                            HStack{
//                                                Text("Custom game")
//                                                Image(systemName: "arrow.up.square.fill")
//                                                    .background(newCustomColorsModel.customColor_3)
//                                                    .foregroundColor(newCustomColorsModel.customColor_1)
//                                            }
//                                            .foregroundColor(newCustomColorsModel.customColor_1)
//                                        })
//                                        .frame(width: UIScreen.main.bounds.width * 0.4, height: UIScreen.main.bounds.height * 0.03, alignment: .center)
//                                        .background(newCustomColorsModel.customColor_3)
//                                        .cornerRadius(UIScreen.main.bounds.width * 0.02)
//                                        Button(action: {
//                                            if !viewModel.pressed_remove_friend{
//                                                print("IN NORMAL FRIEND BUTTON")
//                                                viewModel.pressed_remove_friend = true
//                                                viewModel.removeFriendTask(friend: friend)
//                                            }
//                                        }, label: {
//                                            HStack(alignment: .center, spacing: UIScreen.main.bounds.width * 0.01){
//                                                Text("Remove Friend")
//                                                    .font(.system(size: UIScreen.main.bounds.width * 0.04))
//                                                Image(systemName: "delete.right.fill")
//                                                    .background(newCustomColorsModel.customColor_3)
//                                                    .foregroundColor(.red)
//                                            }
//                                        })
//                                        .frame(width: UIScreen.main.bounds.width * 0.4, height: UIScreen.main.bounds.height * 0.03, alignment: .center)
//                                        .background(newCustomColorsModel.customColor_3)
//                                        .cornerRadius(UIScreen.main.bounds.width * 0.02)
//                                    }
//                                    .frame(width: UIScreen.main.bounds.width * 0.4, height: UIScreen.main.bounds.height * 0.06, alignment: .center)
//                                }
//                            }
//                            .frame(width: viewModel.show_friend_actions_bool ? UIScreen.main.bounds.width * 0.4 : UIScreen.main.bounds.width * 0.1, height: UIScreen.main.bounds.height * 0.06, alignment: .center)
//
//                        }
//                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.06)
//                        Rectangle()
//                            .fill(newCustomColorsModel.customColor_1)
//                            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.001)
//                    } // VStack
                }
            }
            else if viewModel.friend_state == FriendItemState.DynamicFriend{
                if friend.contains("Friend request from"){
                    VStack(spacing: 0){
                        VStack(spacing: 0){
                            Button(action: {viewModel.show_hide_friend_request_actions(index:friend)}, label:{
                                HStack(spacing: 0){
                                    Text(friend)
                                        .frame(width: UIScreen.main.bounds.width * 0.92, height: UIScreen.main.bounds.height * 0.05)
                                        .font(.system(size: UIScreen.main.bounds.width * 0.045))
                                        .fontWeight(.bold)
                                        .foregroundColor(newCustomColorsModel.customColor_1)
                                        .background(newCustomColorsModel.colorSchemeThree)
                                    Image(systemName: viewModel.show_friend_request_actions_bool ? "envelope.open.fill" : "envelope.fill")
                                        .frame(width: UIScreen.main.bounds.width * 0.08, height: UIScreen.main.bounds.height * 0.05)
                                        .background(newCustomColorsModel.colorSchemeThree)
                                        .foregroundColor(newCustomColorsModel.customColor_1)
                                }
                            })
                        }
                        if viewModel.show_friend_request_actions_bool{
                            HStack(alignment: .center, spacing: UIScreen.main.bounds.width * 0.01){
                                Button(action: {
                                    if !viewModel.pressed_decline_request{
                                        viewModel.declineRequestTask(friend: viewModel.friend_requester_name)
                                    }
                                }, label: {
                                    HStack(alignment: .center, spacing: UIScreen.main.bounds.width * 0.01){
                                        Text("Decline Request")
                                            .font(.system(size: UIScreen.main.bounds.width * 0.04))
                                        Image(systemName: "minus.square.fill")
                                            .background(newCustomColorsModel.colorSchemeThree)
                                            .foregroundColor(newCustomColorsModel.customColor_1)
                                    }
                                    .foregroundColor(newCustomColorsModel.customColor_1)
                                })
                                .frame(width: UIScreen.main.bounds.width * 0.49, height: UIScreen.main.bounds.height * 0.03, alignment: .center)
                                .background(newCustomColorsModel.colorSchemeThree)
                                .cornerRadius(UIScreen.main.bounds.width * 0.02)
                                Button(action: {viewModel.pressed_accept_request ? nil : viewModel.acceptRequestTask(friend: viewModel.friend_requester_name)}, label: {
                                    HStack(alignment: .center, spacing: UIScreen.main.bounds.width * 0.01){
                                        Text("Accept Request")
                                            .font(.system(size: UIScreen.main.bounds.width * 0.04))
                                        Image(systemName: "checkmark.square.fill")
                                            .background(newCustomColorsModel.colorSchemeThree)
                                            .foregroundColor(newCustomColorsModel.customColor_1)
                                    }
                                    .foregroundColor(newCustomColorsModel.customColor_1)
                                })
                                .frame(width: UIScreen.main.bounds.width * 0.49, height: UIScreen.main.bounds.height * 0.03, alignment: .center)
                                .background(newCustomColorsModel.colorSchemeThree)
                                .cornerRadius(UIScreen.main.bounds.width * 0.02)
                            }
                            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.05, alignment: .center)
                            .background(newCustomColorsModel.customColor_1)
                        }
                        Rectangle()
                            .fill(newCustomColorsModel.customColor_1)
                            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.001)
                    }
                }
                else if friend.contains("Pending request"){
                    VStack(spacing: UIScreen.main.bounds.width * 0.01){
                        Text(friend)
                            .font(.system(size: UIScreen.main.bounds.width * 0.045))
                            .foregroundColor(newCustomColorsModel.colorSchemeThree)
                            .fontWeight(.bold)
                        Rectangle()
                            .fill(newCustomColorsModel.colorSchemeThree)
                            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.001)
                    }
                }
                else if friend.contains("Game invite from"){
                    VStack(spacing: UIScreen.main.bounds.width * 0.01){
                        VStack(alignment: .center, spacing: 0){
                            Text(friend)
                                .font(.system(size: UIScreen.main.bounds.width * 0.045))
                                .foregroundColor(newCustomColorsModel.colorSchemeTwo)
                                .fontWeight(.bold)
                            HStack{
                                Button(action: {viewModel.pressed_accept_invite ? nil : viewModel.acceptInvite(inviteName: friend)}, label: {
                                    HStack{
                                        Text("Accept")
                                        Image(systemName: "checkmark.square.fill")
                                            .background(newCustomColorsModel.colorSchemeTwo)
                                            .foregroundColor(newCustomColorsModel.colorSchemeSix)
                                    }
                                    .frame(width: UIScreen.main.bounds.width * 0.35, height: UIScreen.main.bounds.height * 0.03, alignment: .center)
                                    .background(newCustomColorsModel.colorSchemeTwo)
                                    .foregroundColor(newCustomColorsModel.colorSchemeSix)

                                })
                                // Turn game invite to normal friend
                                Button(action: {viewModel.pressed_decline_invite ? nil : viewModel.declineInvite(inviteName: friend)}, label: {
                                    HStack{
                                        Text("Decline")
                                        Image(systemName: "xmark.square.fill")
                                            .background(newCustomColorsModel.colorSchemeTwo)
                                            .foregroundColor(newCustomColorsModel.colorSchemeSix)
                                    }
                                    .frame(width: UIScreen.main.bounds.width * 0.35, height: UIScreen.main.bounds.height * 0.03, alignment: .center)
                                    .background(newCustomColorsModel.colorSchemeTwo)
                                    .foregroundColor(newCustomColorsModel.colorSchemeSix)

                                })
                            }
                        }
                        Rectangle()
                            .fill(newCustomColorsModel.colorSchemeTwo)
                            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.001)
                    }
                    .background(newCustomColorsModel.colorSchemeSix)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.1)
                }
                else{
                    VStack{
                        HStack(spacing: 0){
                            Text(viewModel.active_friends_index_list.contains(index) ? "🟢"  : "🔴")
                                .frame(width:UIScreen.main.bounds.width * 0.1, height: UIScreen.main.bounds.height * 0.1)
                            Rectangle()
                                .fill(newCustomColorsModel.customColor_1)
                                .frame(width: UIScreen.main.bounds.width * 0.001, height: UIScreen.main.bounds.height * 0.08)
                            VStack(spacing:0){
                                Button(action: {viewModel.show_hide_friend_actions(index:index, friend: friend)}, label:{
                                    HStack(spacing:0){
                                        Spacer()
                                        Text(friend)
                                            .font(.system(size: UIScreen.main.bounds.width * 0.045))
                                            .foregroundColor(newCustomColorsModel.customColor_1)
                                            .fontWeight(.bold)
                                            .frame(width: UIScreen.main.bounds.width * 0.6, height: UIScreen.main.bounds.height * 0.02)
                                            .padding()
                                        Image(systemName: viewModel.show_friend_actions_bool ? "arrowtriangle.up" : "arrowtriangle.down")
                                            .background(newCustomColorsModel.colorSchemeThree)
                                            .foregroundColor(newCustomColorsModel.customColor_1)
                                        Spacer()
                                    }
                                })
                                if viewModel.show_friend_actions_bool {
                                    HStack(alignment: .center, spacing: UIScreen.main.bounds.width * 0.01){
                                        Button(action: {viewModel.pressed_send_invite ? nil : viewModel.sendInvite(inviteName: friend)}, label: {
                                            HStack{
                                                Text("Custom game")
                                                Image(systemName: "arrow.up.square.fill")
                                                    .background(newCustomColorsModel.customColor_1)
                                            }
                                            .foregroundColor(newCustomColorsModel.colorSchemeThree)
                                        })
                                        .frame(width: UIScreen.main.bounds.width * 0.38, height: UIScreen.main.bounds.height * 0.03, alignment: .center)
                                        .background(newCustomColorsModel.customColor_1)
                                        .cornerRadius(UIScreen.main.bounds.width * 0.005)
                                        // Hide View to Mimick Deleting Friend
                                        Button(action: {
                                            if !viewModel.pressed_remove_friend{
                                                print("IN DYNAMIC FRIEND BUTTON")
                                                viewModel.removeFriendTask(friend: friend)
                                            }
                                        }, label: {
                                            HStack(alignment: .center, spacing: UIScreen.main.bounds.width * 0.01){
                                                Text("Remove Friend")
                                                    .font(.system(size: UIScreen.main.bounds.width * 0.04))
                                                Image(systemName: "delete.right.fill")
                                                    .background(newCustomColorsModel.customColor_1)
                                            }
                                            .background(newCustomColorsModel.customColor_1)
                                            .foregroundColor(newCustomColorsModel.colorSchemeFour)
                                        })
                                        .frame(width: UIScreen.main.bounds.width * 0.35, height: UIScreen.main.bounds.height * 0.03, alignment: .center)
                                        .background(newCustomColorsModel.customColor_1)
                                    }
                                    .frame(width: UIScreen.main.bounds.width * 0.4, height: UIScreen.main.bounds.height * 0.02, alignment: .center)
                                }
                            }
                            
                            
                        }
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.08)
                        Rectangle()
                            .fill(newCustomColorsModel.customColor_1)
                            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.001)
                    } // VStack
                    .background(newCustomColorsModel.colorSchemeThree)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.1)
                    
                }
            }
        }
    }
}
