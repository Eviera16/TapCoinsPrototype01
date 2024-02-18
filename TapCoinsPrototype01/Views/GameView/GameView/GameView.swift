//
//  GameView.swift
//  TapCoinsPrototype01
//
//  Created by Eric Viera on 2/18/24.
//

import Foundation
import SwiftUI
import zlib

struct GameView: View {
    @AppStorage("session") var logged_in_user: String?
    @AppStorage("in_game") var in_game: Bool?
    @AppStorage("in_queue") var in_queue: Bool?
    @AppStorage("darkMode") var darkMode: Bool?
    @StateObject private var viewModel = GameViewModel()
    @State var int_ex = 0
    var newCustomColorsModel = CustomColorsModel()

    let timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack{
            if darkMode ?? false {
                Color(.black).ignoresSafeArea()
            }
            else{
                newCustomColorsModel.colorSchemeOne.ignoresSafeArea()
            }
            HStack{
                HStack{
                    Text(viewModel.first)
                        .font(.system(size: UIScreen.main.bounds.width * 0.06))
                        .foregroundColor(newCustomColorsModel.colorSchemeThree)
                    Text(String(viewModel.fPoints))
                        .font(.system(size: UIScreen.main.bounds.width * 0.06))
                        .foregroundColor(newCustomColorsModel.colorSchemeThree)
                }
                Rectangle()
                    .fill(.black)
                    .frame(width: UIScreen.main.bounds.width * 0.03, height: UIScreen.main.bounds.height * 0.06)
                HStack{
                    Text(viewModel.second)
                        .font(.system(size: UIScreen.main.bounds.width * 0.06))
                        .foregroundColor(newCustomColorsModel.colorSchemeFour)
                    Text(String(viewModel.sPoints))
                        .font(.system(size: UIScreen.main.bounds.width * 0.06))
                        .foregroundColor(newCustomColorsModel.colorSchemeFour)
                }
            }
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.06)
            .offset(x: 0.0, y: UIScreen.main.bounds.height * -0.4)
            .padding()
            VStack(alignment: .center, spacing: viewModel.smaller_screen ? UIScreen.main.bounds.width * 0.005 : UIScreen.main.bounds.width * 0.01){
                ForEach(viewModel.coins.indices) { index in
                    if viewModel.coins[index]{
                        HStack(alignment: .center, spacing: UIScreen.main.bounds.width * 0.1){
                            CoinView(viewModel: viewModel, x_val: 0, y_val: index)
                            CoinView(viewModel: viewModel, x_val: 1, y_val: index)
                            CoinView(viewModel: viewModel, x_val: 2, y_val: index)
                            CoinView(viewModel: viewModel, x_val: 3, y_val: index)
                        }
                    }
                    else{
                        HStack(alignment: .center, spacing: UIScreen.main.bounds.width * 0.1){
                            CoinView(viewModel: viewModel, x_val: 0, y_val: index)
                            CoinView(viewModel: viewModel, x_val: 1, y_val: index)
                            CoinView(viewModel: viewModel, x_val: 2, y_val: index)
                        }
                    }
                }
            }
            .padding()

