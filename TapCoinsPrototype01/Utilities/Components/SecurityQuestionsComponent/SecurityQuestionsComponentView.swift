//
//  SecurityQuestionsComponentView.swift
//  TapCoinsPrototype01
//
//  Created by Eric Viera on 2/18/24.
//

import Foundation
import SwiftUI

struct SecurityQuestionsComponentView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = SecurityQuestionsComponentViewModel()
    var newCustomColorsModel = CustomColorsModel()
    var is_settings:Bool
    var body: some View {
        ZStack{
            newCustomColorsModel.colorSchemeThree.ignoresSafeArea()
            if viewModel.saved_questions_answers{
                VStack(alignment: .center){
                    HStack(alignment: .center){
                        Text("Saved Questions and Answers.")
                            .background(newCustomColorsModel.customColor_1)
                    }
                }
            }
            else{
                if viewModel.is_loading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint:newCustomColorsModel.customColor_1))
                        .scaleEffect(UIScreen.main.bounds.width * 0.01)
                }
                else{
                    if is_settings{
                        if viewModel.confirmed_password {
                            ScrollView{
                                VStack(spacing: UIScreen.main.bounds.width * 0.05){
                                    Text("Select two security questions.")
                                        .font(.system(size: UIScreen.main.bounds.width * 0.07))
                                    Text("Security questions will allow you to recover your account in case of a forgoten username or password.")
                                    Text("First Security Question and Answer:")
                                    Picker(selection: $viewModel.question_1, label: Text("Picker1")){
                                        ForEach(0..<5) { index in
                                            Text(viewModel.got_security_questions ? viewModel.options1[index] : String(index))
                                                .lineLimit(nil)
                                                .fixedSize(horizontal: false, vertical: true)
                                                .tag(index)
                                        }
                                    }
                                    .pickerStyle(WheelPickerStyle())
                                    TextField(viewModel.answer_1, text: $viewModel.answer_1)
                                        .frame(width: UIScreen.main.bounds.width * 0.7, height: UIScreen.main.bounds.height * 0.05)
                                        .border(.black, width: UIScreen.main.bounds.width * 0.008)
                                        .background(.white)
                                        .foregroundStyle(Color(.black))
                                    Text("Second Security Question and Answer:")
                                    Picker(selection: $viewModel.question_2, label: Text("Picker2")){
                                        ForEach(0..<5) { index in
                                            Text(viewModel.got_security_questions ? viewModel.options2[index] : String(index))
                                                .lineLimit(nil)
                                                .fixedSize(horizontal: false, vertical: true)
                                                .tag(index)
                                        }
                                    }
                                    .pickerStyle(WheelPickerStyle())
                                    TextField(viewModel.answer_2, text: $viewModel.answer_2)
                                        .frame(width: UIScreen.main.bounds.width * 0.7, height: UIScreen.main.bounds.height * 0.05)
                                        .border(.black, width: UIScreen.main.bounds.width * 0.008)
                                        .background(.white)
                                        .foregroundStyle(Color(.black))
                                    Button(action: {viewModel.pressed_check_and_set_sqs ? nil : viewModel.check_and_set_sqs()}, label: {
                                        Text("Save")
                                            .foregroundStyle(newCustomColorsModel.customColor_1)
                                            .bold(true)
                                    })
                                    .frame(width: UIScreen.main.bounds.width * 0.3, height: UIScreen.main.bounds.height * 0.05, alignment: .center)
                                    .background(newCustomColorsModel.colorSchemeThree)
                                    .cornerRadius(UIScreen.main.bounds.width * 0.02)
                                    Spacer()
                                }
                                .frame(width: UIScreen.main.bounds.width * 0.95, height: UIScreen.main.bounds.height * 0.8, alignment: .center)
                                .background(newCustomColorsModel.customColor_1)
                                .cornerRadius(UIScreen.main.bounds.width * 0.05)
                            }
                        }
                        else{
                            VStack(alignment: .center, spacing: UIScreen.main.bounds.width * 0.05){
                                Text("Confirm Password to edit Security Questions")
                                    .frame(width: UIScreen.main.bounds.width * 0.8, alignment: .center)
                                    .font(.system(size: UIScreen.main.bounds.width * 0.037))
                                    .foregroundColor(newCustomColorsModel.customColor_1)
                                    .bold()
                                    .underline(true)
                                SecureField("Password", text: $viewModel.password)
                                    .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.04, alignment: .center)
                                    .foregroundColor(Color(.black))
                                    .background(Color(.white))
                                if viewModel.password_error {
                                    Label("Invalid Password.", systemImage: "xmark.octagon")
                                        .foregroundColor(newCustomColorsModel.colorSchemeFour)
                                }
                                Button(action: {viewModel.pressed_confirm_password ? nil : viewModel.confirm_password()}, label: {
                                    Text("Confirm")
                                        .frame(width: UIScreen.main.bounds.width * 0.3, height: UIScreen.main.bounds.height * 0.04, alignment: .center)
                                        .background(newCustomColorsModel.customColor_1)
                                        .foregroundColor(newCustomColorsModel.colorSchemeThree)
                                        .fontWeight(.bold)
                                        .cornerRadius(8)
                                }).padding()
                            }
                            .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.25, alignment: .center)
                            .padding(3)
                        }
                    }
                    else{
                        ScrollView{
                            VStack(spacing: UIScreen.main.bounds.width * 0.05){
                                Spacer()
                                Text("Select two security questions.")
                                    .font(.system(size: UIScreen.main.bounds.width * 0.07))
                                Text("Security questions will allow you to recover your account in case of a forgoten username or password.")
                                Text("First Security Question and Answer:")
                                Picker(selection: $viewModel.question_1, label: Text("Picker1")){
                                    ForEach(0..<5) { index in
                                        Text(viewModel.got_security_questions ? viewModel.options1[index] : String(index))
                                            .lineLimit(nil)
                                            .fixedSize(horizontal: false, vertical: true)
                                            .tag(index)
                                    }
                                }
                                .pickerStyle(WheelPickerStyle())
                                TextField(viewModel.answer_1, text: $viewModel.answer_1)
                                    .frame(width: UIScreen.main.bounds.width * 0.7, height: UIScreen.main.bounds.height * 0.05)
                                    .border(.black, width: UIScreen.main.bounds.width * 0.008)
                                    .background(.white)
                                    .foregroundStyle(Color(.black))
                                Text("Second Security Question and Answer:")
                                Picker(selection: $viewModel.question_2, label: Text("Picker2")){
                                    ForEach(0..<5) { index in
                                        Text(viewModel.got_security_questions ? viewModel.options2[index] : String(index))
                                            .lineLimit(nil)
                                            .fixedSize(horizontal: false, vertical: true)
                                            .tag(index)
                                    }
                                }
                                .pickerStyle(WheelPickerStyle())
                                TextField(viewModel.answer_2, text: $viewModel.answer_2)
                                    .frame(width: UIScreen.main.bounds.width * 0.7, height: UIScreen.main.bounds.height * 0.05)
                                    .border(.black, width: UIScreen.main.bounds.width * 0.008)
                                    .background(.white)
                                    .foregroundStyle(Color(.black))
                                HStack{
                                    Button(action: {viewModel.pressed_check_and_set_sqs ? nil : viewModel.check_and_set_sqs()}, label: {
                                        Text("Save")
                                            .foregroundColor(.black)
                                            .bold(true)
                                    })
                                    .frame(width: UIScreen.main.bounds.width * 0.3, height: UIScreen.main.bounds.height * 0.05, alignment: .center)
                                    .background(newCustomColorsModel.colorSchemeSix)
                                    .cornerRadius(UIScreen.main.bounds.width * 0.02)
                                    
                                    Button(action: {
                                        print("Skipping")
                                        viewModel.show_security_questions = false
                                    }, label: {
                                        Text("Skip")
                                            .foregroundColor(.black)
                                            .bold(true)
                                    })
                                    .frame(width: UIScreen.main.bounds.width * 0.3, height: UIScreen.main.bounds.height * 0.05, alignment: .center)
                                    .background(newCustomColorsModel.colorSchemeFive)
                                    .cornerRadius(UIScreen.main.bounds.width * 0.02)
                                }
                                Spacer()
                            }
                            .frame(width: UIScreen.main.bounds.width * 0.95, height: UIScreen.main.bounds.height * 0.8, alignment: .center)
                            .background(newCustomColorsModel.customColor_1)
                            .cornerRadius(UIScreen.main.bounds.width * 0.05)
                        }
                    } // Is Settings Else
                } // Is Loading Else
                
            } // Saved Questions Answers Else

        } // ZStack
    }
}
