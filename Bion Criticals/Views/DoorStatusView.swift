//
//  DoorStatusView.swift
//  Bion Criticals
//
//  Created by Vaughn on 2020-08-12.
//  Copyright © 2020 Brick Squad. All rights reserved.
//

import SwiftUI

struct DoorStatusView: View {
    @State var isLock: Bool = true
    var body: some View {
        VStack {
            Rectangle()
                .frame(width: 40, height: 5)
                .cornerRadius(3)
                .opacity(0.2)
            Image(systemName: isLock ? "lock" : "lock.open")
            Text("Hello, World!")
        }
        .padding(.top, 8)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(30)
        .shadow(radius: 20)
    }
}

struct DoorStatusView_Previews: PreviewProvider {
    static var previews: some View {
        DoorStatusView()
    }
}
