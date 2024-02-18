//
//  PMenuViewModel.swift
//  TapCoinsPrototype01
//
//  Created by Eric Viera on 2/18/24.
//

import Foundation
import SwiftUI

final class PMenuViewModel: ObservableObject{
    @AppStorage("pGame") var pGame: String?
    
    func got_difficulty(diff:String){
        pGame = diff
    }
}
