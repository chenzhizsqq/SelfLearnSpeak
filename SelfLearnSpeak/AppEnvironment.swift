//
//  AppEnvironment.swift
//  SelfLearnSpeak
//
//  Created by chenzhizs on 2023/05/02.
//

import Foundation

class AppEnvironment {
    static var dataArray = MyDataArray()
    
    static func addMyData(_ myData: MyData) {
        dataArray.addMyData(myData)
    }
    
    
    static func addInitialData() {
        let dataArray = [
            MyData(string: "ja-JP", VoiceLanguag: "ja-JP"),
            MyData(string: "zh-CN", VoiceLanguag: "zh-CN")
        ]
        
        for data in dataArray {
            addMyData(data)
        }
    }
}

struct MyData: Identifiable {
    var id = UUID()
    var string: String          //key
    let VoiceLanguag: String    //AVSpeechSynthesisVoice(language: languageCode)
}

class MyDataArray {
    private var data = [String: MyData]()
    
    subscript(key: String) -> MyData? {
        get {
            return data[key]
        }
        set(newValue) {
            data[key] = newValue
        }
    }
    
    func addMyData(_ myData: MyData) {
        data[myData.string] = myData
    }
}
