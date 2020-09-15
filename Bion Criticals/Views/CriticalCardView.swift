//
//  CriticalCardView.swift
//  Bion Criticals
//
//  Created by Vaughn on 2020-06-01.
//  Copyright © 2020 Brick Squad. All rights reserved.
//

import SwiftUI

let screen = UIScreen.main.bounds

struct CriticalCardView: View {
    var critical: Critical
    
    var body: some View {
        HStack(alignment: .bottom) {
            
            VStack(alignment: .leading, spacing: 8) {
                Text(critical.title)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.black)
                    .padding(.top, 5)
                    .padding(.leading, 5)
                
                HStack {
                    Text(critical.indicator + ":")
                        .foregroundColor(.black)
                        .font(.system(size: 14))

                    Text(String(critical.reading) + " " + critical.units)
                        .foregroundColor(.black)
                        .fontWeight(.bold)
                        .font(.system(size: 14))
                }
                .padding(.leading, 5)

                HStack {
                    Text("Status:")
                        .foregroundColor(.black)
                        .font(.system(size: 14))

                    Text(critical.status)
                        .foregroundColor(.black)
                        .fontWeight(.bold)
                        .font(.system(size: 14))

                        
                }
                .padding(.leading, 5)
                .padding(.bottom, 5)
            }
            .padding(10)
            
            Spacer()
            
            Image(systemName: critical.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40, alignment: .top)
                .foregroundColor(.accentColor)
                .padding(.trailing, 15)
                .padding(.bottom, 15)
                
            
        }
        .frame(width: screen.width - 45, height: 100)
        .background(LinearGradient(gradient: Gradient(colors: [critical.color, Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))]), startPoint: .trailing, endPoint: .leading))
        .clipShape(RoundedRectangle(cornerRadius: 25))
        .shadow(color: Color.black.opacity(0.1), radius: 1, x: 0, y: 1)
        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 10)
    }
}

struct CriticalCardView_Previews: PreviewProvider {
    static var previews: some View {
        CriticalCardView(critical: Controls[0])
    }
}
