//
//  RecordAPI.swift
//  SelfLearnSpeak
//
//  Created by chenzhizs on 2023/05/05.
//

import Foundation

import Speech

enum RecordState: Equatable {
    case notRecording
    case recording(AVAudioInputNode, SFSpeechRecognitionTask)
    
    var isRecording: Bool {
        return self != .notRecording
    }
    
    var titleString: String {
        switch self {
        case .notRecording:
            return "Voice Memo"
        case .recording(_,_):
            return "Recording/Recognizing"
        }
    }
}

@MainActor
class ViewModelRecord: ObservableObject {
    @Published var state: RecordState = .notRecording
    @Published var text: String = ""
    @Published var locale: String = "" //SFSpeechRecognizer的设定语言    SFSpeechRecognizer(locale: Locale(identifier: "ja-JP"))

    let audioSession = AVAudioSession.sharedInstance()
    let audioEngine = AVAudioEngine()
    private var speechRecognizer: SFSpeechRecognizer {
        var recognizer = SFSpeechRecognizer()
        if(!locale.isEmpty){
            recognizer = SFSpeechRecognizer(locale: Locale(identifier: locale))
        }
        guard let recognizer = recognizer else { fatalError("failed to prepare recognizer")}
        recognizer.supportsOnDeviceRecognition = false
        return recognizer
    }

    func requestAuthorization() {
        SFSpeechRecognizer.requestAuthorization {_ in }
    }
    
    func stop() {
        guard SFSpeechRecognizer.authorizationStatus() == .authorized else { return }
        
        if case .recording(let node,let task) = self.state {
            self.audioEngine.stop()
            node.removeTap(onBus: 0)
            task.finish()
            self.state = .notRecording
        }
    }
    
    func record() throws {
        guard SFSpeechRecognizer.authorizationStatus() == .authorized else { return }

        let recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        recognitionRequest.shouldReportPartialResults = true
        recognitionRequest.requiresOnDeviceRecognition = false
        let recognitionTask = self.speechRecognizer.recognitionTask(with: recognitionRequest,
                                                            resultHandler: { (result, error) in
            if let result = result {
                self.text = result.bestTranscription.formattedString
            }
        })

        try self.audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try! self.audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        let inputNode = self.audioEngine.inputNode

        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            recognitionRequest.append(buffer)
        }
        
        audioEngine.prepare()
        try audioEngine.start()
        
        self.state = .recording(inputNode, recognitionTask)
    }
}
