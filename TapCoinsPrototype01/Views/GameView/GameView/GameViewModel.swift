//
//  GameViewModel.swift
//  TapCoinsPrototype01
//
//  Created by Eric Viera on 2/18/24.
//

import Foundation
import SwiftUI
import zlib
import SocketIO

final class GameViewModel: ObservableObject {
    @AppStorage("session") var logged_in_user: String?
    @AppStorage("Player1") var first_player: String?
    @AppStorage("Player2") var second_player: String?
    @AppStorage("gameId") var game_id: String?
    @AppStorage("from_queue") var from_queue: Bool?
    @AppStorage("custom_game") var custom_game: Bool?
    @AppStorage("is_first") var is_first: Bool?
    @AppStorage("in_game") var in_game: Bool?
    @AppStorage("in_queue") var in_queue: Bool?
    @AppStorage("user") private var userViewModel: Data?
    @AppStorage("debug") private var debug: Bool?
    @AppStorage("from_gq") private var from_gq: Bool?
    @Published var userModel: UserViewModel = UserViewModel(first_name: "NO FIRST NAME", last_name: "NO LAST NAME")
    var newCustomColorsModel = CustomColorsModel()
    @Published var coins = [true, false, true, false, true, false, true, false, true, false]
    @Published var coin_values = [
        "00":"Custom_Color_1_TC",
        "10":"Custom_Color_1_TC",
        "20":"Custom_Color_1_TC",
        "30":"Custom_Color_1_TC",
        "01":"Custom_Color_1_TC",
        "11":"Custom_Color_1_TC",
        "21":"Custom_Color_1_TC",
        "02":"Custom_Color_1_TC",
        "12":"Custom_Color_1_TC",
        "22":"Custom_Color_1_TC",
        "32":"Custom_Color_1_TC",
        "03":"Custom_Color_1_TC",
        "13":"Custom_Color_1_TC",
        "23":"Custom_Color_1_TC",
        "04":"Custom_Color_1_TC",
        "14":"Custom_Color_1_TC",
        "24":"Custom_Color_1_TC",
        "34":"Custom_Color_1_TC",
        "05":"Custom_Color_1_TC",
        "15":"Custom_Color_1_TC",
        "25":"Custom_Color_1_TC",
        "06":"Custom_Color_1_TC",
        "16":"Custom_Color_1_TC",
        "26":"Custom_Color_1_TC",
        "36":"Custom_Color_1_TC",
        "07":"Custom_Color_1_TC",
        "17":"Custom_Color_1_TC",
        "27":"Custom_Color_1_TC",
        "08":"Custom_Color_1_TC",
        "18":"Custom_Color_1_TC",
        "28":"Custom_Color_1_TC",
        "38":"Custom_Color_1_TC",
        "09":"Custom_Color_1_TC",
        "19":"Custom_Color_1_TC",
        "29":"Custom_Color_1_TC",
    ]
    @Published var first:String = ""
    @Published var second:String = ""
    @Published var fPoints:Int = 0
    @Published var sPoints:Int = 0
    @Published var paVotes:Int = 0
    @Published var count:Int = 10
    @Published var gameId:String = ""
    @Published var gameStart:String = "Ready"
    @Published var winner = ""
    @Published var waitingStatus = "Waiting on opponent ..."
    @Published var disconnectMessage = "Opponent Disconnected"
    @Published var startGame:Bool = false
    @Published var endGame:Bool = false
    @Published var cancelled:Bool = false
    @Published var ready:Bool = false
    @Published var paPressed:Bool = false
    @Published var currPaPressed:Bool = false
    @Published var opp_disconnected:Bool = false
    @Published var is_a_tie:Bool = false
    @Published var ready_uped:Bool = false
    @Published var smaller_screen:Bool = false
    @Published var fColor:Color = CustomColorsModel().colorSchemeFour
    @Published var sColor:Color = CustomColorsModel().colorSchemeFour
    private enum coin_val:String {
        case Yellow = "Custom_Color_1_TC"
        case Blue = "Custom_Color_3_TC"
        case Red = "Custom_Color_2_TC"
    }
    private var mSocket = GameHandler.sharedInstance.getSocket()
    private var customMSocket = CustomGameHandler.sharedInstance.getSocket()
    private var connected:Bool = false
    private var startingGame:Bool = false
    private var curr_username = ""
    private var oppLeft:Bool = false
    private var time_is_up = false
    private var got_in_send_points: Bool = false
    private var send_points_count:Int = 0
    
