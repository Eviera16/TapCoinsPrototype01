//
//  HomeViewModel.swift
//  TapCoinsPrototype01
//
//  Created by Eric Viera on 2/18/24.
//

import Foundation
import SwiftUI
//import CloudKit
//import RecaptchaEnterprise

final class HomeViewModel: ObservableObject {
    @AppStorage("session") var logged_in_user: String?
    @AppStorage("user") private var userViewModel: Data?
    @AppStorage("de_queue") private var de_queue: Bool?
    @AppStorage("notifications") var notifications_on:Bool?
    @AppStorage("debug") private var debug: Bool?
    @AppStorage("in_queue") var in_queue: Bool?
    @AppStorage("show_security_questions") var show_security_questions:Bool?
    @AppStorage("selectedOption1") var selectedOption1:Int?
    @AppStorage("selectedOption2") var selectedOption2:Int?
    @AppStorage("answerHere1") var answerHere1:String?
    @AppStorage("answerHere2") var answerHere2:String?
    @AppStorage("loadedUser") var loaded_get_user:Bool?
    @Published var iCloudAccountError:String?
    @Published var hasiCloudAccountError:Bool?
    @Published var isSignedInToiCloud:Bool?
    @Published var user_name:String?
    @Published var username:String = "NULL"
    @Published var showFaceIdPopUp:Bool = false
    @Published var passedFaceId:Bool = false
    @Published var failedFaceId:Bool = false
    @Published var userModel:UserViewModel?
    @Published var iCloud_status:String = "No iCloud Status."
//    @Published var loaded_get_user:Bool = false
    @Published var failedFaceIdMessage: String = ""
    @Published var pressed_find_game:Bool = false
    @Published var pressed_face_id_button:Bool = false
    @Published var pressed_check_and_set_sqs:Bool = false
    @Published var temp_answer_1:String = ""
    @Published var temp_answer_2:String = ""
    @Published var temp_question_1:Int = 0
    @Published var temp_question_2:Int = 0
    @Published var got_security_questions:Bool = false
    public var options1:[String] = ["Loading ..."]
    public var options2:[String] = ["Loading ..."]
    private var question_1:String = ""
    private var answer_1:String = ""
    private var question_2:String = ""
    private var answer_2:String = ""
    private var status_granted:Bool = false
    private var globalFunctions = GlobalFunctions()
//    @StateObject private var rc_vm = ReCAPTCHAClientViewModel()
    
