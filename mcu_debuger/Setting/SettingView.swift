//
//  SettingView.swift
//  mcu_debuger
//
//  Created by Taiga Takano on 2024/07/05.
//

import SwiftUI

struct SettingView: View {
    private let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    private let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
    var body: some View {
        Text("\(version)(\(build))")
    }
}

#Preview {
    SettingView()
}
