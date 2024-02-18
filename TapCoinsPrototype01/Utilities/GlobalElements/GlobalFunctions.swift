//
//  GlobalFunctions.swift
//  TapCoinsPrototype01
//
//  Created by Eric Viera on 2/18/24.
//

import Foundation
import SwiftUI
//import CloudKit

struct GlobalFunctions {
    @AppStorage("session") var logged_in_user: String?
    @AppStorage("debug") private var debug: Bool?
    @AppStorage("user") private var userViewModel: Data?
    @AppStorage("de_queue") private var de_queue: Bool?
    @AppStorage("show_location") var show_location:Int?
    @AppStorage("location_on") var location_on:Bool?
    @AppStorage("in_game") var in_game: Bool?
    @AppStorage("in_queue") var in_queue: Bool?
    @AppStorage("Player1") var first_player: String?
    @AppStorage("Player2") var second_player: String?
    @AppStorage("GotFirst") var got_first:Bool?
    @AppStorage("GotSecond") var got_second:Bool?
    @AppStorage("loadedUser") var loaded_get_user:Bool?
    private var in_get_user:Bool = false
    
    func getUser(token:String, this_user:Int?, curr_user:Int?){
        var url_string:String = ""
        
        if debug ?? true{
            print("DEBUG IS TRUE")
            url_string = "http://127.0.0.1:8000/tapcoinsapi/user/info"
        }
        else{
            url_string = "https://tapcoin1.herokuapp.com/tapcoinsapi/user/info"
        }
        guard var urlComponents = URLComponents(string: url_string) else {
            return
        }
        guard let session = logged_in_user else{
            return
        }
        
        // Add query parameters to the URL
        urlComponents.queryItems = [
            URLQueryItem(name: "token", value: session),
            URLQueryItem(name: "de_queue", value: "\(self.de_queue ?? false)")
        ]
        
        // Ensure the URL is valid
        guard let url = urlComponents.url else {
            return
        }
        
        var request = URLRequest(url: url)
        
        // Set the HTTP method to GET
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {data, _, error in
            guard let data = data, error == nil else {
                return
            }
            print("DATA BELOW")
            print(data)
            DispatchQueue.main.async {
                do {
                    print("IN THE DO Home")
                    let response = try JSONDecoder().decode(Response.self, from: data)
                    if response.has_location{
                        self.location_on = true
                        self.show_location = 1
                    }
                    else{
                        self.location_on = false
                        self.show_location = 0
                    }
                    var myData = UserViewModel(first_name: response.first_name, last_name: response.last_name, response: response.response, username: response.username, phone_number: response.phone_number, friends: response.friends, active_friends_index_list: response.active_friends_index_list, hasInvite: response.hasInvite, wins: response.wins, losses: response.losses, win_streak: response.win_streak, best_streak: response.best_streak, league: response.league_placement, hasPhoneNumber: response.HPN, is_guest: response.is_guest, has_wallet: response.has_wallet, has_security_questions: response.has_security_questions
                    )
                    if response.friends.count > 0{
                        if response.friends[0] == "0"{
                            myData.numFriends = 0
                        }
                        else{
                            var count = 0
                            for friend in response.friends{
                                if !friend.contains("requested|"){
                                    if !friend.contains("sentTo|"){
                                        count += 1
                                        if response.hasInvite{
                                            myData.hasGI = true
                                        }
                                    }
                                    else{
                                        myData.hasST = true
                                    }
                                }
                                else{
                                    myData.hasRQ = true
                                }
                            }
                            myData.numFriends = count
                            myData.fArrayCount = response.friends.count
                        }
                    }
                    else{
                        myData.numFriends = 0
                        myData.fArrayCount = 0
                    }
                    myData.hasPhoneNumber = response.HPN
                    self.de_queue = nil
                    self.userViewModel = myData.storageValue
                    self.loaded_get_user = true
                }
                catch{
                    self.logged_in_user = nil
                    print(error)
                }
            }
        })
        task.resume()
    }
    
    // Response for Home View Get User Call
    struct Response:Codable {
        let first_name: String
        let last_name: String
        let response: String
        let username: String
        let phone_number: String
        let friends:Array<String>
        let active_friends_index_list:Array<Int>
        let hasInvite:Bool
        let HPN:Bool
        let is_guest:Bool
        let wins: Int
        let losses: Int
        let league_placement: Int
        let win_streak: Int
        let best_streak: Int
        let has_wallet: Bool
        let has_location: Bool
        let has_security_questions: Bool
    }
    
    func validate(value: String) -> Bool {
        let int_phone_number = Int(value) ?? 0
        if int_phone_number == 0 {
            return false
        }
        if int_phone_number > 9999999999999999 || int_phone_number <= 0{
            return false
        }
        else{
            let phone_regex = #"^(\+\d{1,2}\s)?\(?\d{3}\)?[\s.-]?\d{3}[\s.-]?\d{4}"#
            return NSPredicate(format: "SELF MATCHES %@", phone_regex).evaluate(with: value)
        }
    }
    
    func check_errors(state:Error_States, _phone_number:String, uName:String, p1:String, p2:String) -> String{
        var is_uName_error = false
        var is_password_error = false
        switch state {
        case .Required:
            is_uName_error = uName.count <= 0 ? true : false
            if !is_uName_error{
                return "Pass"
            }
            return "Required"
        case .Invalid_Username:
            return "Invalid_Username"
        case .Password_Match:
            if p1 != p2{
                return "PMError"
            }
        case .Invalid_Phone_Number:
            if validate(value: _phone_number) == false{
                return "PHError"
            }
        case .No_Match_User:
            return "NMUError"
        case .No_Match_Password:
            return "NMPError"
        case .RequiredLogin:
            is_uName_error = uName.count <= 0 ? true : false
            is_password_error = p1.count <= 0 ? true : false
            if !is_uName_error && !is_password_error{
                return "Pass"
            }
            return "RequiredLogin"
        case .Specific_Password_Error:
            return "SpecificPasswordError"
        }
        return "Pass"
    }
    
    func get_security_questions_text() -> [String: Any]?{
        var got_response = false
        var return_data: [String: Any]?
        var _error:Bool = false
        var url_string:String = ""
        
        if debug ?? true{
            print("DEBUG IS TRUE")
            url_string = "http://127.0.0.1:8000/tapcoinsapi/securityquestions/get_security_questions_text"
        }
        else{
            url_string = "https://tapcoin1.herokuapp.com/tapcoinsapi/securityquestions/get_security_questions_text"
        }
        
        guard let url = URL(string: url_string) else{
            return nil
        }
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        DispatchQueue.main.async {
            let task = URLSession.shared.dataTask(with: request, completionHandler: {[self] data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                print("DATA BELOW")
                print(data)
                DispatchQueue.main.async {
                    do {
                        print("IN THE DO")
                        let response = try JSONDecoder().decode(SecurityQResponse.self, from: data)
                        print("RESPONSE BELOW")
                        print(response)
                        let joined1 = response.options_1.joined(separator: ";")
                        let joined2 = response.options_2.joined(separator: ";")
                        let joined3 = joined1 + "|" + joined2
                        let response_data: [String: Any] = [
                            "security_questions": joined3,
                            "options1": response.options_1,
                            "options2": response.options_2
                        ]
                        return_data = response_data
                        got_response = true
                    }
                    catch{
                        // return nil
                        _error = true
                        print(error)
                    }
                }
            })
            task.resume()
        }
        if (got_response == true){
            return return_data
        }
        else{
            if (_error){
                return nil
            }
            var count = 0
            while(got_response == false){
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    if (count == 3){
                        _error = true
                    }
                    else{
                        count += 1
                    }
                }
                if (_error == true){
                    break
                }
            }
            return return_data
        }
    }
    
    struct SecurityQResponse:Codable {
        let options_1: [String]
        let options_2: [String]
    }
    
//    func addRequest(sender:String, receiver:String, requestType: String) -> String{
//        var newRequest: CKRecord?
//        if requestType == "FriendRequest"{
//            newRequest = CKRecord(recordType: "FriendRequest")
//        }
//        else if requestType == "GameInvite"{
//            newRequest = CKRecord(recordType: "GameInvite")
//        }
//        else{
//            newRequest = nil
//        }
//        if newRequest == nil{
//            return "NilRequest"
//        }
//        newRequest!["sender"] = sender
//        newRequest!["receiver"] = receiver
//        let result = (newRequest!["sender"] ?? "No Sender") + " | " + (newRequest!["receiver"] ?? "No Receiver")
//        if saveRequest(record: newRequest!){
//            return result
//        }
//        else{
//            return "SaveFail"
//        }
//    }
//    
//    func saveRequest(record:CKRecord) -> Bool{
//        var passed = false
//        CKContainer(identifier: "iCloud.com.ericviera.TapTapCoin").publicCloudDatabase.save(record) { [self] returnedRecord, returnedError in
//            if returnedError != nil{
//                passed = false
//            }
//            if returnedRecord != nil{
//                passed = true
//            }
//        }
//        return passed
//    }
}
