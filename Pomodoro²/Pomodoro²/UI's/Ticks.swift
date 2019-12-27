//
//  Ticks.swift
//  Pomodoro²
//
//  Created by Sai Kambampati on 12/23/19.
//  Copyright © 2019 Sai Kambampati. All rights reserved.
//

import SwiftUI

struct Ticks: View {
    var body: some View {
        Circle()
            .strokeBorder(style: StrokeStyle(lineWidth: 15, dash: [3]))
            .foregroundColor(.primary)
            .opacity(0.25)
    }
}

struct Ticks_Previews: PreviewProvider {
    static var previews: some View {
        Ticks()
    }
}
