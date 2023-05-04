//
//  ThemeRow.swift
//  SelfLearnSpeak
//
//  Created by chenzhizs on 2023/05/04.
//

import SwiftUI
import RealmSwift
import AVFoundation

/// Represents an Item in a list.
struct ThemeRow: View {
    @ObservedRealmObject var theme: Theme
    
    ///是否显示第二个页面
    @State private var showSecondItemRowView = false
    
    var body: some View {
        // You can click an item in the list to navigate to an edit details screen.
        VStack{
            HStack{
                
                Text(theme.name)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .onTapGesture {
            showSecondItemRowView = true
        }
        .sheet(isPresented: $showSecondItemRowView, onDismiss: {
            // 在这里添加操作
        }, content: {
            ViewThemeEdit(theme: theme, input_text: $theme.name, showSecondView: $showSecondItemRowView)
        })
    }
}
