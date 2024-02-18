//
//  FriendsListItemViewModel.swift
//  TapCoinsPrototype01
//
//  Created by Eric Viera on 2/18/24.
//

import Foundation
import SwiftUI

final class FriendsListItemViewModel: ObservableObject {
    @AppStorage("debug") private var debug: Bool?
    @AppStorage("session") var logged_in_user: String?
    @AppStorage("Player1") var first_player: String?
    @AppStorage("Player2") var second_player: String?
    @AppStorage("gameId") var game_id: String?
    @AppStorage("from_queue") var from_queue: Bool?
    @AppStorage("custom_game") var custom_game: Bool?
    @AppStorage("is_first") var is_first: Bool?
    @AppStorage("in_game") var in_game: Bool?
    @AppStorage("user") private var userViewModel: Data?
    @AppStorage("num_friends") public var num_friends:Int?
    @Published var userModel:UserViewModel?
    @Published var friend_requester_name:String = ""
    @Published var show_friend_request_actions_bool:Bool = false
    @Published var pressed_decline_request:Bool = false
    @Published var pressed_accept_request:Bool = false
    @Published var pressed_accept_invite:Bool = false
    @Published var pressed_decline_invite:Bool = false
    @Published var pressed_remove_friend:Bool = false
    @Published var pressed_send_invite:Bool = false
    @Published var show_friend_actions_bool:Bool = false
    @Published var friend_state:FriendItemState = FriendItemState.DynamicFriend
    @Published var normalFriendName:String = ""
    @Published var loading_the_switch:Bool = false
    // Look into how exactly this is working below
    @Published var active_friends_index_list:[Int] = []
    private var removed_friend_successfully:Bool = false
    private var view_token:String = ""
    
    init(){
        print("IN THE FRIENDS VIEW LIST ITEM INIT")
//        self.call_get_user()
        userModel = UserViewModel(self.userViewModel ?? Data())
        print(userModel?.active_friends_index_list)
        print(userModel?.friends)
        active_friends_index_list = userModel?.active_friends_index_list ?? []
//        self.friend_logic()
//        CustomGameHandler.sharedInstance.establishConnection()
//        print("ESTABLISHED CONNECTION")
    }
    
    func show_hide_friend_request_actions(index:String){
        show_friend_request_actions_bool = !show_friend_request_actions_bool
        friend_requester_name = index
    }
    
    func show_hide_friend_actions(index:Int, friend:String){
        print("IN SHOW HIDE FRIENDS ACTION")
        show_friend_actions_bool = !show_friend_actions_bool
    }
    
    
    func declineRequestTask(friend:String){
        Task {
            do {
                pressed_remove_friend = true
                let rNameSplit = friend.split(separator: " ")
                let rUsername = rNameSplit[3]
                let result:Bool = try await declineFriendRequest(requestName: String(rUsername))
                if result{
                    removeFriendFromList(requestName: friend)
                }
                else{
                    // Handle for error here
                    print("Something went wrong.")
                }
                pressed_remove_friend = false
            } catch {
                let result = "Error: \(error.localizedDescription)"
                print(result)
                pressed_remove_friend = false
            }
        }
    }
    
