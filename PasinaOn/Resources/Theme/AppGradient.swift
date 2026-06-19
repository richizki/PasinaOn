//
//  AppGradient.swift
//  PasinaOn
//
//  Created by Rizki Fitriani on 15/06/26.
//

import SwiftUI

enum AppGradient {

    static let primary = LinearGradient(
        colors: [.indigo, .purple],
        startPoint: .leading,
        endPoint: .trailing
    )

    static let blue = LinearGradient(
        colors: [.blue, .indigo],
        startPoint: .leading,
        endPoint: .trailing
    )

    static let orange = LinearGradient(
        colors: [.orange, .red],
        startPoint: .leading,
        endPoint: .trailing
    )
}
