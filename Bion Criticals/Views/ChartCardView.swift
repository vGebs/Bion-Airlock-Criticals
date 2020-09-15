//
//  ChartCardView.swift
//  Bion Criticals
//
//  Created by Vaughn on 2020-07-27.
//  Copyright © 2020 Brick Squad. All rights reserved.
//

import SwiftUI
import SwiftUICharts

struct ChartCardView: View {
    var title = "Cabin Pressure"
    var date = "Jun 12, 8:30.36"
    var data: [Double] = [8,23,54,32,12,37,7,23,43]
    
    var body: some View {
        
        VStack {
            Rectangle()
                .frame(width: 40, height: 5)
                .cornerRadius(3)
                .opacity(0.2)
            
            ZStack {
                LineView(data: data)
                    .frame(width: screen.width - 40, height: 150)
                    .offset(y: 9)
                HStack {
                    Spacer()
                    Text(title)
                        .font(.system(size: 25, weight: .bold))
                        .offset(y: -45)
                        .padding(.horizontal, 15)
                }
                
                Text(date)
                    .font(.system(size: 14, weight: .light))
                    .offset(y: 190)
            }
            .offset(y: 50)
            
            ScrollView(.horizontal, showsIndicators: false) {
                VStack {
                    HStack {
                        Button(action: { print("hello") }) {
                            SmlPressureCard()
                        }
                        Button(action: { print("hello") }) {
                            SmlDoorCard()
                        }
                        Button(action: { print("hello") }) {
                            SmlTempCard()
                        }
                    }
                    
                    HStack {
                        Button(action: { print("hello") }) {
                            SmlPressureCard()
                        }
                        Button(action: { print("hello") }) {
                            SmlDoorCard()
                        }
                        Button(action: { print("hello") }) {
                            SmlTempCard()
                        }
                    }
                    .padding(.horizontal, 15)
                    .padding(.bottom, 20)
                }
            }
            .frame(height: 150)
            .offset(y: 170)
            
            Spacer()
            
        }
        .padding(.top, 8)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(30)
        .shadow(radius: 20)
    }
}

struct ChartCardView_Previews: PreviewProvider {
    static var previews: some View {
        ChartCardView()
    }
}