    func declineFriendRequest(requestName:String) async throws -> Bool{
        var url_string:String = ""
        
        if debug ?? true{
            print("DEBUG IS TRUE")
            url_string = "http://127.0.0.1:8000/tapcoinsapi/friend/dfr"
        }
        else{
            url_string = "https://tapcoin1.herokuapp.com/tapcoinsapi/friend/dfr"
        }
        
        guard let session = logged_in_user else {
            throw UserErrors.invalidSession
        }
        
        guard let url = URL(string: url_string) else{
            throw FriendError.invalidURL
        }
        print("GOT VALID URL")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let requestBody = "username=" + requestName + "&token=" + session
        request.httpBody = requestBody.data(using: .utf8)
        
        let (data, response) = try await URLSession.shared.data(for:request)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw FriendError.invalidResponse
        }
        print("GOT VALID RESPONSE")
        do {
            print("IN THE DO")
            let decoder = JSONDecoder()
            print("GOT THE DECODER")
//            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let dcFrResponse = try decoder.decode(FriendRequestResponse.self, from: data)
            print("GOT THE DECLINED FRIEND RESPONSE")
            print(dcFrResponse)
            if dcFrResponse.result == "Declined"{
                return true
            }
            return false
        }
        catch {
            throw FriendError.invalidData
        }
    }
    
    func acceptRequestTask(friend:String){
        print("IN ACCEPT REQUEST TASK")
        Task {
            print("IN THE TASK")
            do {
                print("IN THE DO")
                pressed_accept_request = true
                let rNameSplit = friend.split(separator: " ")
                let rUsername = rNameSplit[3]
                let result:Bool = try await acceptFriendRequest(requestName: String(rUsername))
                if result{
                    print("RESULT IS TRUE")
//                    addFriendToList(requestName: friend)
                    normalFriendName = String(rNameSplit[3])
                    DispatchQueue.main.async {
                        if self.num_friends == nil{
                            self.num_friends = 1
                        }
                        else{
                            self.num_friends! += 1
                        }
                        print("ACCEPTED FRIEND REQUEST AND NORMALIZED FRIEND")
                        self.friend_state = FriendItemState.NormalFriend
                    }
                }
                else{
                    // Handle for error here
                    print("Something went wrong.")
                }
                pressed_accept_request = false
            } catch {
                let result = "Error: \(error.localizedDescription)"
                print(result)
                pressed_accept_request = false
            }
        }
    }
    
    func acceptFriendRequest(requestName:String) async throws -> Bool{
        var url_string:String = ""
        
        if debug ?? true{
            print("DEBUG IS TRUE")
            url_string = "http://127.0.0.1:8000/tapcoinsapi/friend/afr"
        }
        else{
            url_string = "https://tapcoin1.herokuapp.com/tapcoinsapi/friend/afr"
        }
        
        guard let session = logged_in_user else {
            throw UserErrors.invalidSession
        }
        
        guard let url = URL(string: url_string) else{
            throw FriendError.invalidURL
        }
        print("GOT VALID URL")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let requestBody = "username=" + requestName + "&token=" + session
        request.httpBody = requestBody.data(using: .utf8)
        
        let (data, response) = try await URLSession.shared.data(for:request)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw FriendError.invalidResponse
        }
        print("GOT VALID RESPONSE")
        do {
            print("IN THE DO")
            let decoder = JSONDecoder()
            print("GOT THE DECODER")
//            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let acFrResponse = try decoder.decode(FriendRequestResponse.self, from: data)
            print("GOT THE REMOVE FRIEND RESPONSE")
            print(acFrResponse)
            if acFrResponse.result == "Accepted"{
                return true
            }
            return false
        }
        catch {
            throw FriendError.invalidData
        }
    }
    
    func removeFriendTask(friend:String){
        Task {
            do {
                let result:Bool = try await removeFriendFunction(requestName: friend)
                if result{
                    removeFriendFromList(requestName: friend)
                }
                else{
                    // Handle for error here
                    print("Something went wrong.")
                }
                pressed_remove_friend = false
            } catch {
                let result = "Error: \(error.localizedDescription)"
                print(result)
                pressed_remove_friend = false
            }
        }
    }
    
    func removeFriendFunction(requestName:String) async throws -> Bool{
        var url_string:String = ""
        print("REQUEST NAME BELOW")
        print(requestName)
        var sending_username = ""
        
        if friend_state == FriendItemState.NormalFriend{
            sending_username = adjustNormalFriendName(input_name: requestName)
        }
        else{
            sending_username = requestName
        }
        
        if debug ?? true{
            print("DEBUG IS TRUE")
            url_string = "http://127.0.0.1:8000/tapcoinsapi/friend/remove_friend"
        }
        else{
            url_string = "https://tapcoin1.herokuapp.com/tapcoinsapi/friend/remove_friend"
        }
        
        guard let session = logged_in_user else {
            throw UserErrors.invalidSession
        }
        
        guard let url = URL(string: url_string) else{
            throw FriendError.invalidURL
        }
        print("GOT VALID URL")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let requestBody = "username=" + sending_username + "&token=" + session
        request.httpBody = requestBody.data(using: .utf8)
        
        let (data, response) = try await URLSession.shared.data(for:request)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw FriendError.invalidResponse
        }
        print("GOT VALID RESPONSE")
        do {
            print("IN THE DO")
            let decoder = JSONDecoder()
            print("GOT THE DECODER")
//            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let rmFrResponse = try decoder.decode(FriendRequestResponse.self, from: data)
            print("GOT THE REMOVE FRIEND RESPONSE")
            print(rmFrResponse)
            if rmFrResponse.result == "Removed"{
                return true
            }
            return false
        }
        catch {
            throw FriendError.invalidData
        }
    }
    
    func adjustNormalFriendName(input_name:String) -> String {
        let iNameSplit = input_name.split(separator: " ")
        let iUsername = iNameSplit[3]
        return String(iUsername)
    }
    
    func addFriendToList(requestName:String){
        DispatchQueue.main.async {
            var index = 0
            for friend in self.userModel?.friends ?? ["NO FRIENDS"]{
                if friend.contains(requestName){
                    self.userModel?.friends?[index] = String(requestName)
                    break
                }
                index += 1
            }
            if self.num_friends == nil{
                self.num_friends = 1
            }
            else{
                self.num_friends! += 1
            }
            print("ACCEPTED FRIEND REQUEST AND NORMALIZED FRIEND")
            self.friend_state = FriendItemState.NormalFriend
        }
    }
    
    func removeFriendFromList(requestName:String){
        DispatchQueue.main.async {
            var ecount = 0
            var friendsList = self.userModel?.friends ?? ["NO FRIENDS"]
            print("FIRENDS LIST BELOW")
            print(friendsList)
            if friendsList[0] != "NO FRIENDS"{
                print("USER HAS FRIENDS")
                for friendIndex in friendsList.indices {
                    if ecount == 0 && friendIndex == 5{
                        print("SOMETHING WENT WRONG WITH THE FRIEND INDICES")
                        break
                    }
                    if friendsList[friendIndex] == requestName{
                        self.userModel?.friends?.remove(at: friendIndex)
                        print("REMOVED FRIEND")
                    }
                    ecount+=1
                }
                if self.num_friends == nil || self.num_friends == 0{
                    print("ADJUSTED NUM FRIENDS HERE")
                    self.num_friends = 0
                }
                else{
                    print("SUBTRACTED FROM NUM FRIENDS HERE")
                    self.num_friends! -= 1
                }
                self.userModel?.numFriends = self.num_friends
                print("NEW FRIENDS BELOW")
                print(self.userModel?.friends)
                self.userViewModel = self.userModel?.storageValue
                //                            // Adjust get user call here
                //                            self?.call_get_user()
                //                            self?.friend_logic()
            }
            else{
                print("HAS NO FRIENDS?")
                print("NEW FRIENDS BELOW")
                print(self.userModel?.friends)
            }
        }
    }
    
    struct FriendRequestResponse:Codable {
        let result: String
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
        
        guard let session = logged_in_user else {
            return
        }
        
        guard let url = URL(string: url_string) else{
            return
        }
        var request = URLRequest(url: url)
        //        if let environment = ProcessInfo.processInfo.environment["login"], let url = URL(string: environment){
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
                        // self?.friend_logic() // Look into if this is working/ doing anything
                        print("FIRST AND SECOND PLAYER BELOW")
                        print(response.first)
                        print(response.second)
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
        
        guard let session = logged_in_user else {
            return
        }
        
        guard let url = URL(string: url_string) else{
            return
        }
        var request = URLRequest(url: url)
        print("THE USERNAME FOR DECLINE IS BELOW")
        print("THE USERNAME FOR DECLINE IS BELOW")
        print("THE USERNAME FOR DECLINE IS BELOW")
        print(rNameSplit[3])
        //        if let environment = ProcessInfo.processInfo.environment["login"], let url = URL(string: environment){
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: AnyHashable] = [
            "username": rNameSplit[3],
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
//                        self?.addFriendToList(requestName: String(rNameSplit[3]))
                        self?.normalFriendName = String(rNameSplit[3])
                        if self?.num_friends == nil{
                            self?.num_friends = 1
                        }
                        else{
                            self?.num_friends! += 1
                        }
                        print("ACCEPTED FRIEND REQUEST AND NORMALIZED FRIEND")
                        self?.friend_state = FriendItemState.NormalFriend
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
        
        guard let session = logged_in_user else {
            return
        }
        
        guard let url = URL(string: url_string) else{
            return
        }
        var request = URLRequest(url: url)
        //        if let environment = ProcessInfo.processInfo.environment["login"], let url = URL(string: environment){
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
}
