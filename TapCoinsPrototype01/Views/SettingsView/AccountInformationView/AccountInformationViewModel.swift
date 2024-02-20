//
//  AccountInformationViewModel.swift
//  TapCoinsPrototype01
//
//  Created by Eric Viera on 2/18/24.
//

import Foundation
import SwiftUI

final class AccountInformationViewModel: ObservableObject {
    @AppStorage("session") var logged_in_user: String?
    @AppStorage("user") private var userViewModel: Data?
    @AppStorage("debug") private var debug: Bool?
    @AppStorage("de_queue") private var de_queue: Bool?
    @AppStorage("selectedOption1") var selectedOption1:Int?
    @AppStorage("selectedOption2") var selectedOption2:Int?
    @AppStorage("loadedUser") var loaded_get_user:Bool?
    @AppStorage("show_security_questions") var show_security_questions:Bool?
    @AppStorage("gsave_pressed") var gsave_pressed:Bool?
    @Published var first_name:String = ""
    @Published var last_name:String = ""
    @Published var username:String = ""
    @Published var phone_number:String = ""
    @Published var password:String = ""
    @Published var cpassword:String = ""
    @Published var message:String = ""
    @Published var error:String = ""
    @Published var username_error:Error_States?
    @Published var phone_error:Error_States?
    @Published var password_error:Error_States?
    @Published var is_phone_error:Bool = false
    @Published var is_uName_error:Bool = false
    @Published var is_match_error:Bool = false
    @Published var is_password_error:Bool = false
    @Published var is_error:Bool = false
    @Published var is_guest:Bool = false
    @Published var save_pressed:Bool = false
    @Published var save_p_pressed:Bool = false
    
    @Published var saved:Bool = false
    @Published var psaved:Bool = false
    @Published var show_guest_message:Bool = false
    @Published var _answerHere:String = "Your answer here"
    @Published var _is_pressed: Bool = false
    @Published var _index_pressed:Bool = false
    @Published var confirmed_current_password:Bool = false
    @Published var pressed_confirm_password:Bool = false
    @Published var confirm_password_error:Bool = false
    private var userData:UserViewModel?
    public var options1:[String] = ["Option1", "Option2", "Option3", "Option4"]
    public var options2:[String] = ["Option5", "Option6", "Option7", "Option8"]
    @Published var set_page_data:Bool = false
    private var globalFunctions = GlobalFunctions()
    private var current_username:String = ""
    private var initialFirstName:String = ""
    private var initialLastName:String = ""
    private var initialPhoneNumber:String = ""
    private var initialUserName:String = ""
    
    init(){
        self.userData = UserViewModel(self.userViewModel ?? Data())
        self.current_username = self.userData?.username ?? "None"
        self.setPageData(usersData: self.userData!)
        self.is_guest = self.userData?.is_guest ?? false
    }
    
    func setPageData(usersData:UserViewModel){
        username = userData?.username ?? "No username"
        first_name = userData?.first_name ?? "No First Name"
        last_name = userData?.last_name ?? "No Last Name"
        initialFirstName = first_name
        initialLastName = last_name
        initialUserName = username
        if userData?.hasPhoneNumber ?? false{
            phone_number = userData?.phone_number ?? ""
            initialPhoneNumber = phone_number
        }
        else{
            phone_number = ""
            initialPhoneNumber = ""
        }
        set_page_data = true
    }
    
    func checkValuesChanged() -> Bool{
        if userData?.is_guest ?? false{
            if initialUserName != username{
                return true
            }
        }
        else{
            if initialFirstName != first_name{
                return true
            }
            if initialLastName != last_name{
                return true
            }
            if initialPhoneNumber != phone_number{
                return true
            }
            if initialUserName != username{
                return true
            }
        }
        
        return false
    }
    
