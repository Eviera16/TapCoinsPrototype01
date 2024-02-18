//
//  HapticsManager.swift
//  TapCoinsPrototype01
//
//  Created by Eric Viera on 2/18/24.
//

import Foundation
import UIKit
import SwiftUI

class HapticManager{
    @AppStorage("haptics") var haptics_on:Bool?
    static let instance = HapticManager()
    func impact(style: UIImpactFeedbackGenerator.FeedbackStyle){
        if (haptics_on ?? true){
            let generator = UIImpactFeedbackGenerator(style: style)
            generator.impactOccurred()
        }
    }
}
