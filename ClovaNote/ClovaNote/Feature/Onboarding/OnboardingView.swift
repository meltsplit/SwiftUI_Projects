//
//  OnboardingView.swift
//  ClovaNote
//
//  Created by 장석우 on 6/24/24.
//

import SwiftUI

struct OnboardingView: View {
    @StateObject private var onboardingViewModel = OnboardingViewModel()
    @StateObject private var pathModel = PathModel()
    @StateObject private var todoListViewModel = TodoListViewModel()
    
    var body: some View {
        NavigationStack(path: $pathModel.paths) {
//            OnboardingContentView(viewModel: onboardingViewModel)
            TodoListView()
                .environmentObject(todoListViewModel)
                .navigationDestination(for: PathType.self,
                                       destination: { pathType in
                    switch pathType {
                    case .home:
                        HomeView()
                            .navigationBarBackButtonHidden()
                            
                    case .memo:
                        MemoView()
                            .navigationBarBackButtonHidden()
                    case .todo:
                        TodoView()
                            .navigationBarBackButtonHidden()
                            .environmentObject(todoListViewModel)
                        
                    }
                    
                })
        }
        .environmentObject(pathModel)
    }
}

private struct OnboardingContentView: View {
    @ObservedObject private var viewModel: OnboardingViewModel
    
    fileprivate init(viewModel: OnboardingViewModel) {
        self.viewModel = viewModel
    }
    
    fileprivate var body: some View {
        VStack {
            // 온보딩 셀리스트 뷰
            OnboardingCellListView(viewModel: viewModel)
            Spacer()
            StartButtonView()
            // 시작버튼 뷰
        }
        .ignoresSafeArea()
    }
    
}

//MARK: - 온보딩 셀리스트 뷰

private struct OnboardingCellListView: View {
    @ObservedObject private var viewModel: OnboardingViewModel
    @State private var selectedIndex = 0
    
    fileprivate init(
        viewModel: OnboardingViewModel,
        selectedIndex: Int = 0
    ) {
        self.viewModel = viewModel
        self.selectedIndex = selectedIndex
    }
    
    fileprivate var body: some View {
        TabView(selection: $selectedIndex) {
            ForEach(Array(viewModel.onboardingContents.enumerated()), id: \.element) { index, content in
                OnboardingCellView(content: content)
                    .tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 1.5 )
        .background(
            selectedIndex % 2 == 0
            ? .bgSky
            : .bgGreen
        )
        .clipped()
    }
    
    
}

private struct OnboardingCellView: View {
    private var content: OnboardingContent
    
    fileprivate init(content: OnboardingContent) {
        self.content = content
    }
    
    fileprivate var body: some View {
        VStack {
            Image(content.imageFileName)
                .resizable()
                .scaledToFit()
                
            
            HStack {
                Spacer()
                    
                
                VStack {
                    Spacer()
                        .frame(height: 46)
                    
                    Text(content.title)
                        .font(.system(size: 16, weight: .bold))
                    
                    Spacer()
                        .frame(height: 46)
                    
                    Text(content.subtitle)
                        .font(.system(size: 16))
                }
                Spacer()
                    
            }.background(.white)
                
        }
        .shadow(radius: 10)
        
    }
}

//MARK: - 시작 버튼 뷰

private struct StartButtonView: View {
    @EnvironmentObject private var pathModel: PathModel
    
    fileprivate var body: some View {
        Button(
            action: { pathModel.paths.append(.home) },
            label: {
                HStack {
                    Text("시작하기")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(.key)
                    
                    Image(systemName: "arrow.right")
                        .renderingMode(.template)
                        .foregroundStyle(.key)
                }
            }
        )
        .padding(.bottom, 50)
    }
}

#Preview {
    OnboardingView()
}