    func save(){
        save_pressed = true
        gsave_pressed = true
        show_guest_message = false
        saved = false
        is_phone_error = false
        is_uName_error = false
        if checkValuesChanged() == false{
            save_pressed = false
            gsave_pressed = false
            return
        }
        if check_errors_function(state: Error_States.Required, _phone_number: phone_number, uName: username) == false{
            save_pressed = false
            gsave_pressed = false
            return
        }
        if phone_number != ""{
            if check_errors_function(state: Error_States.Invalid_Phone_Number, _phone_number: phone_number, uName: username) == false{
                save_pressed = false
                gsave_pressed = false
                return
            }
        }
        var url_string:String = ""
        
        if debug ?? true{
            print("DEBUG IS TRUE")
            url_string = "http://127.0.0.1:8000/tapcoinsapi/user/save"
        }
        else{
            print("DEBUG IS FALSE")
            url_string = "https://tapcoin1.herokuapp.com/tapcoinsapi/user/save"
        }
        
        guard let url = URL(string: url_string) else{
            save_pressed = false
            gsave_pressed = false
            return
        }
        var request = URLRequest(url: url)
        guard let session = logged_in_user else{
            save_pressed = false
            gsave_pressed = false
            return
        }
        var changed_username:Bool = false
        if (self.current_username != self.username){
            changed_username = true
        }
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: AnyHashable] = [
            "first_name": first_name,
            "last_name": last_name,
            "phone_number": phone_number,
            "username": username,
            "token": session,
            "guest": is_guest,
            "changed_username": changed_username
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)

