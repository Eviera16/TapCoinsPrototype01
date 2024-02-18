//
//  UserViewModel.swift
//  TapCoinsPrototype01
//
//  Created by Eric Viera on 2/18/24.
//

import Foundation
import SwiftUI

struct UserViewModel: Codable {
    var first_name: String
    var last_name: String
    var response: String?
    var username: String?
    var phone_number: String?
    var friends:Array<String>?
    var active_friends_index_list:Array<Int>?
    var hasInvite:Bool?
    var wins: Int?
    var losses: Int?
    var win_streak: Int?
    var best_streak: Int?
    var numFriends: Int?
    var fArrayCount: Int?
    var league: Int?
    var hasST: Bool?
    var hasRQ: Bool?
    var hasGI: Bool?
    var hasPhoneNumber: Bool?
    var is_guest: Bool?
    var has_wallet: Bool?
    var has_security_questions: Bool?
}

// Conform the struct to UserDefaultsStorable
extension UserViewModel {
    init?(_ storageValue: Data) {
        if let decoded = try? JSONDecoder().decode(UserViewModel.self, from: storageValue) {
            self = decoded
        } else {
            return nil
        }
    }

    var storageValue: Data {
        if let encoded = try? JSONEncoder().encode(self) {
            return encoded
        } else {
            fatalError("Failed to encode MyData")
        }
    }
}

struct TableUserModel: Identifiable {
    var username:String
    var id: String {
        username
    }
    var wins:Int
    var losses:Int
    var win_percentage:Int
    var total_games:Int
    var league: Int
}
struct TableUserModelCodable: Codable {
    var username:String?
    var wins:Int?
    var losses:Int?
    var win_percentage:Int?
    var total_games:Int?
    var league: Int?
}
