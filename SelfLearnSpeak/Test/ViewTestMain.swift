//
//  ViewTestMain.swift
//  SelfLearnSpeak
//
//  Created by chenzhizs on 2023/05/01.
//

import SwiftUI

struct ViewTestMain: View {
    var body: some View {
        VStack{
            Text("Speech")
            ViewTest(inputText: .constant("福島第一原発事故による帰還困難区域のうち、福島県飯舘村長泥地区の「特定復興再生拠点区域（復興拠点）」と拠点外の一部について、5月1日午前10時に避難指示が解除されました。これで、国が先行して除染を進めている福島県内6つの町と村に設けられた「復興拠点」のすべてで避難指示が解除されました。"))
            
                Text("AVFoundation")
            ViewTest2()
        }
    }
}

struct ViewTestMain_Previews: PreviewProvider {
    static var previews: some View {
        ViewTestMain()
    }
}
