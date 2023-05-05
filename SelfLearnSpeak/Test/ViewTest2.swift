//
//  ViewTest2.swift
//  SelfLearnSpeak
//
//  Created by chenzhizs on 2023/05/01.
//

import SwiftUI

struct ViewTest2: View {
    @StateObject var viewModel = ViewModelRecord()
    var body: some View {
        VStack {
            Text(viewModel.state.titleString).font(.title)
            Text(viewModel.text)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            Button(action: {
                if viewModel.state.isRecording {
                    viewModel.stop()
                } else {
                    do {
                        try viewModel.record()
                    } catch {
                        debugPrint(error.localizedDescription)
                    }
                }
            }, label: {
                Image(systemName: viewModel.state.isRecording ? "pause.circle" : "record.circle")
                    .resizable().scaledToFit()
                    .frame(width: 50, height: 50)
            })
        }
        .padding()
        .onAppear {
            viewModel.requestAuthorization()
            viewModel.locale = "ja-JP"
        }
    }
}

//struct ViewTest2_Previews: PreviewProvider {
//    static var previews: some View {
//        ViewTest2(inputText: .constant("テスト"))
//    }
//}