    init() {
//        rc_vm.initialize_client()
        print("LOCATION VALUE BELOW")
//        print(self.logged_in_user)
//        print(selectedOption1)
//        print(selectedOption2)
//        print(answerHere1)
//        print(answerHere2)
        // Put dispatch queue here for get User call
//        self.getUser()
        DispatchQueue.main.async { [weak self] in
            self?.globalFunctions.getUser(token:self?.logged_in_user ?? "None", this_user:nil, curr_user:nil)
        }
        // put call to get security questions here
        DispatchQueue.main.async { [weak self] in
            self?.userModel = UserViewModel(self?.userViewModel ?? Data())
            self?.get_security_questions_text()
            if self?.userModel?.has_security_questions == true{
                self?.show_security_questions = false
            }
            else{
                self?.show_security_questions = true
                self?.selectedOption1 = 0
                self?.selectedOption2 = 0
                self?.answerHere1 = ""
                self?.answerHere2 = ""
            }
        }
        DispatchQueue.main.async { [weak self] in
            if self?.userModel?.is_guest == false {
//                self?.getiCloudStatus()
            }
            else{
                print("NO ICLOUD STATUS IS A GUEST")
                self?.iCloud_status = "IS A GUEST"
                self?.show_security_questions = false
            }
        }
       print("SHOW SECURITY QUESTIONS IS BELOW")
        print(show_security_questions)
    }
    
//    func test_ReCAPTCHA_Function(){
//        self.rc_vm.execute()
//    }
    func get_security_questions_text(){
        var url_string:String = ""
        
        if debug ?? true{
            print("DEBUG IS TRUE")
            url_string = "http://127.0.0.1:8000/tapcoinsapi/securityquestions/get_security_questions_text"
        }
        else{
            url_string = "https://tapcoin1.herokuapp.com/tapcoinsapi/securityquestions/get_security_questions_text"
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
                    let response = try JSONDecoder().decode(SecurityQResponse.self, from: data)
                    print("RESPONSE BELOW")
                    print(response)
                    self?.options1 = response.options_1
                    self?.options2 = response.options_2
                    print("GOT THE SECURITY QUESTIONS")
                    self?.got_security_questions = true
                }
                catch{
                    self?.logged_in_user = nil
                    print(error)
                }
            }
        })
        task.resume()
    }
    
    struct SecurityQResponse:Codable {
        let options_1: [String]
        let options_2: [String]
    }
    
    func save_questions_and_answers(){
        var url_string:String = ""
        
        if debug ?? true{
            print("DEBUG IS TRUE")
            url_string = "http://127.0.0.1:8000/tapcoinsapi/securityquestions/save_users_security_questions"
        }
        else{
            url_string = "https://tapcoin1.herokuapp.com/tapcoinsapi/securityquestions/save_users_security_questions"
        }
        
        guard let url = URL(string: url_string) else{
            return
        }
        var request = URLRequest(url: url)
        
        guard let session = logged_in_user else{
            return
        }
        print("SESSION IS BELOW")
        print(session)
        print("SAVING DATA BELOW")
        print(question_1)
        print(answer_1)
        print(question_2)
        print(answer_2)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: AnyHashable] = [
            "token": session,
            "question_1":question_1,
            "answer_1": answer_1,
            "question_2":question_2,
            "answer_2": answer_2
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)

        let task = URLSession.shared.dataTask(with: request, completionHandler: {[weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            print("DATA BELOW")
            print(data)
            DispatchQueue.main.async {
                do {
                    print("IN THE DO")
                    let response = try JSONDecoder().decode(Save_SQ_Response.self, from: data)
                    print("RESPONSE BELOW")
                    print(response)
                    self?.show_security_questions = false
                    self?.pressed_check_and_set_sqs = false
                }
                catch{
                    print(error)
                }
            }
        })
        task.resume()
    }
    
    struct Save_SQ_Response:Codable{
        let result:String
    }
    
    func check_and_set_sqs(){
        pressed_check_and_set_sqs = true
        print("THE DATA I AM LOOKING FOR IS BELOW")
        print(temp_question_1)
        print(temp_question_2)
        print(temp_answer_1)
        print(temp_answer_2)
        if temp_question_1 != 0 {
            print("QUESTION 1 IS BELOW")
            print(options1[temp_question_1])
            question_1 = options1[temp_question_1]
        }
        else{
            print("QUESTION 1 IS NIL")
            self.pressed_check_and_set_sqs = false
            return
        }
        
        if temp_answer_1 != "" {
            print("ANSWER 1 IS BELOW")
            print(temp_answer_1)
            answer_1 = temp_answer_1
        }
        else{
            print("ANSWER 1 IS NIL")
            self.pressed_check_and_set_sqs = false
            return
        }
        
        if temp_question_2 != 0{
            print("QUESTION 2 IS BELOW")
            print(options2[temp_question_2])
            question_2 = options2[temp_question_2]
        }
        else{
            print("QUESTION 2 IS NIL")
            self.pressed_check_and_set_sqs = false
            return
        }
        
        if temp_answer_2 != ""{
            print("ANSWER 2 IS BELOW")
            print(temp_answer_2)
            answer_2 = temp_answer_2
        }
        else{
            print("ANSWER 2 IS NIL")
            self.pressed_check_and_set_sqs = false
            return
        }
        
        save_questions_and_answers()
    }
    
