//
//  FriendsViewModel.swift
//  TapCoinsPrototype01
//
//  Created by Eric Viera on 2/18/24.
//

import Foundation
import SwiftUI
//import CloudKit
final class FriendsViewModel: ObservableObject {
    @AppStorage("session") var logged_in_user: String?
    @AppStorage("Player1") var first_player: String?
    @AppStorage("Player2") var second_player: String?
    @AppStorage("gameId") var game_id: String?
    @AppStorage("from_queue") var from_queue: Bool?
    @AppStorage("custom_game") var custom_game: Bool?
    @AppStorage("is_first") var is_first: Bool?
    @AppStorage("in_game") var in_game: Bool?
    @AppStorage("user") private var userViewModel: Data?
    @AppStorage("debug") private var debug: Bool?
    @AppStorage("num_friends") public var num_friends:Int?
    @Published var userModel:UserViewModel?
    @Published var show_friend_request_actions_bool:Bool = false
    @Published var friend_requester_name:String = ""
    @Published var show_friend_actions_bool:Bool = false
    @Published var friend_name:String = ""
    @Published var active_friends_index_list:[Int] = []
    @Published var pressed_decline_request:Bool = false
    @Published var pressed_accept_request:Bool = false
    @Published var pressed_accept_invite:Bool = false
    @Published var pressed_decline_invite:Bool = false
    @Published var pressed_remove_friend:Bool = false
    @Published var pressed_send_invite:Bool = false
//    private var mSocket = CustomGameHandler.sharedInstance.getSocket()
    private var first_time:Bool = true
    private var globalFunctions = GlobalFunctions()
    @Published var friends_indexes:[Int:Bool] = [:]
    
    init(){
        print("IN THE FRIENDS VIEW INIT")
//        self.call_get_user()
        self.userModel = UserViewModel(self.userViewModel ?? Data())
//        self.friend_logic()
//        CustomGameHandler.sharedInstance.establishConnection()
//        print("ESTABLISHED CONNECTION")
        set_friend_indexes()
        print("FRIENDS LIST BELOW")
        print(userModel?.friends)
    }
    
    func set_friend_indexes(){
        var index = 0
        friends_indexes = [:]
        for friend in self.userModel?.friends ?? ["NO FRIENDS"] {
            if friend == "NO FRIENDS"{
                print("HAS NO FRIENDS")
                return
            }
            print(friend)
            print(index)
            friends_indexes[index] = false
            index += 1
        }
        print("FRIEND INDEXES BELOW")
        print(friends_indexes)
    }
    
    func friend_logic(){
        print("BEGINNING OF FRIENDS LOGIC")
        var tempUserModelData = UserViewModel(self.userViewModel ?? Data())
        if tempUserModelData?.friends?.count ?? 0 > 0{
            if tempUserModelData?.friends?[0] == "0"{
                tempUserModelData?.numFriends = 0
            }
            else{
                var count = 0
                for friend in tempUserModelData?.friends ?? ["NO FRIENDS"]{
                    if !friend.contains("requested|"){
                        tempUserModelData?.hasRQ = false
                        if !friend.contains("sentTo|"){
                            tempUserModelData?.hasST = false
                            if !friend.contains("Pending request to"){
                                count += 1
                                if tempUserModelData?.hasInvite ?? false{
                                    tempUserModelData?.hasGI = true
                                }
                            }
                        }
                        else{
                            tempUserModelData?.hasST = true
                        }
                    }
                    else{
                        tempUserModelData?.hasRQ = true
                    }
                }
                tempUserModelData?.numFriends = count
                let arrayCount = tempUserModelData?.friends?.count
                tempUserModelData?.fArrayCount = arrayCount
            }
            let newFriendsArray = self.sortFriends(user: tempUserModelData ?? UserViewModel(first_name: "NO FIRST NAME", last_name: "NO LAST NAME"))
            self.userModel?.friends = newFriendsArray
        }
        else{
            tempUserModelData?.numFriends = 0
            tempUserModelData?.fArrayCount = 0
        }
        print("END OF FRIENDS LOGIC")
    }
    
    func sortFriends(user: UserViewModel) -> Array<String>{
        var newFriends:Array<String> = []
        for friend in user.friends ?? ["NO FRIENDS"]{
            if friend.contains("sentTo|"){
                let fSplit = friend.split(separator: "|")
                let new_friend = "Pending request to " + fSplit[1]
                newFriends.append(new_friend)
            }
            else if friend.contains("requested|"){
                let fSplit = friend.split(separator: "|")
                let new_friend = "Friend request from " + fSplit[1]
                newFriends.append(new_friend)
            }
            else{
                if user.hasInvite ?? false{
                    let inv_friend = "Game Invite from " + friend
                    newFriends.append(inv_friend)
                }
                else{
                    newFriends.append(friend)
                }
            }
        }
        return newFriends
    }
    
