//
//  DoorModal.swift
//  Bion Criticals
//
//  Created by Vaughn on 2020-08-31.
//  Copyright © 2020 Brick Squad. All rights reserved.
//

import SwiftUI

struct DoorModal: View {
    @State var doorsLocked = true
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "lock.circle")
                    .resizable()
                    .frame(width: 40, height: 40)
                    //.padding()
                
                Text("Door Locks")
            }.padding()
            

            Toggle(isOn: $doorsLocked) {
                Text(doorsLocked ? "Lock Doors" : "Unlock Doors")
            }
            .padding(.leading, 50)
            .padding(.trailing, 50)
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

struct DoorModal_Previews: PreviewProvider {
    static var previews: some View {
        DoorModal()
    }
}
