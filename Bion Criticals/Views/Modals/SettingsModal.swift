//
//  SettingsView.swift
//  Bion Criticals
//
//  Created by Vaughn on 2020-06-06.
//  Copyright © 2020 Brick Squad. All rights reserved.
//

import SwiftUI

struct SettingsModal: View {    
    @Binding var connectedBLE: Bool

    var body: some View {
            
        VStack(spacing: 16) {
            Button (action: { self.connectedBLE.toggle() }) {
                MenuRow(title: connectedBLE ? "Disconnect" : "Connect", icon: "gear")
            }
            Button (action: {}) {
                MenuRow(title: "Sign out", icon: "person.crop.circle")
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 170)
        .background(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)), Color(#colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1))]), startPoint: .top, endPoint: .bottom))
        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
        .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 20)
        .padding(.horizontal, 30)
        .overlay(
            ZStack {
                RadialGradient(gradient: Gradient(colors: [Color.white, Color(#colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1))]), center: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, startRadius: 1, endRadius: 35)
                .clipShape(Circle())
                    .frame(width: 70, height: 70)
                    .offset(y: -94)
                    .foregroundColor(.white)
                    .shadow(radius: 20)
                    
                Image(systemName: "antenna.radiowaves.left.and.right")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 40, height: 40)
                    .offset(y: -90)
                    .shadow(radius: 50)
            }
        )
    }
    
    func connectedTrue() {
        self.connectedBLE.toggle()
    }
}

struct SettingsModal_Previews: PreviewProvider {
    static var previews: some View {
        SettingsModal(connectedBLE: .constant(false))
    }
}

struct MenuRow: View {
    var title: String
    var icon: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 25, weight: .light))
                .imageScale(.large)
                .frame(width: 32, height: 32)
                .foregroundColor(Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)))
            
            Text(title)
                .font(.system(size: 20, weight: .bold, design: .default))
                .frame(width: 120, alignment: .leading)
                .foregroundColor(Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)))
        }
    }
}
