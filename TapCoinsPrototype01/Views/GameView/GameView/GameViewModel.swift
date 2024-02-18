//
//  GameViewModel.swift
//  TapCoinsPrototype01
//
//  Created by Eric Viera on 2/18/24.
//

import Foundation
import SwiftUI
import zlib

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
        print("USER MODEL IS BELOW")
        print(convertedData?.username)
        self.userModel = convertedData ?? UserViewModel(first_name: "NO FIRST NAME", last_name: "NO LAST NAME")
        self.curr_username = userModel.username ?? "NO USERNAME"
        print("FIRST PLAYER BELOW")
        print(first_player)
        print("SECOND PLAYER BELOW")
        print(second_player)
        print("CURRENT USER NAME BELOW")
        print(self.curr_username)
        if (from_queue ?? true){
            print("IS NOT FROM CUSTOM GAME IN GAME VIEW")
            GameHandler.sharedInstance.establishConnection()
            first = first_player ?? "No First"
            second = second_player ?? "No Second"
            gameId = game_id ?? "No Game Id"
            mSocket.on("connected") {(dataArr, ack) -> Void in
                let is_connected = dataArr[0] as! String
                if (is_connected == "CONNECTED"){
                    print("THIS USER IS CONNECTED: ", self.curr_username)
                    if (self.connected == false){
                        if (self.gameId != "No Game Id"){
                            var gClient_data = ""
                            if (self.is_first ?? false){
                                gClient_data = self.gameId + "|" + self.first + "|1"
                            }
                            else{
                                gClient_data = self.gameId + "|" + self.second + "|2"
                            }
                            self.mSocket.emit("GAMEID", gClient_data)
                            self.connected = true
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
                    print("RECEIVING TAP AS THE FIRST PLAYER")
                    print(self.curr_username)
                    print(self.first)
                    print(self.second)
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
                    print("RECEIVING TAP AS THE SECOND PLAYER")
                    print(self.curr_username)
                    print(self.second)
                    print(self.first)
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
                if user1_status == "true"{
                    if String(ready_username) == self.first_player ?? "None"{
                        self.fColor = CustomColorsModel().colorSchemeSix
                    }
                    else if String(ready_username) == self.second_player ?? "None"{
                        self.sColor = CustomColorsModel().colorSchemeSix
                    }
                    if user2_status == "true"{
                        self.start_game()
                    }
                }
                else{
                    if user2_status == "true"{
                        if String(ready_username) == self.second_player ?? "None"{
                            self.sColor = Color(.green)
                        }
                    }
                }
            }
            
            mSocket.on("CANCELLED") {(dataArr, ack) -> Void in
                self.waitingStatus = "Opponent disconnected"
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
                        print("IS CUSTOM GAME IN GAME VIEW")
                        // Change this to custom game handler
                        CustomGameHandler.sharedInstance.establishConnection()
                        first = first_player ?? "No First"
                        gameId = game_id ?? "No Game Id"
                        customMSocket.on("connected") {(dataArr, ack) -> Void in
                            let is_connected = dataArr[0] as! String
                            if (is_connected == "CONNECTED"){
                                print("GOT CONNECTED FROMMGAME SERVER")
                                if (self.connected == false){
                                    print("SELF CONNECTED IS FALSE")
                                    if (self.gameId != "No Game Id"){
                                        print("HAS THE GAMEID")
                                        var gClient_data = ""
                                        if (self.is_first ?? false){
                                            gClient_data = self.gameId + "|" + (self.first_player ?? "Nothing") + "|1"
                                        }
                                        else{
                                            gClient_data = self.gameId + "|" + (self.second_player ?? "Nothing") + "|2"
                                        }
                                        print("EMITTING TO THE GAME SERVER")
                                        self.customMSocket.emit("GAMEID", gClient_data)
                                        self.connected = true
                                    }
                                }
                            }
                        }
                        customMSocket.on("GAMEID") {(dataArr, ack) -> Void in
                            let game_id_response = dataArr[0] as! String
                            if (game_id_response == "SUCCESS"){
                                print("GAMEID IS A SUCCESS")
                                self.cancelled = true
                                self.second = self.second_player ?? "No Second"
                                self.waitingStatus = "Opponent connected"
                            }
                            else{
                                print("WAITING ON OPPONENT")
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
                            if user1_status == "true"{
                                if String(ready_username) == self.first_player ?? "None"{
                                    self.fColor = CustomColorsModel().colorSchemeSix
                                }
                                else if String(ready_username) == self.second_player ?? "None"{
                                    self.sColor = CustomColorsModel().colorSchemeSix
                                }
                                if user2_status == "true"{
                                    self.start_game()
                                }
                            }
                            else{
                                if user2_status == "true"{
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
        
                        // Look into this for both custom game and regular game
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
//        if UIScreen.main.bounds.height < 750.0{
//            smaller_screen = true
//        }

//    } //init
//
    deinit {
        GameHandler.sharedInstance.closeConnection()
        CustomGameHandler.sharedInstance.closeConnection()
        in_game = false
    }
//
    func start_game(){
        if (self.custom_game ?? false){
            customMSocket.emit("STARTCGAME", game_id ?? "No ID")
        }
        else{
            mSocket.emit("STARTCGAME", game_id ?? "No ID")
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
            customMSocket.emit("READY", username + "|" + (game_id ?? "NO ID"))
        }
        else{
            mSocket.emit("READY", username + "|" + (game_id ?? "NO ID"))
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
            customMSocket.emit("TAP", index_str)
        }
        else{
            mSocket.emit("TAP", index_str)
        }
        if (curr_username == first){
            print("IS THE FIRST PLAYER TAPPING FOR THEMSELVES")
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
            print("IS THE SECOND PLAYER TAPPING FOR THEMSELVES")
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
            print("RETURNING OUT OF SEND POINTS")
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
            url_string = "https://tapcoin1.herokuapp.com/tapcoinsapi/game/sendPoints"
        }
        
        guard let url = URL(string: url_string) else{
            return
        }
        var request = URLRequest(url: url)
        //        if let environment = ProcessInfo.processInfo.environment["login"], let url = URL(string: environment){
        
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
            url_string = "https://tapcoin1.herokuapp.com/tapcoinsapi/friend/ad_invite"
        }
        
        guard let url = URL(string: url_string) else{
            return
        }
        var request = URLRequest(url: url)
        //        if let environment = ProcessInfo.processInfo.environment["login"], let url = URL(string: environment){
        
        guard let session = logged_in_user else{
            return
        }
        
        if waitingStatus == "Opponent connected"{
            if (self.custom_game ?? false){
                customMSocket.emit("CANCELLED", curr_username + "|" + (game_id ?? "NO ID"))
            }
            else{
                mSocket.emit("CANCELLED", curr_username + "|" + (game_id ?? "NO ID"))
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
            self.customMSocket.emit("PLAYAGAIN", curr_username + "|" + (game_id ?? "NO ID"))
        }
        else{
            self.mSocket.emit("PLAYAGAIN", curr_username + "|" + (game_id ?? "NO ID"))
        }
        paPressed = true
        currPaPressed = true
    }
    
    func return_home(exit:Bool){
        if custom_game ?? false{
            if !oppLeft{
                oppLeft = true
                customMSocket.emit("OPPLEFT", curr_username + "|" + (game_id ?? "NO ID"))
                customMSocket.emit("REMOVEGAMECLIENT", "HOME|" + (game_id ?? "NO ID"))
            }
            else{
                customMSocket.emit("REMOVEGAMECLIENT", "HOME|" + (game_id ?? "NO ID"))
            }
        }
        else{
            if exit{
                mSocket.emit("REMOVEGAMECLIENT", "EXIT|" + (game_id ?? "NO ID"))
            }
            else{
                mSocket.emit("REMOVEGAMECLIENT", "HOME|" + (game_id ?? "NO ID"))
            }
        }
    }
    
    func next_game(){
        if (self.custom_game ?? false){
            customMSocket.emit("REMOVEGAMECLIENT", "NEXT|" + (game_id ?? "NO ID"))
        }
        else{
            mSocket.emit("REMOVEGAMECLIENT", "NEXT|" + (game_id ?? "NO ID"))
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
