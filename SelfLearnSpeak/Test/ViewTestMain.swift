//
//  ViewTestMain.swift
//  SelfLearnSpeak
//
//  Created by chenzhizs on 2023/05/01.
//

import SwiftUI
import RealmSwift

struct ViewTestMain: View {
    @ObservedRealmObject var themeGroup: ThemeGroup
    
    var body: some View {
        VStack{
            Text("Speech")
            ViewTest(themeGroup: themeGroup)
            
                Text("AVFoundation")
            ViewTest2()
        }
    }
}

//struct ViewTestMain_Previews: PreviewProvider {
//    static var previews: some View {
//        ViewTestMain()
//    }
//}
