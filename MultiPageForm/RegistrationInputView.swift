//
//  ContentView.swift
//  MultiPageForm
//
//  Created by Jonathon Albert on 20/10/2022.
//

import SwiftUI

enum RegistrationInputType {
    case name
    case username
    case profileImage

    var title: String {
        switch self {
        case .name:
            return "What's your name?\nWe don't like bots around these parts 🤖"
        case .username:
            return "Enter a username!\nSo your friends can find you 🕵️"
        case .profileImage:
            return "☝️\nPick a profile image!\nYou don't want to use the default image, trust us 😏"
        }
    }

    var placeholder: String {
        switch self {
        case .name:
            return "Name"
        case .username:
            return "Username"
        case .profileImage:
            return ""
        }
    }
}

enum ImageState {
    case empty
    case loading(Progress)
    case success(Image)
    case failure(Error)
}

struct RegistrationInputView<Content: View>: View {

    @Binding var isPresented: Bool
    @Binding var progress: Int

    var type: RegistrationInputType
    var nextView: Content

    @StateObject var viewModel = RegistrationInputViewModel()

    @State var textInput: String = ""

    var inputIsValid: Bool {
        switch type {
        case .name, .username:
            return !textInput.isEmpty
        case .profileImage:
            return viewModel.imageSelection != nil
        }
    }

    var body: some View {
        GeometryReader { geoProxy in
            ZStack {
                Color.orange.opacity(0.2)
                    .ignoresSafeArea()

                VStack(spacing: 32.0) {

                    switch type {
                    case .name, .username:
                        EmptyView()
                    case .profileImage:
                        EditableCircularProfileImage(viewModel: viewModel)
                    }

                    Text(type.title)
                        .font(.title)
                        .fontWeight(.heavy)
                        .padding(.horizontal)
                        .multilineTextAlignment(.center)

                    switch type {
                    case .name, .username:
                        TextField(type.placeholder, text: $textInput)
                            .textContentType(.username)
                            .textFieldStyle(PrimaryTextFieldStyle())
                            .frame(width: geoProxy.size.width * 0.8)
                    case .profileImage:
                        EmptyView()
                    }

                    if nextView is EmptyView {
                        Text("Done")
                            .frame(width: geoProxy.size.width * 0.8)
                            .primaryButtonStyle(enabled: inputIsValid)
                            .onTapGesture {
                                isPresented.toggle()
                            }
                            .disabled(!inputIsValid)
                    } else {
                        NavigationLink {
                            nextView
                        } label: {
                            Text("Next")
                                .frame(width: geoProxy.size.width * 0.8)
                                .primaryButtonStyle(enabled: inputIsValid)
                        }
                        .disabled(!inputIsValid)
                    }

                    Button("Cancel") {
                        isPresented.toggle()
                    }
                    .foregroundColor(.orange)
                    .fontWeight(.bold)
                    .frame(height: 60.0)
                    .frame(width: geoProxy.size.width * 0.8)
                }
                .padding(.horizontal)
            }
        }
        .onAppear {
            withAnimation(.easeIn(duration: 0.5)) {
                progress += 1
            }
        }
        .navigationBarBackButtonHidden(true)
        .interactiveDismissDisabled()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RegistrationInputView(isPresented: .constant(true),
                                  progress: .constant(3),
                                  type: .profileImage,
                                  nextView: EmptyView())
            RegistrationInputView(isPresented: .constant(true),
                                  progress: .constant(3),
                                  type: .username,
                                  nextView: EmptyView())
            RegistrationInputView(isPresented: .constant(true),
                                  progress: .constant(3),
                                  type: .name,
                                  nextView: EmptyView())
        }

    }
}
