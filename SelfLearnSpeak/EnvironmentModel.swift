//
//  EnvironmentModel.swift
//  SelfLearnSpeak
//
//  Created by chenzhizs on 2023/04/20.
//

import SwiftUI
import AVFoundation


//环境变量
class EnvironmentModel:ObservableObject{
    
    static let shared = EnvironmentModel()
    
    //读取文字工具
    let synthesizer = AVSpeechSynthesizer()
    
    func text2speech(_ text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "ja-JP")
//        utterance.voice = AVSpeechSynthesisVoice(identifier: AVSpeechSynthesisVoiceIdentifierAlex)
        utterance.rate = 0.4
//        utterance.pitchMultiplier = 1.0
        
        //声音停止
        synthesizer.stopSpeaking(at: .immediate)
        
        //声音播放
        synthesizer.speak(utterance)
    }
    
    
    func text2speech(_ text: String,language languageCode: String?) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: languageCode)
//        utterance.voice = AVSpeechSynthesisVoice(identifier: AVSpeechSynthesisVoiceIdentifierAlex)
        utterance.rate = 0.4
//        utterance.pitchMultiplier = 1.0
        
        //声音停止
        synthesizer.stopSpeaking(at: .immediate)
        
        //声音播放
        synthesizer.speak(utterance)
    }
    
    
    //realm Version
    @Published var realmVersion = 1
    
}
