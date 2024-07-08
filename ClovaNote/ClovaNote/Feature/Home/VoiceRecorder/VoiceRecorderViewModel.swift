//
//  VoiceRecorderViewModel.swift
//  ClovaNote
//
//  Created by 장석우 on 7/2/24.
//

import AVFoundation

class VoiceRecorderViewModel: NSObject, ObservableObject, AVAudioPlayerDelegate {
  @Published var isDisplayRemoveVoiceRecoderAlert: Bool
  @Published var isDisplayErrorAlert: Bool
  @Published var errorAlertMessage: String
  
  // 음성 메모 녹음 관련 프로퍼티
  var audioRecorder: AVAudioRecorder?
  @Published var isRecording: Bool
  
  
  // 음성 메모 재생 관련 프로퍼티
  var audioPlayer: AVAudioPlayer?
  @Published var isPlaying: Bool
  @Published var isPaused: Bool
  @Published var playedTime: TimeInterval
  private var progressTimer: Timer?
  
  //음성메모된 파일
  var recordedFiles: [URL]
  
  // 현재 선택된 음성메모 파일
  @Published var selectedRecordedFile: URL?
  
  init(
    isDisplayRemoveVoiceRecoderAlert: Bool = false,
    isDisplayErrorAlert: Bool = false,
    errorAlertMessage: String = "",
    isRecording: Bool = false,
    isPlaying: Bool = false,
    isPaused: Bool = false,
    playedTime: TimeInterval = 0,
    recordedFiles: [URL] = []
  ) {
    self.isDisplayRemoveVoiceRecoderAlert = isDisplayRemoveVoiceRecoderAlert
    self.isDisplayErrorAlert = isDisplayErrorAlert
    self.errorAlertMessage = errorAlertMessage
    
    self.isRecording = isRecording
    
    self.isPlaying = isPlaying
    self.isPaused = isPaused
    self.playedTime = playedTime
    
    self.recordedFiles = recordedFiles
    
    let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    do {
      let fileURLs = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil)
      for file in fileURLs {
        print(file)
        try FileManager.default.removeItem(at: file)
      }
    } catch {
      print("컨텐츠 삭제에서 오류 발생")
    }
  }
}

