//
//  NavBar.swift
//  Bion Criticals
//
//  Created by Vaughn on 2020-08-27.
//  Copyright © 2020 Brick Squad. All rights reserved.
//

import SwiftUI

struct NavBar: View {
    @Binding var showControls: Int
    
    var body: some View {
        HStack {
            Spacer()
            
            Button(action: { self.showControls = 1 }){
                Image(systemName: showControls == 1 ? "hexagon.fill" : "hexagon")
                    .resizable()
                    .frame(width: 30, height: 30)
            }
            
            Spacer()
            
            Button(action: { self.showControls = 0 }){
                Image(systemName: showControls == 0 ? "chart.bar.fill" : "chart.bar")
                .resizable()
                .frame(width: 30, height: 25)
            }
            
            Spacer()
        }
        .frame(height: 55)
        .background(Color.green.opacity(0.3))
        .background(Color.white)
    }
}

struct NavBar_Previews: PreviewProvider {
    static var previews: some View {
        NavBar(showControls: .constant(1))
    }
}
