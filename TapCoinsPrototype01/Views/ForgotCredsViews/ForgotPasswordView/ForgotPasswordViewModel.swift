//
//  ForgotPasswordViewModel.swift
//  TapCoinsPrototype01
//
//  Created by Eric Viera on 2/18/24.
//

import Foundation
import SwiftUI

final class ForgotPasswordViewModel: ObservableObject {
    @AppStorage("debug") private var debug: Bool?
    @Published var phone_number:String = ""
    @Published var code:String = ""
    @Published var password:String = ""
    @Published var c_password:String = ""
    @Published var error:String = ""
    @Published var send_pressed:Bool = false
    @Published var is_phone_error = false
    @Published var is_error = false
    @Published var is_match_error = false
    @Published var is_password_error = false
    @Published var successfully_sent = false
    @Published var submitted = false
    private var globalFunctions = GlobalFunctions()
    
    func send_code(){
        send_pressed = true
        is_phone_error = false
        successfully_sent = false
        submitted = false
        
        var url_string:String = ""
        
        if debug ?? true{
            print("DEBUG IS TRUE")
            url_string = "http://127.0.0.1:8000/tapcoinsapi/user/send_code"
        }
        else{
            print("DEBUG IS FALSE")
            url_string = "https://tapcoin1.herokuapp.com/tapcoinsapi/user/send_code"
        }
        
        guard let url = URL(string: url_string) else{
            return
        }
        var request = URLRequest(url: url)
        
        if phone_number == ""{
            is_phone_error = true
            send_pressed = false
            successfully_sent = false
            submitted = false
            return
        }
        
        if self.globalFunctions.check_errors(state: Error_States.Invalid_Phone_Number, _phone_number: phone_number, uName: "", p1: "", p2: "") == "PHError" {
            is_phone_error = true
            send_pressed = false
            successfully_sent = false
            return
        }
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: AnyHashable] = [
            "phone_number": phone_number,
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                do {
                    let response = try JSONDecoder().decode(Response.self, from: data)
                    if response.response{
                        self?.successfully_sent = true
                        self?.send_pressed = false
                    }
                    else{
                        self?.is_phone_error = true
                    }
                }
                catch{
                    print("Something went wrong.")
                }
                self?.send_pressed = false
            }
        })
        task.resume()
    }
    
    func submit(){
        send_pressed = true
        is_error = false
        is_match_error = false
        submitted = false
        
        var request:URLRequest = URLRequest(url: URL(string: "")!)
        if debug ?? true{
            print("DEBUG IS TRUE")
            guard let url = URL(string: "http://127.0.0.1:8000/tapcoinsapi/user/change_password") else{
                return
            }
            request = URLRequest(url: url)
        }
        else{
            print("DEBUG IS FALSE")
            guard let url = URL(string: "https://tapcoin1.herokuapp.com/tapcoinsapi/user/change_password") else{
                return
            }
            request = URLRequest(url: url)
        }
        
        if password != c_password{
            is_match_error = true
            is_password_error = false
            send_pressed = false
            return
        }
        
        if password == "" {
            is_password_error = true
            is_match_error = false
            send_pressed = false
            return
        }
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: AnyHashable] = [
            "code": code,
            "password": password
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                do {
                    let response = try JSONDecoder().decode(Response2.self, from: data)
                    if response.response{
                        if response.expired{
                            self?.is_error = true
                            self?.error = "Expired code."
                        }
                        else{
                            self?.submitted = true
                            self?.send_pressed = false
                        }
                    }
                    else{
                        let errorType = Error_Types.allCases.first(where: { $0.index == response.error_type })
                        if errorType == Error_Types.BlankPassword{
                            self?.is_error = true
                            self?.error = response.message
                        }
                        if errorType == Error_Types.PreviousPassword{
                            self?.is_error = true
                            self?.error = response.message
                        }
                        if errorType == Error_Types.SomethingWentWrong{
                            self?.is_error = true
                            self?.error = response.message
                        }
                        if errorType == Error_Types.TimeLimitCode{
                            self?.is_error = true
                            self?.error = response.message
                        }
                    }
                }
                catch{
                    self?.is_error = true
                    self?.error = "Something went wrong!"
                }
                self?.send_pressed = false
            }
        })
        task.resume()
    }
    
    struct Response:Codable {
        let response: Bool
        let code: String
        let message:String
    }
    
    struct Response2:Codable {
        let response: Bool
        let message: String
        let expired: Bool
        let error_type: Int
    }
}
