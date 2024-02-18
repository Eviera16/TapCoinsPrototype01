//
//  ForgotUsernameView.swift
//  TapCoinsPrototype01
//
//  Created by Eric Viera on 2/18/24.
//

import Foundation
import SwiftUI

struct ForgotUsernameView: View {

    @StateObject private var viewModel = ForgotUsernameViewModel()
    @Environment(\.presentationMode) var presentationMode
    var newCustomColorsModel = CustomColorsModel()

    var body: some View {
        ZStack{
            newCustomColorsModel.colorSchemeOne.ignoresSafeArea()
            VStack{
                Spacer()
                VStack{
                    Text("Input the phone number associated with your account and we will send you your username.")
                        .foregroundColor(newCustomColorsModel.colorSchemeThree)
                        .font(.system(size: UIScreen.main.bounds.width * 0.05))
                        .padding()
                }
                Rectangle()
                    .fill(newCustomColorsModel.colorSchemeThree)
                    .frame(width: UIScreen.main.bounds.width * 0.95, height: UIScreen.main.bounds.height * 0.01)
                Form{
                    Section(header: Text("")){
                        TextField("Phone number", text: $viewModel.phone_number)
                        if viewModel.is_phone_error{
                            Label("Invalid phone number", systemImage: "xmark.octagon")
                                .foregroundColor(newCustomColorsModel.colorSchemeFour)
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                if viewModel.successfully_sent{
                    Spacer()
                    Label("Message sent!", systemImage: "checkmark.circle.fill")
                        .foregroundColor(newCustomColorsModel.colorSchemeThree)
                    Text("If you did not see a message please input your phone number again and press send.")
                        .foregroundColor(newCustomColorsModel.colorSchemeThree)
                        .padding()
                    Spacer()
                }
                Button(action: {viewModel.send_pressed ? nil : viewModel.send_username()}, label: {
                    Text("Send")
                        .frame(width: 200, height: 50, alignment: .center)
                        .background(newCustomColorsModel.colorSchemeThree)
                        .foregroundColor(newCustomColorsModel.colorSchemeOne)
                        .cornerRadius(8)
                }).padding()
            }

            if viewModel.send_pressed{
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint:newCustomColorsModel.colorSchemeThree))
                    .scaleEffect(UIScreen.main.bounds.width * 0.01)
            }
        } // ZStack
    }

}
