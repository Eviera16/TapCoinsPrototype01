//
//  QueueView.swift
//  TapCoinsPrototype01
//
//  Created by Eric Viera on 2/18/24.
//

import Foundation
import SwiftUI

struct QueueView: View {
    @StateObject private var viewModel = QueueViewModel()
    var newCustomColorsModel = CustomColorsModel()

    var body: some View {
        ZStack{
            newCustomColorsModel.colorSchemeFour.ignoresSafeArea()
            VStack(alignment: .center, spacing: UIScreen.main.bounds.width * 0.2){
                Spacer()
                Text(viewModel.loading_status)
                    .fontWeight(.bold)
                    .font(.system(size: UIScreen.main.bounds.width * 0.11))
                    .foregroundColor(newCustomColorsModel.customColor_1)
                Text(viewModel.queue_pop)
                    .fontWeight(.bold)
                    .font(.system(size: UIScreen.main.bounds.width * 0.08))
                    .foregroundColor(newCustomColorsModel.colorSchemeThree)
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint:newCustomColorsModel.customColor_1))
                    .scaleEffect(UIScreen.main.bounds.width * 0.01)
//                BannerAd(unitID: "ca-app-pub-4507110298752888/4772121312")
                BannerAd(unitID: "ca-app-pub-3940256099942544/2934735716")
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.2)
                Button(action: {
                    viewModel.return_home()
                }, label: {
                    Text("Homee")
                        .frame(width: UIScreen.main.bounds.width * 0.5, height: UIScreen.main.bounds.height * 0.06, alignment: .center)
                        .background(newCustomColorsModel.colorSchemeThree)
                        .foregroundColor(newCustomColorsModel.customColor_1)
                        .cornerRadius(UIScreen.main.bounds.width * 0.05)
                })
                Spacer()
            }
        }
    }
}