extension VoiceRecorderViewModel {
  func voiceRecorderCellDidTap(_ recordedFile: URL) {
    print("🌿", #function)
    print("눌림: \(recordedFile)")
    if selectedRecordedFile != recordedFile {
      stopPlaying()
      selectedRecordedFile = recordedFile
    }
  }
  
  func removeButtonDidTap() {
    print("🌿", #function)
    setIsDisplayRemoveVoiceRecorderAlert(true)
  }
  
  func removeSelectedVoiceRecord() {
    print("🌿", #function)
    guard let fileToRemove = selectedRecordedFile,
          let indexToRemove = recordedFiles.firstIndex(of: fileToRemove)
    else {
      displayAlert("선택된 음성메모 파일을 찾을 수 없습니다.")
      return
    }
    
    do {
      try FileManager.default.removeItem(at: fileToRemove)
      recordedFiles.remove(at: indexToRemove)
      selectedRecordedFile = nil
      stopPlaying()
      displayAlert("선택된 음성메모 파일을 성공적으로 삭제했슴.")
    } catch {
      displayAlert("선택된 음성메모 파일 삭제 중 오류가 발생했습니다.")
    }
    
    
  }
  
  private func setIsDisplayRemoveVoiceRecorderAlert(_ isDisplay: Bool) {
    print("🌿", #function)
    DispatchQueue.main.async {
      self.isDisplayRemoveVoiceRecoderAlert = isDisplay
    }
  }
  
  private func setErrorAlertMessage(_ msg: String) {
    DispatchQueue.main.async {
      print("🌿", #function)
      self.errorAlertMessage = msg
    }
    
  }
  
  private func setIsDisplayErrorAlert(_ isDisplay: Bool) {
    print("🌿", #function)
    DispatchQueue.main.async {
      self.isDisplayErrorAlert = isDisplay
    }
  }
  
  private func displayAlert(_ msg: String) {
    print("🌿", #function)
    self.setErrorAlertMessage(msg)
    self.setIsDisplayErrorAlert(true)
  }
  
}

//MARK: - 음성 메모 녹음 관련
extension VoiceRecorderViewModel {
  func recordButtonDidTap() {
    print("🌿", #function)
    selectedRecordedFile = nil
    
    if isPlaying {
      stopPlaying()
      startRecording()
    } else if isRecording {
      stopRecording()
    } else {
      startRecording()
    }
  }
  
  
  private func startRecording() {
    print("🌿", #function)
    let fileURL = getDocumentsDirectory().appendingPathComponent("새로운 녹음 \(recordedFiles.count + 1)")
    let settings = [
      AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
      AVSampleRateKey: 12000,
      AVNumberOfChannelsKey: 1,
      AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
    ]
    
    do {
      audioRecorder = try AVAudioRecorder(url: fileURL, settings: settings)
      audioRecorder?.record()
      self.isRecording = true
    } catch {
      displayAlert("음성메모 녹음 중 오류가 발생")
    }
  }
  
  private func stopRecording() {
    print("🌿", #function)
    audioRecorder?.stop()
    self.recordedFiles.append(self.audioRecorder!.url)
    self.isRecording = false
    
  }
  
  private func getDocumentsDirectory() -> URL {
    print("🌿", #function)
    print("🙏🙏🙏🙏🙏🙏🙏🙏🙏🙏🙏🙏🙏🙏🙏")
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    print("경로",paths[0])
    do {
      let files = try FileManager.default.contentsOfDirectory(atPath: paths[0].path())
      print(files)
    } catch {
      print("콘텐츠가 없습니다.")
    }
    print("🙏🙏🙏🙏🙏🙏🙏🙏🙏🙏🙏🙏🙏🙏🙏")
    return paths[0]
  }
}

//MARK: - 음성 메모 재생 관련

extension VoiceRecorderViewModel {
  
  func startPlaying(recordingURL: URL) {
    print("🌿", #function)
    do {
      audioPlayer = try AVAudioPlayer(contentsOf: recordingURL)
      audioPlayer?.delegate = self
      audioPlayer?.play()
      audioPlayer?.volume = 1.0
      self.isPlaying = true
      self.isPaused = false
      self.progressTimer?.invalidate()
      self.progressTimer = nil
      self.progressTimer = Timer.scheduledTimer(
        withTimeInterval: 0.1,
        repeats: true
      ) { [weak self] _ in
        self?.updateCurrentTime()
      }
    } catch {
      displayAlert("음성 메모 재생 중 오류가 발생했습니다.")
    }
  }
  
  private func updateCurrentTime() {
    self.playedTime = audioPlayer?.currentTime ?? 0
    print("🌿", #function, self.playedTime)
  }
  
  private func stopPlaying() {
    print("🌿", #function)
    audioPlayer?.stop()
    playedTime = 0
    self.progressTimer?.invalidate()
    self.progressTimer = nil
    self.isPlaying = false
    self.isPaused = false
  }
  
  func pausePlaying() {
    print("🌿", #function)
    audioPlayer?.pause()
    isPaused = true
  }
  
  func resumPlaying() {
    print("🌿", #function)
    audioPlayer?.play()
    self.isPaused = false
  }
  
  func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
    print("🌿", #function)
    self.isPlaying = false
    self.isPaused = false
    stopPlaying()
  }
  
  func getFileInfo(for url: URL) -> (Date?, TimeInterval?) {
      print("🌿", #function)
      let fileManager = FileManager.default
      var creationDate: Date?
      var duration: TimeInterval?
      
      // 파일 존재 확인
      guard fileManager.fileExists(atPath: url.path) else {
          displayAlert("파일이 존재하지 않습니다.")
          return (nil, nil)
      }
      
      // 파일 속성 가져오기
      do {
        let fileAttributes = try fileManager.attributesOfItem(atPath: url.path)
          creationDate = fileAttributes[.creationDate] as? Date
      } catch {
          displayAlert("선택된 음성메모 파일 정보를 불러올 수 없습니다.")
      }
      
      // 파일 재생 시간 가져오기
      do {
          let audioPlayer = try AVAudioPlayer(contentsOf: url)
          duration = audioPlayer.duration
      } catch {
          displayAlert("재생 시간 불러올 수 없습니다.")
      }
      
    print("creationDate:", creationDate?.formattedVoiceRecorderTime ?? "없음")
    print("duration:", duration?.formattedTimeInterval ?? "없음")
      return (creationDate, duration)
  }
  
//  func getFileInfo(for url: URL) -> (Date?, TimeInterval?) {
//    print("🌿", #function)
//    let fileManager = FileManager.default
//    var creationDate: Date?
//    var duration: TimeInterval?
//    
//    do {
//      let fileAttributes = try fileManager.attributesOfItem(atPath: url.path)
//      
//      creationDate = fileAttributes[.creationDate] as? Date
//    } catch {
//      displayAlert("선택된 음성메모 파일 정보를 불러올 수 없습니다.")
//    }
//    
//    do {
//      let audioPlayer = try AVAudioPlayer(contentsOf: url)
//      duration = audioPlayer.duration
//    } catch {
//      displayAlert("재생 시간 불러올 수 없습니다.")
//    }
//    
//    print("creationDate:", creationDate)
//    print("duration", duration)
//    return (creationDate, duration)
//  }
//  
//  
  
  
  
  
}
