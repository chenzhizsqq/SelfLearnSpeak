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
            ViewTest()
            
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