    func decline_request(requestName:String){
        pressed_decline_request = true
        let rNameSplit = requestName.split(separator: " ")
        let rUsername = rNameSplit[3]
        print("FRIENDS LIST")
        print(self.userModel?.friends)
        print("REQUESTNAME BELOW")
        print(requestName)
        
        var url_string:String = ""
        
        if debug ?? true{
            print("DEBUG IS TRUE")
            url_string = "http://127.0.0.1:8000/tapcoinsapi/friend/dfr"
        }
        else{
            url_string = "https://tapcoin1.herokuapp.com/tapcoinsapi/friend/dfr"
        }
        
        guard let url = URL(string: url_string) else{
            return
        }
        var request = URLRequest(url: url)
        //        if let environment = ProcessInfo.processInfo.environment["login"], let url = URL(string: environment){
        
        guard let session = logged_in_user else{
            return
        }
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: AnyHashable] = [
            "username": rUsername,
            "token": session
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)

        let task = URLSession.shared.dataTask(with: request, completionHandler: {[weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }

            do {
                let response = try JSONDecoder().decode(DResponse.self, from: data)
                DispatchQueue.main.async {
                    if response.result == "Declined"{
                        var index = 0
                        for friend in self?.userModel?.friends ?? ["NO FRIENDS"]{
                            if friend.contains(requestName){
                                self?.userModel?.friends?.remove(at: index)
                                break
                            }
                            index += 1
                        }
                        self?.pressed_decline_request = false
                        // Adjust get user call here
//                        self?.call_get_user()
//                        self?.friend_logic()
                    }
                }
            }
            catch{
                print(error)
            }
        })
        task.resume()
    }
    
    struct DResponse:Codable {
        let result: String
    }
    
    func accept_request(requestName:String){
        pressed_accept_request = true
        let rNameSplit = requestName.split(separator: " ")
        let rUsername = rNameSplit[3]
        if self.num_friends == nil{
            self.num_friends = 1
        }
        else{
            self.num_friends! += 1
        }
        var url_string:String = ""
        
        if debug ?? true{
            print("DEBUG IS TRUE")
            url_string = "http://127.0.0.1:8000/tapcoinsapi/friend/afr"
        }
        else{
            url_string = "https://tapcoin1.herokuapp.com/tapcoinsapi/friend/afr"
        }
        
        guard let url = URL(string: url_string) else{
            return
        }
        var request = URLRequest(url: url)
        //        if let environment = ProcessInfo.processInfo.environment["login"], let url = URL(string: environment){
        
        guard let session = logged_in_user else{
            return
        }
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: AnyHashable] = [
            "username": rUsername,
            "token": session
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)

        let task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let response = try JSONDecoder().decode(AResponse.self, from: data)
                DispatchQueue.main.async {
                    if response.result == "Accepted"{
                        var index = 0
                        for friend in self?.userModel?.friends ?? ["NO FRIENDS"]{
                            if friend.contains(requestName){
                                self?.userModel?.friends?[index] = String(rUsername)
                                break
                            }
                            index += 1
                        }
                        self?.pressed_accept_request = false
                        // Adjust get user call here
//                        self?.call_get_user()
//                        self?.userViewModel = self?.userModel.storageValue
//                        self?.friend_logic()
                    }
                }
                
            }
            catch{
                print(error)
            }
        })
        task.resume()
    }
                            
    struct AResponse:Codable {
        let result: String
    }
    
