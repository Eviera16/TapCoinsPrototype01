//
//  LeaderboardRow.swift
//  TapCoinsPrototype01
//
//  Created by Eric Viera on 2/18/24.
//

import Foundation
import SwiftUI

extension Color {
    static let gold = Color(red: 1.0, green: 0.84, blue: 0.0)
}

struct LeaderBoardRowView: View {
    var newCustomColorsModel = CustomColorsModel()
    var user:TableUserModel
    var body: some View {
        HStack(alignment: .center, spacing: UIScreen.main.bounds.width * 0.03){
            Text(
                user.league == 1 ? "NB" :
                    user.league == 2 ? "BA" :
                    user.league == 3 ? "OK" :
                    user.league == 4 ? "BT" :
                    user.league == 5 ? "GD" :
                    user.league == 6 ? "SD" :
                    user.league == 7 ? "SP" :
                    user.league == 8 ? "MG" :
                    user.league == 9 ? "GO" :
                    "NIL"
            )
                .font(.caption2)
                .frame(width: UIScreen.main.bounds.width * 0.05, height: UIScreen.main.bounds.width * 0.05)
                .background(
                    user.league == 1 ? Color(.gray) :
                        user.league == 2 ? Color(.brown) :
                        user.league == 3 ? Color(.white) :
                        user.league == 4 ? Color(.yellow) :
                        user.league == 5 ? Color(.green) :
                        user.league == 6 ? Color(.red) :
                        user.league == 7 ? Color(.blue) :
                        user.league == 8 ? Color(.purple) :
                        user.league == 9 ? Color(red: 1.0, green: 0.84, blue: 0.0) : // Make this gold
                    Color(.black)
                )
                .cornerRadius(UIScreen.main.bounds.width * 0.02)
                .padding()
            Text(user.username)
                .font(.caption2)
                .offset(x:UIScreen.main.bounds.width * -0.05)
            Text("\(user.wins)")
                .font(.caption2)
                .offset(x:UIScreen.main.bounds.width * -0.08)
            Text("\(user.losses)")
                .font(.caption2)
                .offset(x:UIScreen.main.bounds.width * -0.06)
            Text("\(user.win_percentage)%")
                .font(.caption2)
                .offset(x:UIScreen.main.bounds.width * -0.05)
            Text("\(user.total_games)")
                .font(.caption2)
                .offset(x:UIScreen.main.bounds.width * -0.03)
        }
        .frame(width: UIScreen.main.bounds.width * 1.1, height: UIScreen.main.bounds.height * 0.03)
//        .background(Color(.gray))
        .offset(x: UIScreen.main.bounds.width * -0.15)
    }
}
