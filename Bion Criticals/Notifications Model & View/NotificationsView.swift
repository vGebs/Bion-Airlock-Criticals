//
//  NotificationsView.swift
//  Bion Criticals
//
//  Created by Vaughn on 2020-06-04.
//  Copyright © 2020 Brick Squad. All rights reserved.
//

import SwiftUI

struct NotificationsView: View {
    @ObservedObject var store = NotificationStore()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(store.notifications) { notif in
                    NavigationLink(destination: NotificationsDetail()) {
                        HStack{
                            ZStack {
                                Circle()
                                    .foregroundColor(notif.indicatorColor)
                                    .frame(width: 50, height: 50)
                                Image(systemName: notif.image)
                                    .font(.system(size: 26))
                            }
                            .padding(.trailing, 10)
                            .shadow(radius: 15)
                            
                            VStack(alignment: .leading, spacing: 4){
                                Text(notif.title)
                                    .font(.system(size: 18, weight: .bold))
                                
                                Text(notif.status)
                                    .lineLimit(2)
                                    .font(.subheadline)
                                    .foregroundColor(Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)))

                                
                                Text(notif.date)
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                .onDelete { index in
                    self.store.notifications.remove(at: index.first!)
                }
                .onMove { (source: IndexSet, destination: Int) in
                    self.store.notifications.move(fromOffsets: source, toOffset: destination)
                }
            }
            .navigationBarTitle(Text("Notifications"))
            .navigationBarItems(trailing: EditButton())
        }
        
    }
}

struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsView()
    }
}


