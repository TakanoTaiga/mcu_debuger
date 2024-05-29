//
//  ErrorView.swift
//  mcu_debuger
//
//  Created by Taiga on 2024/05/30.
//

import SwiftUI

struct ErrorView: View {
    var body: some View {
        VStack{
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.title)
                .foregroundColor(.yellow)
            Text("Oops!?")
        }
    }
}

#Preview {
    ErrorView()
}
