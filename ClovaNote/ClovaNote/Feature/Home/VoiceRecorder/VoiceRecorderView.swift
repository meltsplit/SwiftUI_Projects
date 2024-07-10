//
//  VoiceRecorderView.swift
//  ClovaNote
//
//  Created by 장석우 on 7/2/24.
//

import SwiftUI

struct VoiceRecorderView: View {
  
  @StateObject private var viewModel = VoiceRecorderViewModel()
  @EnvironmentObject private var homeViewModel: HomeViewModel
  @State private var isAnimation: Bool
  
  init(isAnimation: Bool = false) {
    
    self.isAnimation = isAnimation
  }
  
  var body: some View {
    ZStack {
      VStack {
        TitleView()
        
        
        Spacer()
        
        if viewModel.recordedFiles.isEmpty {
          GuideView()
        } else {
          VoiceRecorderListView(viewModel: viewModel)
        }
        
        Spacer()
        
      }
      
      VStack {
        Spacer()
        HStack {
          Spacer()
          Button(
            action: { viewModel.recordButtonDidTap() },
            label: {
              if viewModel.isRecording {
                Image(.recordFail)
                  .scaleEffect(isAnimation ? 1.5 : 1)
                  .onAppear {
                    withAnimation(.spring.repeatForever()) {
                      isAnimation.toggle()
                    }
                  }
                  .onDisappear {
                    isAnimation = false
                  }
              } else {
                Image(.record)
              }
              
            }
          )
        }.padding(.trailing, 30)
      }.padding(.bottom, 30)
      
      
    }
    .alert(
      "선택된 음성메모를 삭제하시겠습니까?",
      isPresented: $viewModel.isDisplayRemoveVoiceRecoderAlert
    ) {
      Button("삭제", role: .destructive) {
        viewModel.removeSelectedVoiceRecord()
      }
      Button("취소", role: .cancel) { }
    }
    .alert(
      viewModel.errorAlertMessage,
      isPresented: $viewModel.isDisplayErrorAlert
    ) {
      Button("확인", role: .cancel) { }
    }
    .onChange(of: viewModel.recordedFiles.count) { _, newValue in
      homeViewModel.setVoiceRecorderCount(newValue)
    }

  }
}


private struct TitleView: View {
  
  fileprivate var body: some View {
    HStack {
      Text("음성메모")
        .font(.system(size: 30))
        .bold()
      Spacer()
    }
    .padding(.horizontal, 30)
    .padding(.vertical, 30)
  }
}

private struct GuideView: View {
  
  fileprivate var body: some View {
    VStack {
      Image(systemName: "pencil")
      
      Spacer()
        .frame(height: 20)
      
      Text("현재 등록된 음성메모가 없습니다")
      
      Text("하단의 녹음버튼을 눌러 음성메모를 시작해주세요.")
    }
    .font(.system(size: 14))
    .foregroundStyle(.gray2)
    
  }
}

private struct VoiceRecorderListView: View {
  
  @ObservedObject var viewModel: VoiceRecorderViewModel
  
  fileprivate var body: some View {
    
    ScrollView {
      VStack {
        ForEach(viewModel.recordedFiles, id: \.self) { file in
          VoiceRecorderCellView(
            viewModel: viewModel,
            recordedFile: file
          )
        }
      }
    }
    
    
  }
}

private struct VoiceRecorderCellView: View {
  
  @ObservedObject var viewModel: VoiceRecorderViewModel
  
  private var recordedFile: URL
  private var creationDate: Date?
  private var duration: TimeInterval?
  
  init(
    viewModel: VoiceRecorderViewModel,
    recordedFile: URL
  ) {
    self.viewModel = viewModel
    self.recordedFile = recordedFile
    (self.creationDate, self.duration) = viewModel.getFileInfo(for: recordedFile)
  }
  
  fileprivate var body: some View {
    Button(
      action: { viewModel.voiceRecorderCellDidTap(recordedFile)},
      label: {
        VStack {
          HStack {
            Text(recordedFile.lastPathComponent)
              .font(.system(size: 14, weight: .bold))
            
            Spacer()
          }
          
          Spacer()
            .frame(height: 4)
          
          HStack {
            
            if let creationDate = creationDate {
              Text(creationDate.formattedVoiceRecorderTime)
                .font(.system(size: 14))
                .foregroundStyle(.iconOn)
            }
            
            
            Spacer()
            
            if let duration = duration {
              Text(duration.formattedTimeInterval)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.iconOn)
            }
          }
          
          
          if viewModel.selectedRecordedFile == recordedFile {
            VoiceRecorderCellProgressView(
              viewModel: viewModel,
              recordedFile: recordedFile,
              duration: duration
            )
          }
        }
        
      })
    .padding(.horizontal, 30)
    .padding(.vertical, 30)
  }
}


private struct VoiceRecorderCellProgressView: View {
  
  @ObservedObject var viewModel: VoiceRecorderViewModel
  private var recordedFile: URL
  private var progressValue: Float {
    if viewModel.selectedRecordedFile == recordedFile
        && (viewModel.isPlaying || viewModel.isPaused) {
      return Float(viewModel.playedTime) / Float(duration ?? 1)
    } else {
      return 0
    }
  }
  private var duration: TimeInterval?
  
  
  fileprivate init(
    viewModel: VoiceRecorderViewModel,
    recordedFile: URL,
    duration: TimeInterval?
  ) {
    self.viewModel = viewModel
    self.recordedFile = recordedFile
    self.duration = duration
  }
  
  fileprivate var body: some View {
    
    VStack {
      
      ProgressView(value: progressValue)
      
      Spacer()
        .frame(height: 5)
      
      HStack {
        Text(viewModel.playedTime.formattedTimeInterval)
        Spacer()
        if let duration = duration {
          Text(duration.formattedTimeInterval)
        }
        
      }
      .font(.system(size: 10))
      .foregroundStyle(.iconOn)
      
      Spacer()
        .frame(height: 15)
      
      ZStack {
        HStack {
          Button(
            action: { if viewModel.isPaused {
              viewModel.resumPlaying()
            } else {
              viewModel.startPlaying(recordingURL: recordedFile)
            }  },
            label: { Image(systemName: "play.fill") }
          )
          
          Spacer()
            .frame(width: 20)
          
          
          Button(
            action: {  if viewModel.isPlaying { viewModel.pausePlaying() }   }, 
            label: { Image(systemName: "pause.fill")
              .renderingMode(.template) }
          )
        }
        
        HStack {
          
          Spacer()
          
          Button(
            action: { viewModel.removeButtonDidTap()  },
            label: { Image(systemName: "trash")  }
          )
        }
        .padding(.horizontal)
        
        
      }.foregroundStyle(.black)
      
      
    }
    .padding(.vertical, 15)
  }
}

#Preview {
  VoiceRecorderView(isAnimation: false)
  
}
