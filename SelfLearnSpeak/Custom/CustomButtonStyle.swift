//
//  CustomButtonStyle.swift
//  SelfLearnSpeak
//
//  Created by chenzhizs on 2023/05/04.
//

import SwiftUI

// MARK: - 选择按钮的模板
struct CustomButtonStyle: ButtonStyle {
    
    var padding: CGFloat
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.all,padding)
            .background(Color.orange)
            .foregroundColor(.white)
            .cornerRadius(8)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}