//    struct FRModel:Hashable{
//        let sender:String
//        let receiver:String
//        let record:CKRecord
//    }
//    
//    func addOperation(operation:CKDatabaseOperation){
//        CKContainer(identifier: "iCloud.com.ericviera.TapTapCoin").publicCloudDatabase.add(operation)
//    }
    
    func removeFriend(requestName:String){
        pressed_remove_friend = true
        if self.num_friends == nil{
            self.num_friends = 0
        }
        else{
            self.num_friends! -= 1
        }
        
        var url_string:String = ""
        
        if debug ?? true{
            print("DEBUG IS TRUE")
            url_string = "http://127.0.0.1:8000/tapcoinsapi/friend/remove_friend"
        }
        else{
            url_string = "https://tapcoin1.herokuapp.com/tapcoinsapi/friend/remove_friend"
        }
        
        guard let url = URL(string: url_string) else{
            return
        }
        var request = URLRequest(url: url)
        //        if let environment = ProcessInfo.processInfo.environment["login"], let url = URL(string: environment){
        
        guard let session = logged_in_user else{
            return
        }
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: AnyHashable] = [
            "username": requestName,
            "token": session
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)

        let task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }

            do {
                let response = try JSONDecoder().decode(RResponse.self, from: data)
                if response.result == "Removed"{
                    DispatchQueue.main.async {
                        var ecount = 0;
                        var friendsList = self?.userModel?.friends ?? ["NO FRIENDS"]
                        if friendsList[0] != "NO FRIENDS"{
                            for friendIndex in friendsList.indices ?? 5..<7{
                                if ecount == 0 && friendIndex == 5{
                                    print("SOMETHING WENT WRONG WITH THE FRIEND INDICES")
                                    break
                                }
                                if friendsList[friendIndex] == requestName{
                                    self?.userModel?.friends?.remove(at: friendIndex)
                                }
                                ecount+=1
                            }
                            // Adjust get user call here
//                            self?.call_get_user()
//                            self?.friend_logic()
//                            // save data in appstorage
//                            self?.userViewModel = self?.userModel.storageValue
                        }
                        
                    }
                    self?.pressed_remove_friend = false
                }
            }
            catch{
                print(error)
            }
        })
        task.resume()
    }
    
    struct RResponse:Codable {
        let result: String
    }
    
    func sendInvite(inviteName:String){
        pressed_send_invite = true
        var url_string:String = ""
        
        if debug ?? true{
            print("DEBUG IS TRUE")
            url_string = "http://127.0.0.1:8000/tapcoinsapi/friend/send_invite"
        }
        else{
            url_string = "https://tapcoin1.herokuapp.com/tapcoinsapi/friend/send_invite"
        }
        
        guard let url = URL(string: url_string) else{
            return
        }
        var request = URLRequest(url: url)
        //        if let environment = ProcessInfo.processInfo.environment["login"], let url = URL(string: environment){
        
        guard let session = logged_in_user else{
            return
        }
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: AnyHashable] = [
            "username": inviteName,
            "token": session
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)

        let task = URLSession.shared.dataTask(with: request, completionHandler: {[weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let response = try JSONDecoder().decode(CGResponse.self, from: data)
                if response.first != "ALREADY EXISTS"{
//                    CustomGameHandler.sharedInstance.closeConnection()
                    DispatchQueue.main.async {
                        self?.first_player = response.first
                        self?.second_player = response.second
                        self?.game_id = response.gameId
                        self?.from_queue = false
                        self?.custom_game = true
                        self?.is_first = true
                        self?.in_game = true
                        self?.pressed_send_invite = false
//                        if self?.userModel.is_guest == false {
//                            self?.addFriendRequest()
//                        }
//                        else{
//                            print("NO ICLOUD STATUS IS A GUEST")
//                            self?.result = "IS A GUEST"
//                        }
//                        self?.addGameInvite(sender: response.first, receiver: response.second)
                    }
                }
            }
            catch{
                print(error)
            }
        })
        task.resume()
    }
    
    struct CGResponse:Codable {
        let first: String
        let second: String
        let gameId: String
    }
    
//    private func addGameInvite(sender:String, receiver:String){
//        let newGameInvite = CKRecord(recordType: "GameInvite")
//        newGameInvite["sender"] = sender
//        newGameInvite["receiver"] = receiver
//        saveGameInvite(record: newGameInvite)
//    }
//    
//    private func saveGameInvite(record:CKRecord){
//        CKContainer(identifier: "iCloud.com.ericviera.TapTapCoin").publicCloudDatabase.save(record) { [weak self] returnedRecord, returnedError in
//            print("RETURNED RECORD BELOW")
//            print(returnedRecord ?? "NOTHING HERE")
//            print("RETURNED ERROR BELOW")
//            print(returnedError ?? "NOTHING HERE")
//        }
//    }
    
    func declineInvite(inviteName:String){
        pressed_decline_invite = true
        let rNameSplit = inviteName.split(separator: " ")
        
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
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: AnyHashable] = [
            "username": rNameSplit[2],
            "token": session,
            "adRequest": "delete"
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)

        let task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }

            do {
                let response = try JSONDecoder().decode(DIResponse.self, from: data)
                if response.result == "Cancelled"{
                    DispatchQueue.main.async {
                        self?.pressed_decline_invite = false
//                        self?.mSocket.emit("DECLINED", response.gameId)
                        // Adjust get user call here
//                        self?.call_get_user()
                    }
                }
            }
            catch{
                print(error)
            }
        })
        task.resume()
    }
    
    struct DIResponse:Codable {
        let result: String
        let gameId: String
    }
    
    func acceptInvite(inviteName:String){
        pressed_accept_invite = true
        let rNameSplit = inviteName.split(separator: " ")
        
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
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: AnyHashable] = [
            "username": rNameSplit[3],
            "token": session,
            "adRequest": "accept"
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)

        let task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let response = try JSONDecoder().decode(AIResponse.self, from: data)
                if response.result == "Accepted"{
//                    CustomGameHandler.sharedInstance.closeConnection()
                    DispatchQueue.main.async {
                        var index = 0
                        for friend in self?.userModel?.friends ?? ["NO FRIENDS"]{
                            if friend.contains(inviteName){
                                self?.userModel?.friends?[index] = String(rNameSplit[3])
                                break
                            }
                            index += 1
                        }
                        self?.userViewModel = self?.userModel?.storageValue
                        self?.friend_logic() // Look into if this is working/ doing anything
                        self?.first_player = response.first
                        self?.second_player = response.second
                        self?.game_id = response.gameId
                        self?.from_queue = false
                        self?.is_first = false
                        self?.custom_game = true
                        self?.in_game = true
                        self?.pressed_accept_invite = false
                    }
                }
            }
            catch{
                print(error)
            }
        })
        task.resume()
    }
    
    struct AIResponse:Codable {
        let result: String
        let first: String
        let second: String
        let gameId: String
    }
    
