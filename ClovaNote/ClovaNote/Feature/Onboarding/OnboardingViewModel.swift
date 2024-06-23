//
//  OnboardingViewModel.swift
//  ClovaNote
//
//  Created by 장석우 on 6/24/24.
//

import Foundation

class OnboardingViewModel: ObservableObject {
    @Published var onboardingContents: [OnboardingContent]
    
    init(
        onboardingContents: [OnboardingContent] =
        [
            .init(imageFileName: "onboarding-0",
                  title: "오늘의 할일",
                  subtitle: "언제 어디서든 한눈에"),
            .init(imageFileName: "onboarding-1",
                  title: "똑똑한 나만의 기록장",
                  subtitle: "메모장으로 생각나는 기록은 언제든지"),
            .init(imageFileName: "onboarding-2",
                  title: "하나라도 놓치지 않도록",
                  subtitle: "음성메모 기능으로 놓치고 싶지 않은 기록까지"),
            .init(imageFileName: "onboarding-3",
                  title: "정확한 시간의 경과",
                  subtitle: "타이머 기능으로 원하는 시간을 혹인")
        ]
    ) {
        self.onboardingContents = onboardingContents
    }
    
    
}
