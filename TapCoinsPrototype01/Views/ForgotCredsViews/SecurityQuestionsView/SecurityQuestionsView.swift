//
//  SecurityQuestionsView.swift
//  TapCoinsPrototype01
//
//  Created by Eric Viera on 2/18/24.
//

import Foundation
import SwiftUI

struct SecurityQuestionsView: View {
    
    @StateObject private var viewModel = SecurityQuestionsViewModel()
    @Environment(\.presentationMode) var presentationMode
    var newCustomColorsModel = CustomColorsModel()
    
    var body: some View {
        ZStack{
            newCustomColorsModel.colorSchemeThree.ignoresSafeArea()
            VStack{
                Text("Security Questions")
                    .font(.system(size: UIScreen.main.bounds.width * 0.1))
                    .foregroundColor(newCustomColorsModel.customColor_1)
                if viewModel.submit_pressed{
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint:newCustomColorsModel.customColor_1))
                        .scaleEffect(UIScreen.main.bounds.width * 0.01)
                }
                else{
                    Form{
                        if viewModel.username_sent{
                            if viewModel.valid_userename{
                                Section(header: Text("")){
                                    Text(viewModel.question_1)
                                    TextField("Answer here", text: $viewModel.answer_1)
                                    if viewModel.incorrect_answers_errors{
                                        Label("Invalid answer", systemImage: "xmark.octagon")
                                            .foregroundColor(newCustomColorsModel.colorSchemeFour)
                                    }
                                    Text(viewModel.question_2)
                                    TextField("Answer here", text: $viewModel.answer_2)
                                    if viewModel.incorrect_answers_errors{
                                        Label("Invalid answer", systemImage: "xmark.octagon")
                                            .foregroundColor(newCustomColorsModel.colorSchemeFour)
                                    }
                                }
                            }
                            else{
                                Text("No security questions saved for this account.")
                            }
                        }
                        else{
                            Section(header: Text("")){
                                Text("Enter username below.")
                                TextField("Username", text: $viewModel._username)
                                if viewModel.is_error{
                                    Label(viewModel.username_error, systemImage: "xmark.octagon")
                                        .foregroundColor(newCustomColorsModel.colorSchemeFour)
                                }
                            }
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width , height: UIScreen.main.bounds.height * 0.3, alignment: .bottom)
                    .scrollContentBackground(.hidden)
                }
                Button(action: {
                    print("SUBMITTING")
                    if !viewModel.submit_pressed{
                        print("SUBMIT PRESSED IS FALSE")
                        if viewModel._username != ""{
                            print("USERNAME IS NOT BLANK")
                            if viewModel.username_sent{
                                if viewModel.valid_userename{
                                    viewModel.check_answers_to_questions()
                                }
                            }
                            else{
                                print("GOT IN HERE")
                                viewModel.check_if_user_has_questions()
                            }
                        }
                        else{
                            viewModel.is_error = true
                            viewModel.username_error = "Invalid username."
                        }
                    }
                }, label: {
                    Text("Submit")
                        .frame(width: 200, height: 50, alignment: .center)
                        .background(newCustomColorsModel.customColor_1)
                        .foregroundColor(newCustomColorsModel.colorSchemeThree)
                        .cornerRadius(8)
                }).padding()
            }
        }
    }
}