    init(){
        let convertedData = UserViewModel(self.userViewModel ?? Data())
        self.userModel = convertedData ?? UserViewModel(first_name: "NO FIRST NAME", last_name: "NO LAST NAME")
        self.curr_username = userModel.username ?? "NO USERNAME"
        if (from_queue ?? true){
            GameHandler.sharedInstance.establishConnection()
            from_gq = true
            first = first_player ?? "No First"
            second = second_player ?? "No Second"
            gameId = game_id ?? "No Game Id"
            mSocket.on("statusChange") {(dataArr, ack) -> Void in
                if self.connected == false{
                    if dataArr.count == 2{
                        let eventName = dataArr[0]
                        if eventName as! SocketIOStatus == SocketIOStatus.connected{
                            self.connected = true
                            if (self.gameId != "No Game Id"){
                                var gClient_data = ""
                                if (self.is_first ?? false){
                                    gClient_data = self.gameId + "|" + self.first + "|1"
                                }
                                else{
                                    gClient_data = self.gameId + "|" + self.second + "|2"
                                }
                                self.mSocket.emit("game_id", gClient_data)
                            }
                        }
                    }
                }
            }
            mSocket.on("GAMEID") {(dataArr, ack) -> Void in
                let game_id_response = dataArr[0] as! String
                if (game_id_response == "SUCCESS"){
                    self.cancelled = true
                    self.second = self.second_player ?? "No Second"
                    self.waitingStatus = "Opponent connected"
                }
                else{
                    self.second = "Waiting"
                    self.waitingStatus = "Waiting on opponent ..."
                }
            }
            mSocket.on("TAP") {(dataArr, ack) -> Void in
                let tap_data = dataArr[0] as! String
                let tap_data_split = tap_data.split(separator: "|")
                let x_index = tap_data_split[0]
                let y_index = tap_data_split[1]
                let coin_v_index = x_index + y_index
                if (self.curr_username == self.first){
                    self.coin_values[String(coin_v_index)] = GameViewModel.coin_val.Red.rawValue
                    self.sPoints = self.sPoints + 1
                    let sum = self.fPoints + self.sPoints
                    if (sum == 35){
                        if (self.fPoints > self.sPoints){
                            self.endGame = true
                            self.winner = self.first
                            self.send_points(location:"MSOCKET_TAP_F_G_S_FIRST_IF")
                        }
                        else{
                            self.endGame = true
                            self.winner = self.second
                            self.send_points(location:"MSOCKET_TAP_S_G_F_FIRST_IF")
                        }
                    }
                }
                else{
                    self.coin_values[String(coin_v_index)] = GameViewModel.coin_val.Blue.rawValue
                    self.fPoints = self.fPoints + 1
                    let sum = self.fPoints + self.sPoints
                    if (sum == 35){
                        if (self.fPoints > self.sPoints){
                            self.endGame = true
                            self.winner = self.first
                            self.send_points(location:"MSOCKET_TAP_F_G_S_SECOND_IF")
                        }
                        else{
                            self.endGame = true
                            self.winner = self.second
                            self.send_points(location:"MSOCKET_TAP_S_G_F_SECOND_IF")
                        }
                    }
                }
            }
            mSocket.on("REMOVEDUSER") {(dataArr, ack) -> Void in
                let value = dataArr[0] as! String
                if value == "NEXT"{
                    GameHandler.sharedInstance.closeConnection()
                    self.in_queue = true
                    self.in_game = false
                }
                else if value == "HOME"{
                    GameHandler.sharedInstance.closeConnection()
                    self.in_game = false
                }
                else if value == "EXIT"{
                    GameHandler.sharedInstance.closeConnection()
                    self.in_game = false
                }
            }
            
            mSocket.on("READY") {(dataArr, ack) -> Void in
                let response = dataArr[0] as! String
                let user1_status = response.split(separator: "|")[0]
                let user2_status = response.split(separator: "|")[1]
                let ready_username = response.split(separator: "|")[2]
                if user1_status == "True"{
                    if String(ready_username) == self.first_player ?? "None"{
                        self.fColor = CustomColorsModel().colorSchemeSix
                    }
                    else if String(ready_username) == self.second_player ?? "None"{
                        self.sColor = CustomColorsModel().colorSchemeSix
                    }
                    if user2_status == "True"{
                        self.start_game()
                    }
                }
                else{
                    if user2_status == "True"{
                        if String(ready_username) == self.second_player ?? "None"{
                            self.sColor = Color(.green)
                        }
                    }
                }
            }
            
            mSocket.on("CANCELLED") {(dataArr, ack) -> Void in
                self.waitingStatus = "Opponent cancelled"
            }
            
            mSocket.on("STARTCGAME") {(dataArr, ack) -> Void in
                self.ready_uped = true
                self.count_down()
            }
            
            mSocket.on("DISCONNECT") {(dataArr, ack) -> Void in
                self.disconnected()
            }
        } //from queue
        else{
            if custom_game ?? true{
                CustomGameHandler.sharedInstance.establishConnection()
                first = first_player ?? "No First"
                second = second_player ?? "No Second"
                gameId = game_id ?? "No Game Id"
                customMSocket.on("statusChange") {(dataArr, ack) -> Void in
                    if self.connected == false{
                        if dataArr.count == 2{
                            let eventName = dataArr[0]
                            if eventName as! SocketIOStatus == SocketIOStatus.connected{
                                self.connected = true
                                if (self.gameId != "No Game Id"){
                                    var gClient_data = ""
                                    if (self.is_first ?? false){
                                        gClient_data = self.gameId + "|" + self.first + "|1"
                                    }
                                    else{
                                        gClient_data = self.gameId + "|" + self.second + "|2"
                                    }
                                    self.customMSocket.emit("game_id", gClient_data)
                                }
                            }
                        }
                    }
                }
                customMSocket.on("GAMEID") {(dataArr, ack) -> Void in
                    let game_id_response = dataArr[0] as! String
                    if (game_id_response == "SUCCESS"){
                        self.cancelled = true
                        self.second = self.second_player ?? "No Second"
                        self.waitingStatus = "Opponent connected"
                    }
                    else{
                        self.second = "Waiting"
                        self.waitingStatus = "Waiting on opponent ..."
                    }
                } // GAMEID Handler

                customMSocket.on("DECLINED") {(dataArr, ack) -> Void in
                    self.waitingStatus = "Opponent declined"
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        self.cancel_game(cancelled: true)
                    }
                }

                customMSocket.on("READY") {(dataArr, ack) -> Void in
                    let response = dataArr[0] as! String
                    let user1_status = response.split(separator: "|")[0]
                    let user2_status = response.split(separator: "|")[1]
                    let ready_username = response.split(separator: "|")[2]
                    if user1_status == "True"{
                        if String(ready_username) == self.first_player ?? "None"{
                            self.fColor = CustomColorsModel().colorSchemeSix
                        }
                        else if String(ready_username) == self.second_player ?? "None"{
                            self.sColor = CustomColorsModel().colorSchemeSix
                        }
                        if user2_status == "True"{
                            self.start_game()
                        }
                    }
                    else{
                        if user2_status == "True"{
                            if String(ready_username) == self.second_player ?? "None"{
                                self.sColor = Color(.green)
                            }
                        }
                    }
                }

                customMSocket.on("STARTCGAME") {(dataArr, ack) -> Void in
                    self.ready_uped = true
                    self.count_down()
                }

                customMSocket.on("TAP") {(dataArr, ack) -> Void in
                    let tap_data = dataArr[0] as! String
                    let tap_data_split = tap_data.split(separator: "|")
                    let x_index = tap_data_split[0]
                    let y_index = tap_data_split[1]
                    let coin_v_index = x_index + y_index
                    if (self.curr_username == self.first){
                        self.coin_values[String(coin_v_index)] = GameViewModel.coin_val.Red.rawValue
                        self.sPoints = self.sPoints + 1
                        let sum = self.fPoints + self.sPoints
                        if (sum == 35){
                            if (self.fPoints > self.sPoints){
                                self.endGame = true
                                self.winner = self.first
                            }
                            else{
                                self.endGame = true
                                self.winner = self.second
                            }
                        }
                    }
                    else{
                        self.coin_values[String(coin_v_index)] = GameViewModel.coin_val.Blue.rawValue
                        self.fPoints = self.fPoints + 1
                        let sum = self.fPoints + self.sPoints
                        if (sum == 35){
                            if (self.fPoints > self.sPoints){
                                self.endGame = true
                                self.winner = self.first
                            }
                            else{
                                self.endGame = true
                                self.winner = self.second
                            }
                        }
                    }
                }
                customMSocket.on("PLAYAGAIN") {(dataArr, ack) -> Void in
                    let data = dataArr[0] as! String
                    self.paVotes += 1
                    if self.paVotes == 2{
                        var dict = [String:String]()
                        for (key,_) in self.coin_values{
                            dict[key] = "Custom_Color_1_TC"
                        }
                        self.coin_values = dict
                        self.gameStart = "READY"
                        self.startGame = false
                        self.fPoints = 0
                        self.sPoints = 0
                        self.endGame = false
                        self.paVotes = 0
                        self.count = 10
                        self.paPressed = false
                        self.currPaPressed = false
                        self.time_is_up = false
                        self.count_down()
                    }
                    else{
                        if data == self.curr_username{
                            self.waitingStatus = "Waiting on opponent ..."
                            self.paPressed = true
                            self.currPaPressed = true
                        }
                        else{
                            self.waitingStatus = data + " voted play again"
                            self.paPressed = true
                        }
                    }
                }

                customMSocket.on("OPPLEFT") {(dataArr, ack) -> Void in
                    let data = dataArr[0] as! String
                    self.oppLeft = true
                    self.paPressed = true
                    self.currPaPressed = true
                    self.waitingStatus = data + " has left"
                }

                customMSocket.on("CANCELLED") {(dataArr, ack) -> Void in
                    self.waitingStatus = "Opponent disconnected"
                    self.paPressed = true
                    self.currPaPressed = true
                }
                customMSocket.on("REMOVEDUSER") {(dataArr, ack) -> Void in
                    let value = dataArr[0] as! String
                    if value == "HOME"{
                        CustomGameHandler.sharedInstance.closeConnection()
                        self.in_game = false
                    }
                    else if value == "EXIT"{
                        CustomGameHandler.sharedInstance.closeConnection()
                        self.in_game = false
                    }
                }

                customMSocket.on("DISCONNECT") {(dataArr, ack) -> Void in
                    self.disconnected()
                }
            }
        }
    }
    deinit {
        GameHandler.sharedInstance.closeConnection()
        CustomGameHandler.sharedInstance.closeConnection()
        in_game = false
    }
    
    func start_game(){
        if (self.custom_game ?? false){
            customMSocket.emit("start_game", game_id ?? "No ID")
        }
        else{
            mSocket.emit("start_game", game_id ?? "No ID")
        }
    }
    
    func count_down(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.gameStart = "SET"
            self.count_start()
        }
    }
    
    func count_start(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.gameStart = "START"
            self.startGame = true
        }
    }
    
    func ready_up(username:String){
        if (self.custom_game ?? false){
            customMSocket.emit("ready", username + "|" + (game_id ?? "NO ID"))
        }
        else{
            mSocket.emit("ready", username + "|" + (game_id ?? "NO ID"))
        }
        ready = true
        if username == first_player{
            self.fColor = CustomColorsModel().colorSchemeSix
        }
        else if username == second_player{
            self.sColor = CustomColorsModel().colorSchemeSix
        }
    }
    
    func sendTap(x:Int, y:Int){
        let x_index = String(x)
        let y_index = String(y)
        let coin_v_index = x_index + y_index
        let index_str = String(x) + "|" + String(y) + "*" + gameId
        if (self.custom_game ?? false){
            customMSocket.emit("tap", index_str)
        }
        else{
            mSocket.emit("tap", index_str)
        }
        if (curr_username == first){
            coin_values[String(coin_v_index)] = GameViewModel.coin_val.Blue.rawValue
            fPoints = fPoints + 1
            let sum = fPoints + sPoints
            if (sum == 35){
                if (fPoints > sPoints){
                    endGame = true
                    winner = first
                    send_points(location:"SENDTAP_F_G_S_FIRST_IF")
                }
                else{
                    endGame = true
                    winner = second
                    send_points(location:"SENDTAP_S_G_F_FIRST_IF")
                }
            }
        }
        else{
            coin_values[String(coin_v_index)] = GameViewModel.coin_val.Red.rawValue
            sPoints = sPoints + 1
            let sum = fPoints + sPoints
            if (sum == 35){
                if (fPoints > sPoints){
                    endGame = true
                    winner = first
                    send_points(location:"SENDTAP_F_G_S_SECOND_IF")
                }
                else{
                    endGame = true
                    winner = second
                    send_points(location:"SENDTAP_S_G_F_SECOND_IF")
                }
            }
        }
    }
    
    func send_points(location:String){
        gameStart = "END"
        if self.got_in_send_points{
            return
        }
        self.got_in_send_points = true
        self.send_points_count = self.send_points_count + 1
        var url_string:String = ""
        
        if debug ?? true{
            print("DEBUG IS TRUE")
            url_string = "http://127.0.0.1:8000/tapcoinsapi/game/sendPoints"
        }
        else{
            print("DEBUG IS FALSE")
            url_string = "https://tapcoin1.herokuapp.com/tapcoinsapi/game/sendPoints"
        }
        
        guard let url = URL(string: url_string) else{
            return
        }
        var request = URLRequest(url: url)
        var _type:String = ""
        var is_winner:Bool = false
        
        if curr_username == winner{
            is_winner = true
        }
        
        if custom_game ?? false{
            _type = "Custom"
        }
        else{
            _type = "Real"
        }
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: AnyHashable] = [
            "fPoints": fPoints,
            "sPoints": sPoints,
            "gameId": gameId,
            "type": _type,
            "winner": is_winner,
            "location": location,
            "count": self.send_points_count
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        let task = URLSession.shared.dataTask(with: request, completionHandler: {[weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            DispatchQueue.main.async {
                do {
                    let response = try JSONDecoder().decode(GameOver.self, from: data)
                    if response.gameOver == true{
                        self?.ready = false
                        CustomGameHandler.sharedInstance.closeConnection()
                    }
                }
                catch{
                    print(error)
                }
            }
        })
        task.resume()
    }
    
    func cancel_game(cancelled:Bool){
        
        var url_string:String = ""
        
        if debug ?? true{
            print("DEBUG IS TRUE")
            url_string = "http://127.0.0.1:8000/tapcoinsapi/friend/ad_invite"
        }
        else{
            print("DEBUG IS FALSE")
            url_string = "https://tapcoin1.herokuapp.com/tapcoinsapi/friend/ad_invite"
        }
        
        guard let url = URL(string: url_string) else{
            return
        }
        var request = URLRequest(url: url)
        guard let session = logged_in_user else{
            return
        }
        
        if waitingStatus == "Opponent connected"{
            if (self.custom_game ?? false){
                customMSocket.emit("cancelled", curr_username + "|" + (game_id ?? "NO ID"))
            }
            else{
                mSocket.emit("cancelled", curr_username + "|" + (game_id ?? "NO ID"))
            }
        }
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: AnyHashable] = [
            "username": self.second_player ?? "No Second",
            "token": session,
            "adRequest": "delete",
            "cancelled":cancelled
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        let task = URLSession.shared.dataTask(with: request, completionHandler: {[weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            DispatchQueue.main.async {
                do {
                    let response = try JSONDecoder().decode(ADRequest.self, from: data)
                    if response.result == "Cancelled"{
                        self?.from_queue = false
                        self?.custom_game = false
                        self?.is_first = false
                        GameHandler.sharedInstance.closeConnection()
                        CustomGameHandler.sharedInstance.closeConnection()
                        self?.in_game = false
                    }
                }
                catch{
                    print(error)
                }
            }
        })
        task.resume()
    }

    func play_again(){
        if (self.custom_game ?? false){
            self.customMSocket.emit("play_again", curr_username + "|" + (game_id ?? "NO ID"))
        }
        else{
            self.mSocket.emit("play_again", curr_username + "|" + (game_id ?? "NO ID"))
        }
        paPressed = true
        currPaPressed = true
    }
    
    func return_home(exit:Bool){
        if custom_game ?? false{
            if !oppLeft{
                oppLeft = true
                customMSocket.emit("opponent_left", curr_username + "|" + (game_id ?? "NO ID"))
                customMSocket.emit("remove_game_client", "HOME|" + (game_id ?? "NO ID"))
            }
            else{
                customMSocket.emit("remove_game_client", "HOME|" + (game_id ?? "NO ID"))
            }
        }
        else{
            if exit{
                mSocket.emit("remove_game_client", "EXIT|" + (game_id ?? "NO ID"))
            }
            else{
                mSocket.emit("remove_game_client", "HOME|" + (game_id ?? "NO ID"))
            }
        }
    }
    
    func next_game(){
        if (self.custom_game ?? false){
            customMSocket.emit("remove_game_client", "NEXT|" + (game_id ?? "NO ID"))
        }
        else{
            mSocket.emit("remove_game_client", "NEXT|" + (game_id ?? "NO ID"))
        }
    }
    
    func disconnected(){
        opp_disconnected = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.return_home(exit: false)
        }
    }
    
    func times_up(){
        if time_is_up == false{
            time_is_up = true
            if fPoints > sPoints{
                winner = first
            }
            else if sPoints > fPoints{
                winner = second
            }
            else{
                is_a_tie = true
                winner = "Nobody"
            }
            endGame = true
            send_points(location: "TIMESUP")
        }
    }
    
    struct Response:Codable {
        let first_name: String
        let last_name: String
        let response: String
        let username: String
    }
    struct GameOver:Codable {
        let gameOver: Bool
    }
    struct ADRequest:Codable {
        let result: String
    }
    struct ISRequest:Codable {
        let status: String
    }

}
