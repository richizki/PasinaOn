//
//  FloatingAddButton.swift
//  PasinaOn
//
//  Created by Rizki Fitriani on 15/06/26.
//

import SwiftUI

struct FloatingAddButton: View {

    var body: some View {

        Image(systemName: "plus")
            .font(.title2)
            .foregroundStyle(.white)
            .frame(width: 56, height: 56)
            .background(AppColor.primary)
            .clipShape(Circle())
    }
}

#Preview {
    FloatingAddButton()
}
