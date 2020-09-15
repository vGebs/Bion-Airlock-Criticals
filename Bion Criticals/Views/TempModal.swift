//
//  TempModal.swift
//  Bion Criticals
//
//  Created by Vaughn on 2020-08-31.
//  Copyright © 2020 Brick Squad. All rights reserved.
//

import SwiftUI

struct TempModal: View {
    @State var sliderValue: Double = 19
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "thermometer")
                    .resizable()
                    .frame(width: 30, height: 40)
                    //.padding()
                
                Text("Cabin Temperature")
            }.padding()
            
            Text("Set Temperature: \(sliderValue, specifier: "%.0f")")

            Slider(value: $sliderValue, in: 10...28)
                .frame(width: screen.width - 180)
            
            HStack {
                Text("Confirm")
                    .frame(width: 100, height: 50)
                    .background(Color.green)
                
                Spacer()
                
                Text("Cancel")
                    .frame(width: 100, height: 50)
                    .background(Color.green)

            }
        }
        .frame(width: screen.width - 100, height: 200)
        .background(Color.green.opacity(0.3))
        .background(Color.white)
        .cornerRadius(35)
        .shadow(radius: 35)
    }
}

struct TempModal_Previews: PreviewProvider {
    static var previews: some View {
        TempModal()
    }
}