//    private func getiCloudStatus(){
//        print("IN GET ICLOUD STATUS")
//        if self.debug ?? true{
//            print("DEBUG IS TRUE")
//            return
//        }
//        CKContainer(identifier: "iCloud.com.ericviera.TapTapCoin").accountStatus { [weak self] returnedStatus, returnedError in
//            DispatchQueue.main.async{
//                switch returnedStatus{
//                case .available:
//                    print("IS AVAILABLE")
//                    self?.iCloud_status = "IS AVAILABLE"
//                    self?.isSignedInToiCloud = true
//                    self?.requestPermission()
//                case .noAccount:
//                    print("NO ACCOUNT")
//                    self?.iCloud_status = "NO ACCOUNT"
//                    self?.iCloudAccountError = CloudKitError.iCloudAccountNotFound.rawValue
//                    self?.hasiCloudAccountError = true
//                case .couldNotDetermine:
//                    print("NOT DETERMINED")
//                    self?.iCloud_status = "NOT DETERMINED"
//                    self?.iCloudAccountError = CloudKitError.iCloudAccountNotDetermined.rawValue
//                    self?.hasiCloudAccountError = true
//                case .restricted:
//                    print("RESTRICTED")
//                    self?.iCloud_status = "RESTRICTED"
//                    self?.iCloudAccountError = CloudKitError.iCloudAccountRestricted.rawValue
//                    self?.hasiCloudAccountError = true
//                default:
//                    print("DEFAULT")
//                    self?.iCloud_status = "DEFAULT"
//                    self?.iCloudAccountError = CloudKitError.iCloudAccountUnknown.rawValue
//                    self?.hasiCloudAccountError = true
//                }
//            }
//        }
//    }
//    
//    func requestPermission(){
//        print("IN REQUEST PERMISSION")
//        CKContainer(identifier: "iCloud.com.ericviera.TapTapCoin").requestApplicationPermission([.userDiscoverability]) { [weak self] returnedStatus, returnedError in
//            DispatchQueue.main.async {
//                if returnedStatus == .granted{
//                    if self?.status_granted == false{
//                        self?.status_granted = true
//                        print("STATUS IS GRANTED")
//                        self?.iCloud_status = "STATUS IS GRANTED"
//                        self?.fetchiCloudUserRecordID()
//                    }
//                }
//                else{
//                    print("STATUS IS NOT GRANTED")
//                    self?.iCloud_status = "STATUS IS NOT GRANTED"
//                    print(returnedStatus)
//                }
//            }
//        }
//    }
//    
//    func fetchiCloudUserRecordID(){
//        print("IN FETCH ICLOUD USER RECORD ID")
//        CKContainer(identifier: "iCloud.com.ericviera.TapTapCoin").fetchUserRecordID { [weak self] returnedID, returnedError in
//            if let id = returnedID{
//                print("HAS AN ID")
//                self?.iCloud_status = "HAS AN ID"
//                self?.discoveriCloudUser(id: id)
//            }
//            else{
//                print("NO ID")
//                self?.iCloud_status = "NO ID"
//                print(returnedError)
//            }
//        }
//    }
//    
//    func discoveriCloudUser(id: CKRecord.ID){
//        print("IN DISCOVER ICLOUD USER")
//        CKContainer(identifier: "iCloud.com.ericviera.TapTapCoin").discoverUserIdentity(withUserRecordID: id) { [weak self] returnedIdentity, returnedError in
//            DispatchQueue.main.async {
//                if let name = returnedIdentity?.nameComponents?.givenName {
//                    print("HAS A GIVEN NAME")
//                    self?.iCloud_status = "HAS A GIVEN NAME"
//                    self?.user_name = name
//                    print(name)
//                    //request permission for notifications
//                    self?.requestNotificationPermissions()
//                }
//                else{
//                    print("NO GIVEN NAME")
//                    self?.iCloud_status = "NO GIVEN NAME"
//                }
//            }
//        }
//    }
//    
//    func requestNotificationPermissions(){
//        print("IN REQUEST NOTIFICATION PERMISSIONS")
//        let options:UNAuthorizationOptions = [.alert, .sound, .badge]
//        UNUserNotificationCenter.current().requestAuthorization(options: options) { [weak self] success, error in
//            if let error = error{
//                print(error)
//                self?.iCloud_status = "HAS AN ERROR IS REQUEST NOTIFICATIONS PERMISSIONS"
//            }
//            else if success{
//                print("Notification permissions success.")
//                self?.iCloud_status = "Notification permissions success."
//                DispatchQueue.main.async{
//                    UIApplication.shared.registerForRemoteNotifications()
//                    self?.subscribeToNotifications()
//                }
//            }
//            else{
//                print("Notification permissions failure.")
//                self?.iCloud_status = "Notification permissions failure."
//            }
//        }
//    }
//    
//    func subscribeToNotifications(){
//        print("IN SUBSCRIBE TO NOTIFICATIONS")
//        if notifications_on != nil{
//            print("NOTIFICATIONS ARE ALREADY SET")
//            self.iCloud_status = "NOTIFICATIONS ARE ALREADY SET"
//            return
//        }
//        if username == "NULL"{
//            self.iCloud_status = "USERNAME IS NULL HERE"
//            return
//        }
//        let predicate = NSPredicate(format: "receiver = %@", argumentArray: [username])
//        let subscription = CKQuerySubscription(recordType: "FriendRequest", predicate: predicate, subscriptionID: "friend_request_received", options: .firesOnRecordCreation)
//        
//        let notification = CKSubscription.NotificationInfo()
//        notification.title = "Friend request received!"
//        notification.alertBody = "Open app to accept or decline."
//        notification.soundName = "default"
//        
//        subscription.notificationInfo = notification
//        
//        CKContainer(identifier: "iCloud.com.ericviera.TapTapCoin").publicCloudDatabase.save(subscription) { [weak self] returnedSubscription, returnedError in
//            if let error = returnedError{
//                print(error)
//                self?.iCloud_status = "HAS AN ERROR IS SUBSCRIBE TO FRIEND REQUEST"
//            }
//            else{
//                print("SUCCESSFULLY SUBSCRIBED TO NOTIFICATIONS")
//                self?.iCloud_status = "SUCCESSFULLY SUBSCRIBED TO NOTIFICATIONS"
//                DispatchQueue.main.async {
//                    self?.notifications_on = true
//                }
//            }
//        }
//        let subscription2 = CKQuerySubscription(recordType: "GameInvite", predicate: predicate, subscriptionID: "game_invite_received", options: .firesOnRecordCreation)
//        
//        let notification2 = CKSubscription.NotificationInfo()
//        notification2.title = "Game invite received!"
//        notification2.alertBody = "Open app to accept or decline."
//        notification2.soundName = "default"
//        
//        subscription2.notificationInfo = notification2
//        
//        CKContainer(identifier: "iCloud.com.ericviera.TapTapCoin").publicCloudDatabase.save(subscription2) { [weak self] returnedSubscription, returnedError in
//            if let error = returnedError{
//                print(error)
//                self?.iCloud_status = "HAS AN ERROR IS SUBSCRIBE TO GAME INVITE"
//            }
//            else{
//                print("SUCCESSFULLY SUBSCRIBED TO NOTIFICATIONS FOR GAME INVITES")
//                self?.iCloud_status = "SUCCESSFULLY SUBSCRIBED TO NOTIFICATIONS FOR GAME INVITES"
//                DispatchQueue.main.async {
//                    self?.notifications_on = true
//                }
//            }
//        }
//    }
//    
    func tempFaceIdPopUpButton(showValue:Bool){
        if showValue == false{
            pressed_face_id_button = true
            var url_string:String = ""
            if debug ?? true{
                print("DEBUG IS TRUE")
                url_string = "http://127.0.0.1:8000/tapcoinsapi/tapcoinsbc/passFaceId"
            }
            else{
                url_string = "https://tapcoin1.herokuapp.com/tapcoinsapi/tapcoinsbc/passFaceId"
            }
            
            guard let url = URL(string: url_string) else{
                return
            }
            var request = URLRequest(url: url)
            
            guard let session = logged_in_user else{
                return
            }
            print("SESSION IS BELOW")
            print(session)
            var isUserOne = false
            if self.userModel?.username == "SAUCEYE"{
                isUserOne = true
            }
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let body: [String: AnyHashable] = [
                "token": session,
                "isUserOne": isUserOne
            ]
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)

            let task = URLSession.shared.dataTask(with: request, completionHandler: {[weak self] data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                print("DATA BELOW")
                print(data)
                DispatchQueue.main.async {
                    do {
                        print("IN THE DO")
                        let response = try JSONDecoder().decode(Response2.self, from: data)
                        print("RESPONSE BELOW")
                        print(response)
                        if response.result == "SUCCESS"{
                            if response.passed == true{
                                self?.passedFaceId = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    self?.showFaceIdPopUp = showValue
                                    self?.in_queue = true
                                }
                            }
                            else{
                                self?.failedFaceId = true
                                self?.failedFaceIdMessage = "User Wallet has not been added yet."
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    self?.showFaceIdPopUp = false
                                }
                            }
                        }
                        else{
                            print("RESULT IS BELOW")
                            print(response.result)
                            self?.failedFaceId = true
                            self?.failedFaceIdMessage = "Something went wrong."
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                self?.showFaceIdPopUp = false
                                self?.pressed_face_id_button = false
                                self?.pressed_find_game = false
                            }
                        }
                    }
                    catch{
                        print(error)
                    }
                }
            })
            task.resume()

        }
        else{
            showFaceIdPopUp = showValue
        }
    }

    struct Response2:Codable {
        let result: String
        let passed: Bool
    }

}