        let task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] data, _, error in
            guard let data = data, error == nil else {
                self?.save_pressed = false
                self?.gsave_pressed = false
                return
            }

            DispatchQueue.main.async {
                do {
                    let response = try JSONDecoder().decode(Response2.self, from: data)
                    if response.response == "Invalid username."{
                        if self?.check_errors_function(state: Error_States.Invalid_Username, _phone_number: self?.phone_number ?? "", uName: self?.username ?? "") == false{
                            self?.save_pressed = false
                            self?.gsave_pressed = false
                            return
                        }
                    }
                    else if response.response == "Successfully saved data."{
                        self?.saved = true
                        self?.save_pressed = false
                        self?.gsave_pressed = false
                        self?.message = "Successfully saved data."
                        self?.is_phone_error = false
                        self?.is_uName_error = false
                        self?.userData?.first_name = self?.first_name ?? ""
                        self?.userData?.last_name = self?.last_name ?? ""
                        self?.userData?.username = self?.username ?? ""
                        self?.userData?.phone_number = self?.phone_number ?? ""
                        self?.userViewModel = self?.userData?.storageValue
                    }
                    else if response.response == "Guest"{
                        self?.saved = true
                        self?.save_pressed = false
                        self?.message = "Successfully saved data. You are still a guest, create a password to save your account"
                        self?.is_phone_error = false
                        self?.is_uName_error = false
                    }
                    self?.loaded_get_user = false
                    DispatchQueue.main.async { [weak self] in
                        self?.globalFunctions.getUser(token:self?.logged_in_user ?? "None", this_user:nil, curr_user:nil)
                    }
                    DispatchQueue.main.async { [weak self] in
                        self?.userData = UserViewModel(self?.userViewModel ?? Data())
                        self?.setPageData(usersData: (self?.userData)!)
                    }
                }
                catch{
                    do {
                        let response2 = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                        if self?.check_errors_function(state: Error_States.Invalid_Username, _phone_number: self?.phone_number ?? "", uName: self?.username ?? "") == false{
                            self?.save_pressed = false
                            self?.gsave_pressed = false
                            return
                        }
                        else {
                            self?.save_pressed = false
                            self?.gsave_pressed = false
                            self?.is_phone_error = false
                            self?.is_uName_error = false
                        }
                    }
                    catch{
                        print(error)
                    }
                }
            }

        })
        task.resume()
    }
    
    func check_errors_function(state:Error_States, _phone_number:String, uName:String) -> Bool{
        var result = globalFunctions.check_errors(state: state, _phone_number: _phone_number, uName: uName, p1: "", p2:"")
        if (result == "Required"){
            is_uName_error = true
            username_error = Error_States.Required
            save_pressed = false
            return false
        }
        else if (result == "Invalid_Username"){
            is_uName_error = true
            username_error = Error_States.Invalid_Username
            save_pressed = false
            return false
        }
        else if (result == "NMP"){
            phone_error = Error_States.Invalid_Phone_Number
            is_phone_error = true
            save_pressed = false
            return false
        }
        return true
    }
    
    struct Response2:Codable {
        let response: String
    }
    
    func save_password(){
        save_p_pressed = true
        is_match_error = false
        is_error = false
        psaved = false
        
        var url_string:String = ""
        
        if debug ?? true{
            print("DEBUG IS TRUE")
            url_string = "http://127.0.0.1:8000/tapcoinsapi/user/change_password"
        }
        else{
            print("DEBUG IS FALSE")
            url_string = "https://tapcoin1.herokuapp.com/tapcoinsapi/user/change_password"
        }
        
        guard let url = URL(string: url_string) else{
            return
        }
        var request = URLRequest(url: url)

        if password != cpassword{
            is_match_error = true
            is_password_error = false
            save_p_pressed = false
            return
        }
        
        if password == ""{
            is_password_error = true
            is_match_error = false
            save_p_pressed = false
            return
        }

        guard let session = logged_in_user else{
            return
        }
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: AnyHashable] = [
            "code": "SAVE",
            "password": password,
            "token": session
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)

        let task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }

            DispatchQueue.main.async {
                do {
                    let response = try JSONDecoder().decode(Response3.self, from: data)
                    if response.response{
                        self?.psaved = true
                        self?.save_p_pressed = false
                        self?.userData?.is_guest = false
                        self?.userViewModel = self?.userData?.storageValue
                    }
                    else{
                        let errorType = Error_Types.allCases.first(where: { $0.index == response.error_type })
                        if errorType == Error_Types.BlankPassword{
                            self?.is_error = true
                            self?.error = "Password can't be blank."
                        }
                        if errorType == Error_Types.PreviousPassword{
                            self?.is_error = true
                            self?.error = "Password can't be previous password."
                        }
                        if errorType == Error_Types.SomethingWentWrong{
                            self?.is_error = true
                            self?.error = "Something went wrong."
                        }
                        if errorType == Error_Types.TimeLimitCode{
                            self?.is_error = true
                            self?.error = "Invalid code."
                        }
                    }
                }
                catch{
                    self?.is_error = true
                    self?.error = "Something went wrong!"
                }
                self?.save_p_pressed = false
            }

        })
        task.resume()
    }
    
    struct Response3:Codable {
        let response: Bool
        let message: String
        let error_type: Int
    }
    
    func confirm_password(){
        pressed_confirm_password = true
        save_p_pressed = true
        confirm_password_error = false
        var url_string:String = ""
        
        if debug ?? true{
            print("DEBUG IS TRUE")
            url_string = "http://127.0.0.1:8000/tapcoinsapi/user/confirm_password"
        }
        else{
            print("DEBUG IS FALSE")
            url_string = "https://tapcoin1.herokuapp.com/tapcoinsapi/user/confirm_password"
        }
        
        guard let url = URL(string: url_string) else{
            return
        }
        var request = URLRequest(url: url)
        
        guard let session = logged_in_user else{
            return
        }
        if password == ""{
            pressed_confirm_password = false
            save_p_pressed = false
            confirm_password_error = true
            return
        }
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: AnyHashable] = [
            "token": session,
            "password": password
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)

        let task = URLSession.shared.dataTask(with: request, completionHandler: {[weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            DispatchQueue.main.async {
                do {
                    let response = try JSONDecoder().decode(ResponseCP.self, from: data)
                    if response.result{
                        self?.pressed_confirm_password = false
                        self?.save_p_pressed = false
                        self?.confirmed_current_password = true
                    }
                    else{
                        self?.confirm_password_error = true
                        self?.pressed_confirm_password = false
                        self?.save_p_pressed = false
                    }
                }
                catch{
                    print(error)
                }
            }
        })
        task.resume()
    }
    struct ResponseCP:Codable {
        let result:Bool
    }

}
