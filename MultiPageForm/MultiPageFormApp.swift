//
//  MultiPageFormApp.swift
//  MultiPageForm
//
//  Created by Jonathon Albert on 20/10/2022.
//

import SwiftUI

struct SegmentedProgressView: View {

    var value: Binding<Int>
    var maximum: Int
    var height: CGFloat = 12
    var spacing: CGFloat = 4
    var selectedColor: Color = .orange
    var unselectedColor: Color = Color.secondary.opacity(0.3)

    var body: some View {
        HStack(spacing: spacing) {
            ForEach(0..<maximum, id: \.self) { index in
                Rectangle()
                    .foregroundColor(index < self.value.wrappedValue ? self.selectedColor : self.unselectedColor)
            }
        }
        .frame(maxHeight: height)
        .clipShape(Capsule())
    }
}

struct OnBoardingView: View {

    private struct OnBoardingBuilder {
        static func onBoardingFlow(isPresented: Binding<Bool>, progress: Binding<Int>) -> some View {

            let profileImageForm = RegistrationInputView(isPresented: isPresented,
                                                         progress: progress,
                                                         type: .profileImage,
                                                         nextView: EmptyView())

            let userNameForm = RegistrationInputView(isPresented: isPresented,
                                                     progress: progress,
                                                     type: .username,
                                                     nextView: profileImageForm)

            return RegistrationInputView(isPresented: isPresented,
                                         progress: progress,
                                         type: .name,
                                         nextView: userNameForm)
        }
    }

    @Binding var isPresented: Bool
    @Binding var progressValue: Int

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .center) {
                NavigationStack() {
                    OnBoardingBuilder.onBoardingFlow(isPresented: $isPresented,
                                                     progress: $progressValue)
                }
                SegmentedProgressView(value: $progressValue, maximum: 3)
                    .frame(width: geo.size.width * 0.8)
                    .frame(height: 32)
                    .position(x: geo.size.width / 2, y: geo.size.height * 0.95)
            }
        }
    }
}

struct InitialView: View {

    @State var showProfileDataEntry: Bool = false
    @State var progressValue: Int = 0

    var body: some View {
        ZStack {
            VStack {
                Button("Begin Onboarding") {
                    progressValue = 0
                    showProfileDataEntry.toggle()
                }
            }
        }
        .sheet(isPresented: $showProfileDataEntry) {
            OnBoardingView(isPresented: $showProfileDataEntry,
                           progressValue: $progressValue)
        }
    }
}

@main
struct MultiPageFormApp: App {

    var body: some Scene {
        WindowGroup {
            InitialView()
        }
    }
}
