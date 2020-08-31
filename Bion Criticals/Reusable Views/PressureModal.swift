//
//  PressureModal.swift
//  Bion Criticals
//
//  Created by Vaughn on 2020-08-31.
//  Copyright © 2020 Brick Squad. All rights reserved.
//

import SwiftUI

struct PressureModal: View {
    @State var cabinPressurized = false
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "rectangle.compress.vertical")
                    .resizable()
                    .frame(width: 40, height: 40)
                    //.padding()
                
                Text("Cabin Pressure")
            }
            .padding()
            

            Toggle(isOn: $cabinPressurized) {
                Text(cabinPressurized ? "Pressurize Cabin" : "Depressurize Cabin")
            }
            .padding(.leading, 25)
            .padding(.trailing, 25)
            .padding(.bottom, 25)
            
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
        .frame(width: screen.width - 100, height: 195)
        .background(Color.green.opacity(0.3))
        .background(Color.white)
        .cornerRadius(35)
        .shadow(radius: 35)
    }
}

struct PressureModal_Previews: PreviewProvider {
    static var previews: some View {
        PressureModal()
    }
}
