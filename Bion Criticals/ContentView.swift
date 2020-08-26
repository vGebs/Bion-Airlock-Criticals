//
//  ContentView.swift
//  Bion Criticals
//
//  Created by Vaughn on 2020-06-01.
//  Copyright © 2020 Brick Squad. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var isLock: Bool = false
    @State var showConnect: Bool = false
    @State var showCharts: Bool = false
    @State var connectedBLE: Bool = false
    @State var bottomState = CGSize.zero
    
    var body: some View {
        
        ZStack {
            ScrollView {
                ZStack {
                    Color.green
                        .frame(height: 800)
                        .opacity(0.3)
                        .cornerRadius(25)
                        .shadow(radius: 25)
                        .offset(y: -360)
                    
                    Header(showConnect: $showConnect)
                }
                .frame(height:150)
                
                HStack {
                    Text("Cabin Controls")
                        .font(.system(size: 25, weight: .bold))
                        .padding(.horizontal)
                        .padding(.leading, 5)
                        
                    Spacer()
                }
                
                
                ForEach(Controls){ item in
                    CriticalCardView(critical: item)
                        .padding(.bottom, 5)
                        .onTapGesture {
                            if item.chartType == "chart"{
                                self.showCharts.toggle()
                            }
                            else if item.chartType == "ringView"{
                                
                            }
                            else if item.chartType == "switch"{
                                
                            }
                        }
                }
                
                HStack{
                    Text("Gas Levels")
                        .font(.system(size: 25, weight: .bold))
                        .padding(.horizontal)
                        .padding(.leading, 5)

                    Spacer()
                }
                
                ForEach(Gases){ item in
                    CriticalCardView(critical: item)
                        .padding(.bottom, 5)
                }
            }
            .blur(radius: showConnect || showCharts ? 30 : 0)
            
            Color.black
                .edgesIgnoringSafeArea(.all)
                .opacity(showConnect || showCharts ? 0.1 : 0)
                .onTapGesture {
                    if self.showConnect == true {
                        self.showConnect.toggle()
                    }
                    if self.showCharts == true {
                        self.showCharts.toggle()
                    }
                }
            
            SettingsView(connectedBLE: $connectedBLE)
                .offset(x: showConnect ? 0 : 100)
                .opacity(showConnect ? 1 : 0)
                .animation(.spring())
            
            ChartCardView()
                .opacity(showCharts ? 1 : 0)
                .offset(x: 0, y: showCharts ? 280 : 1000)
                .offset(y: bottomState.height)
                .animation(.timingCurve(0.2, 0.8, 0.2, 1, duration: 0.8))
                .gesture(
                    DragGesture().onChanged { value in
                        self.bottomState = value.translation
                        if self.bottomState.height < -200 {
                            self.bottomState.height = 0
                        }
                    }
                    .onEnded { value in
                        if self.bottomState.height > 100 {
                            self.showCharts = false
                            self.bottomState = .zero
                        } else {
                            self.bottomState.height = 0
                        }
                    }
                )
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Header: View {
    @State var showNotif = false
    @Binding var showConnect: Bool
    
    var body: some View {
        ZStack {
//            Color.green
//                .frame(height: 160)
//                .opacity(0.3)
//                .cornerRadius(25)
//                .shadow(radius: 25)
//                .offset(y: -50)
            
            VStack {
                HStack{
                    Text("Criticals")
                        .font(.system(size: 32, weight: .bold))
                    
                    Spacer()
                    
                    Button(action: { self.showConnect.toggle() }) {
                        Image(systemName: "dot.radiowaves.left.and.right")
                            .renderingMode(.original)
                            .font(.system(size: 16, weight: .medium))
                            .frame(width: 36, height: 36)
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(color: Color.black.opacity(0.1), radius: 1, x: 0, y: 1)
                            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 10)
                    }
                    
                    Button(action: { self.showNotif.toggle() }) {
                        Image(systemName: "bell")
                            .renderingMode(.original)
                            .font(.system(size: 16, weight: .medium))
                            .frame(width: 36, height: 36)
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(color: Color.black.opacity(0.1), radius: 1, x: 0, y: 1)
                            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 10)
                    }
                    .sheet(isPresented: $showNotif) {
                        NotificationsView()
                    }
                }
                .padding(.horizontal)
                .padding(.leading, 5)
                .padding(.top, 30)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 14) {
                        SmlPressureCard()
                        SmlDoorCard()
                        SmlTempCard()
                    }
                    .padding(.horizontal, 30)
                    .padding(.bottom, 20)
                }
            }
        }
    }
}
