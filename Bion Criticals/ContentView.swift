//
//  ContentView.swift
//  Bion Criticals
//
//  Created by Vaughn on 2020-06-01.
//  Copyright © 2020 Brick Squad. All rights reserved.
//

import SwiftUI
import Combine

struct ContentView: View {
    @State var showConnect: Bool = false
    @State var showCharts: Bool = false
    @State var connectedBLE: Bool = false
    @State var bottomState = CGSize.zero
    @State var showControls: Int = 1
    @State var tappedControl: Int = -1
        
    @EnvironmentObject var criticalVM: CriticalViewModel
    
    var body: some View {
        ZStack {
            ControlsView(showConnect: $showConnect, tappedControl: $tappedControl)
                .opacity(showControls == 1 ? 1 : 0)
            
            ChartsView(showConnect: $showConnect)
                .opacity(showControls == 0 ? 1 : 0)
                .blur(radius: showConnect ? 30 : 0)
            
            NavBar(showControls: $showControls)
                .offset(y: screen.height / 2.22)
                .blur(radius: showConnect || tappedControl > -1 ? 30 : 0)
            
            Color.black
                .edgesIgnoringSafeArea(.all)
                .opacity(showConnect || showCharts || tappedControl > -1 ? 0.1 : 0)
                .onTapGesture {
                    if self.showConnect == true {
                        self.showConnect.toggle()
                    }
                    self.tappedControl = -1
                }
            
            SettingsModal(connectedBLE: $connectedBLE)
                .offset(x: showConnect ? 0 : 100)
                .opacity(showConnect ? 1 : 0)
                .animation(.spring())
                .onAppear{
                    if connectedBLE == true{
                        //self.ble.setupBLE()
                    }
                }
            
            Modals(tappedControl: $tappedControl)
        }.onAppear{
            criticalVM.setupBLE()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(CriticalViewModel())
    }
}

struct Header: View {
    @State var showNotif = false
    @Binding var showConnect: Bool
    @State var pressurePercentage: CGFloat = 69
    @State var pressureStatus = "Pressurizing"
    @State var pressureTimeLeft = "2 min"
            
    @EnvironmentObject var critical: CriticalViewModel
        
    var body: some View {
        ZStack {
            Color.green
                .frame(height: 800)
                .opacity(0.3)
                .cornerRadius(25)
                .shadow(radius: 25)
                .offset(y: -360)
            
            VStack {
                HStack{
                    Text("Criticals")
                        .font(.system(size: 32, weight: .bold))
                    
                    Spacer()
                    
                    Button(action: { critical.refreshData() }) {
                        Image(systemName: "arrow.clockwise")
                            .renderingMode(.original)
                            .font(.system(size: 17, weight: .medium))
                            .frame(width: 36, height: 36)
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(color: Color.black.opacity(0.1), radius: 1, x: 0, y: 1)
                            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 10)
                    }
                    
                    Button(action: { self.showConnect.toggle() }) {
                        Image(systemName: "dot.radiowaves.left.and.right")
                            .renderingMode(.original)
                            .font(.system(size: 17, weight: .medium))
                            .frame(width: 36, height: 36)
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(color: Color.black.opacity(0.1), radius: 1, x: 0, y: 1)
                            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 10)
                    }
                    
                    Button(action: { self.showNotif.toggle() }) {
                        Image(systemName: "bell")
                            .renderingMode(.original)
                            .font(.system(size: 17, weight: .medium))
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
                        SmlPressureCard(percentComplete: $pressurePercentage, status: $pressureStatus, timeRemaining: $pressureTimeLeft)
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

struct ControlsView: View {
    @Binding var showConnect: Bool
    @Binding var tappedControl: Int
    
    @EnvironmentObject var critical: CriticalViewModel
    
    var body: some View {
        ScrollView {
            
            Header(showConnect: $showConnect)
                .frame(height:150)
            
            HStack {
                Text("Cabin Controls")
                    .font(.system(size: 25, weight: .bold))
                    .padding(.horizontal)
                    .padding(.leading, 5)
                
                Spacer()
            }
            
            ForEach(critical.controls.indices){ index in
                CriticalCardView(critical: self.critical.controls[index])
                    .padding(.bottom, 5)
                    .onTapGesture {
                        self.tappedControl = index
                    }
            }
        }
        .blur(radius: showConnect || tappedControl > -1 ? 30 : 0)
    }
}

struct Modals: View {
    @Binding var tappedControl: Int
    
    var body: some View {
        ZStack {
            PressureModal()
                .opacity(tappedControl == 0 ? 1 : 0)
            
            DoorModal()
                .opacity(tappedControl == 1 ? 1 : 0)
            
            TempModal()
                .opacity(tappedControl == 2 ? 1 : 0)
        }
    }
}
