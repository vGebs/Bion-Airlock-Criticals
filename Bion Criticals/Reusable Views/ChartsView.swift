//
//  ChartsView.swift
//  Bion Criticals
//
//  Created by Vaughn on 2020-08-27.
//  Copyright © 2020 Brick Squad. All rights reserved.
//

import SwiftUI
import SwiftUICharts

struct ChartsView: View {
    @Binding var showConnect: Bool
    
    var body: some View {
        ScrollView {
            Header(showConnect: $showConnect)
                .frame(height:150)
            
            HStack {
                Text("Cabin Control Data")
                    .font(.system(size: 25, weight: .bold))
                    .padding(.horizontal)
                    .padding(.leading, 5)
                
                Spacer()
            }
            
            ForEach(Controls){ control in
                if control.title != "Door Locks"{
                    BarChartView(data: ChartData(points: [8,23,54,32,12,37,7,23,43, 45, 61, 73, 22]), title: control.title, form: ChartForm.large, cornerImage: Image(systemName: control.image))
                    .frame(width: screen.width - 20)
                    .padding(.bottom, 40)
                }
            }
            
            HStack {
                Text("Gas Levels")
                    .font(.system(size: 25, weight: .bold))
                    .padding(.horizontal)
                    .padding(.leading, 5)
                        
                Spacer()
            }
            
            ForEach(Gases){ gas in
                BarChartView(data: ChartData(points: [8,23,54,32,12,37,7,23,43]), title: gas.title, form: ChartForm.large, cornerImage: Image(systemName: gas.image))
                .frame(width: screen.width - 20)
                .padding(.bottom, 40)
            }
        }
    }
}

struct ChartsView_Previews: PreviewProvider {
    static var previews: some View {
        ChartsView(showConnect: .constant(false))
    }
}