//    struct GIModel:Hashable{
//        let sender:String
//        let receiver:String
//        let record:CKRecord
//    }
//    
//    func findGameInvite(giSender:String){
////        let predicate = NSPredicate(value: true)
//        let predicate = NSPredicate(format: "receiver = %@", argumentArray: [self.userModel?.username])
//        let query = CKQuery(recordType: "GameInvite", predicate: predicate)
//        let queryOperation = CKQueryOperation(query: query)
//        
//        var gameInvites: [GIModel] = []
//        
//        if #available(iOS 15.0, *){
//            queryOperation.recordMatchedBlock = { (returnedRecordID, returnedResult) in
//                switch returnedResult{
//                case .success(let record):
//                    //logic here
//                    let sender = record["sender"] as? String
//                    let receiver = record["receiver"] as? String
//                    gameInvites.append(GIModel(sender: sender ?? "Null", receiver: receiver ?? "Null", record: record))
//                    break
//                case .failure(let error):
//                    print("ERROR recordMatchBlock: \(error)")
//                }
//            }
//        }
//        else{
//            queryOperation.recordFetchedBlock = { (returnedRecord) in
//                //logic here
//                let sender = returnedRecord["sender"] as? String
//                let receiver = returnedRecord["receiver"] as? String
//                gameInvites.append(GIModel(sender: sender ?? "Null", receiver: receiver ?? "Null", record: returnedRecord))
//            }
//        }
//        
//        
//        if #available(iOS 15.0, *) {
//            queryOperation.queryResultBlock = { [weak self] returnedResult in
//                for gi in gameInvites{
//                    if gi.sender == giSender{
//                        self?.deleteGameInvite(record:gi.record)
//                    }
//                }
//            }
//        }
//        else{
//            queryOperation.queryCompletionBlock = { [weak self] (returnedCursor, returnedError) in
//                for gi in gameInvites{
//                    if gi.sender == giSender{
//                        self?.deleteGameInvite(record:gi.record)
//                    }
//                }
//            }
//        }
//        addOperation(operation: queryOperation)
//    }
//    
//    func deleteGameInvite(record:CKRecord){
//        CKContainer(identifier: "iCloud.com.ericviera.TapTapCoin").publicCloudDatabase.delete(withRecordID: record.recordID) { returnedRecordID, returnedError in
//            print("IN DELETE GAME INVITE COMPLETION")
//            print(returnedRecordID)
//            print(returnedError)
//        }
//    }
    
    func call_get_user(){
        print("IN THE GET USER CALL")
        DispatchQueue.main.async { [weak self] in
            self?.globalFunctions.getUser(token:self?.logged_in_user ?? "None", this_user:nil, curr_user:nil)
        }
//        DispatchQueue.main.async { [weak self] in
//            self?.userModel = UserViewModel(self?.userViewModel ?? Data())
//        }
        
    }
    
    func show_hide_friend_request_actions(index:String){
        show_friend_request_actions_bool = !show_friend_request_actions_bool
        friend_requester_name = index
    }
    
    func show_hide_friend_actions(index:Int, friend:String){
        print("IN SHOW HIDE FRIENDS ACTION")
        friends_indexes[index] = !(friends_indexes[index] ?? false)
        print(friends_indexes[index])
//        show_friend_actions_bool = !show_friend_actions_bool
        friend_name = friend
    }
 }