            if (viewModel.startGame == false){
                if viewModel.ready_uped == false{
                    VStack{
                        Text(viewModel.waitingStatus)
                            .foregroundColor(newCustomColorsModel.colorSchemeThree)
                        HStack{
                            Spacer()
                            VStack(alignment: .center, spacing: UIScreen.main.bounds.width * 0.04){
                                Text(viewModel.first)
                                Button(action: {
                                    if viewModel.is_first ?? false{
                                        if !viewModel.ready{
                                            if viewModel.waitingStatus == "Opponent connected"{
                                                viewModel.ready_up(username: viewModel.first)
                                            }
                                        }
                                    }
                                }, label: {
                                    Text("Ready up")
                                        .frame(width: UIScreen.main.bounds.width * 0.2, height: UIScreen.main.bounds.height * 0.05, alignment: .center)
                                        .background(viewModel.fColor)
                                        .foregroundColor(newCustomColorsModel.colorSchemeThree)
                                        .cornerRadius(10)
                                })
                            }
                            .frame(width: UIScreen.main.bounds.width * 0.25, height: UIScreen.main.bounds.height * 0.15, alignment: .center)
                            .background(newCustomColorsModel.colorSchemeThree)
                            .foregroundColor(newCustomColorsModel.customColor_1)
                            .cornerRadius(10)
                            Spacer()
                            VStack(alignment: .center, spacing: UIScreen.main.bounds.width * 0.04){
                                Text(viewModel.second)
                                Button(action: {
                                    if viewModel.is_first ?? false{
                                        //pass
                                    }
                                    else{
                                        if !viewModel.ready{
                                            if viewModel.waitingStatus == "Opponent connected"{
                                                viewModel.ready_up(username: viewModel.second)
                                            }
                                        }
                                    }
                                }, label: {
                                    Text("Ready up")
                                        .frame(width: UIScreen.main.bounds.width * 0.2, height: UIScreen.main.bounds.height * 0.05, alignment: .center)
                                        .background(viewModel.sColor)
                                        .foregroundColor(newCustomColorsModel.colorSchemeThree)
                                        .cornerRadius(10)
                                })
                            }
                            .frame(width: UIScreen.main.bounds.width * 0.25, height: UIScreen.main.bounds.height * 0.15, alignment: .center)
                            .background(newCustomColorsModel.colorSchemeThree)
                            .foregroundColor(newCustomColorsModel.customColor_1)
                            .cornerRadius(10)
                            Spacer()
                        }
                        Button(action: {viewModel.cancel_game(cancelled: true)}, label: {
                            Text("Cancel")
                                .frame(width: UIScreen.main.bounds.width * 0.2, height: UIScreen.main.bounds.height * 0.05, alignment: .center)
                                .background(newCustomColorsModel.colorSchemeThree)
                                .foregroundColor(newCustomColorsModel.customColor_1)
                                .cornerRadius(10)
                        })
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.7, height: UIScreen.main.bounds.height * 0.25, alignment: .center)
                    .background(newCustomColorsModel.customColor_1)
                    .cornerRadius(10)
                }
                else{
                    Text(viewModel.gameStart)
                        .frame(width: UIScreen.main.bounds.width * 0.3, height: UIScreen.main.bounds.height * 0.05, alignment: .center)
                        .background(newCustomColorsModel.customColor_1)
                        .foregroundColor(newCustomColorsModel.colorSchemeThree)
                        .cornerRadius(10)
                }
            }
            if (viewModel.endGame == true){
                VStack(spacing: UIScreen.main.bounds.width * 0.05){
                    if viewModel.is_a_tie{
                        Text("It is a tie.")
                            .foregroundColor(newCustomColorsModel.colorSchemeThree)
                    }
                    else{
                        Text(viewModel.winner + " is the winner!")
                            .foregroundColor(newCustomColorsModel.colorSchemeThree)
                    }
                    if viewModel.from_queue ?? false{
                        Button(action: {
                            viewModel.next_game()
                        }, label: {
                            Text("Next Game")
                        })
                        .frame(width: UIScreen.main.bounds.width * 0.55, height: UIScreen.main.bounds.height * 0.05, alignment: .center)
                        .background(newCustomColorsModel.colorSchemeThree)
                        .foregroundColor(newCustomColorsModel.customColor_1)
                        .cornerRadius(5)
                        Button(action: {
                            viewModel.return_home(exit:false)
                        }, label: {
                            Text("Return Home")
                        })
                        .frame(width: UIScreen.main.bounds.width * 0.55, height: UIScreen.main.bounds.height * 0.05, alignment: .center)
                        .background(newCustomColorsModel.colorSchemeThree)
                        .foregroundColor(newCustomColorsModel.customColor_1)
                        .cornerRadius(5)
                    }
                    else{
                        if viewModel.paPressed{
                            Text(viewModel.waitingStatus)
                                .frame(width: UIScreen.main.bounds.width * 0.5, height: UIScreen.main.bounds.height * 0.04, alignment: .center)
                                .background(newCustomColorsModel.colorSchemeThree)
                                .foregroundColor(newCustomColorsModel.customColor_1)
                        }
                        Button(action: {
                            if !viewModel.currPaPressed{
                                viewModel.play_again()
                            }
                        }, label: {
                            Text("Play again votes: " + String(viewModel.paVotes))
                        })
                        .frame(width: UIScreen.main.bounds.width * 0.5, height: UIScreen.main.bounds.height * 0.045, alignment: .center)
                        .background(newCustomColorsModel.colorSchemeThree)
                        .foregroundColor(newCustomColorsModel.customColor_1)
                        .cornerRadius(5)
                        Button(action: {
                            viewModel.return_home(exit: false)
                        }, label: {
                            Text("Return Home")
                        })
                        .frame(width: UIScreen.main.bounds.width * 0.5, height: UIScreen.main.bounds.height * 0.045, alignment: .center)
                        .background(newCustomColorsModel.colorSchemeThree)
                        .foregroundColor(newCustomColorsModel.customColor_1)
                        .cornerRadius(5)
                    }
                }
                .frame(width: UIScreen.main.bounds.width * 0.7, height: UIScreen.main.bounds.height * 0.25, alignment: .center)
                .background(newCustomColorsModel.customColor_1)
                .cornerRadius(10)
            }
            VStack{
                Button(action: {
                    viewModel.return_home(exit: true)
                }, label: {
                    Text("Exit")
                        .foregroundColor(newCustomColorsModel.customColor_1)
                })
            }
            .background(Color(.black))
            .offset(x: 0.0, y: UIScreen.main.bounds.height * -0.4)
            .padding()

            Text(String(viewModel.count))
                .foregroundColor(newCustomColorsModel.colorSchemeFour)
                .offset(x: 0.0, y: UIScreen.main.bounds.height * -0.45)
                .padding()



            if viewModel.opp_disconnected{
                Text(viewModel.disconnectMessage)
                    .frame(width: UIScreen.main.bounds.width * 0.45, height: UIScreen.main.bounds.height * 0.05, alignment: .center)
                    .background(newCustomColorsModel.customColor_1)
                    .foregroundColor(newCustomColorsModel.colorSchemeFour)
                    .cornerRadius(10)
            }

        }
        .onReceive(timer, perform: { _ in
            if viewModel.startGame{
                if viewModel.count > 0 {
                    viewModel.count -= 1
                }
                else if viewModel.count == 0{
                    viewModel.times_up()
                }
            }
        })
        .onDisappear { in_game = false }
    }
}
