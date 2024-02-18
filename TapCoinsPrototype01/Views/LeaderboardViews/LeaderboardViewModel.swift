//
//  LeaderboardViewModel.swift
//  TapCoinsPrototype01
//
//  Created by Eric Viera on 2/18/24.
//

import Foundation
import SwiftUI

final class LeaderboardViewModel: ObservableObject {
    @AppStorage("debug") private var debug: Bool?
     let data = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5"]
   
    @Published var users_list:[TableUserModel] = []
    @Published var loaded_users:Bool = false
    @Published var first_user:String = ""
    
//    @Published private var sorted_list:[TableUserModel]
    
    init(){
        get_leaderboard_data()
//        users_list = [
//            TableUserModel(username: "Username1", wins: 10, losses: 10, win_percentage: 50, total_games: 20),
//            TableUserModel(username: "Username2", wins: 10, losses: 10, win_percentage: 50, total_games: 20),
//            TableUserModel(username: "Username3", wins: 10, losses: 10, win_percentage: 50, total_games: 20),
//            TableUserModel(username: "Username4", wins: 10, losses: 10, win_percentage: 50, total_games: 20),
//            TableUserModel(username: "Username5", wins: 10, losses: 10, win_percentage: 50, total_games: 20),
//        ]
        users_list.sorted(using: KeyPathComparator(\.username))
    }
    
    func get_leaderboard_data(){
        var url_string:String = ""
        
        if debug ?? true{
            print("DEBUG IS TRUE")
            url_string = "http://127.0.0.1:8000/tapcoinsapi/user/get_leaderboard_data"
        }
        else{
            url_string = "https://tapcoin1.herokuapp.com/tapcoinsapi/user/get_leaderboard_data"
        }
        
        guard let url = URL(string: url_string) else{
            return
        }
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request, completionHandler: {[weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            print("DATA BELOW")
            print(data)
            DispatchQueue.main.async {
                do {
                    print("IN THE DO")
                    let response = try JSONDecoder().decode(LeaderboardData.self, from: data)
                    print("&&&&&&&&&&&&&&")
                    print("&&&&&&&&&&&&&&")
                    print("&&&&&&&&&&&&&&")
                    print("&&&&&&&&&&&&&&")
                    print("&&&&&&&&&&&&&&")
                    print("RESPONSE BELOW")
                    print("&&&&&&&&&&&&&&")
                    print("&&&&&&&&&&&&&&")
                    print("&&&&&&&&&&&&&&")
                    print("&&&&&&&&&&&&&&")
                    print("&&&&&&&&&&&&&&")
                    print(response)
                    var count = 0
                    if response.result == "Success"{
                        for user in response.all_users{
                            if count == 0{
                                self?.first_user = user.username ?? ""
                                count += 1
                            }
                            let new_user:TableUserModel = TableUserModel(username: user.username ?? "nil", wins: user.wins ?? 0, losses: user.losses ?? 0, win_percentage: user.win_percentage ?? 0, total_games: user.total_games ?? 0, league: user.league ?? 9)
                            self?.users_list.append(new_user)
                        }
                    }
                    print("GOT THE USERS LIST")
                    self?.loaded_users = true
                }
                catch{
                    print(error)
                }
            }
        })
        task.resume()
    }
    
    struct LeaderboardData:Codable {
        let result:String
        let all_users:[TableUserModelCodable]
    }
}
