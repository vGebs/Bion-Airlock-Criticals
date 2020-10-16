//
//  SmallCriticalCardView.swift
//  Bion Criticals
//
//  Created by Vaughn on 2020-06-06.
//  Copyright © 2020 Brick Squad. All rights reserved.
//

import SwiftUI

struct SmlPressureCard: View {
    @Binding var percentComplete: CGFloat
    @Binding var status: String
    @Binding var timeRemaining: String
    
    var body: some View {
        HStack(spacing: 12) {
            RingView(color1: #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1), color2: #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1), width: 36, height: 36, percent: percentComplete, show: .constant(true))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(status)
                    .bold()
                    .modifier(FontModifier(style: .subheadline))
                
                Text(timeRemaining)
                    .modifier(FontModifier(style: .caption))
            }
        }
        .padding(8)
        .background(Color.white)
        .cornerRadius(20)
        .modifier(ShadowModifier())
    }
}

struct SmlDoorCard: View {
    var body: some View {
        HStack(spacing: 12) {
            RadialGradient(gradient: Gradient(colors: [Color.green, Color.white]), center: .center, startRadius: 5, endRadius: 25)
                .clipShape(Circle())
                .frame(width: 32, height: 32)
                .modifier(ShadowModifier())
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Door Locks")
                    .bold()
                    .modifier(FontModifier(style: .subheadline))
                
                Text("Activated")
                    .modifier(FontModifier(style: .caption))
            }
        }
        .padding(8)
        .background(Color.white)
        .cornerRadius(20)
        .modifier(ShadowModifier())
    }
}

struct SmlTempCard: View {
    var body: some View {
        HStack(spacing: 12) {
            RingView(color1: #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1), color2: #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1), width: 36, height: 36, percent: 28, show: .constant(true))
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Temperature")
                    .bold()
                    .modifier(FontModifier(style: .subheadline))
                
                Text("Heat activated")
                    .modifier(FontModifier(style: .caption))
            }
        }
        .padding(8)
        .background(Color.white)
        .cornerRadius(20)
        .modifier(ShadowModifier())
    }
}

