//
//  AlarmView.swift
//  Infixel
//
//  Created by 차상진 on 8/10/24.
//

import SwiftUI

struct AlarmView: View {
    
    @EnvironmentObject var notificationService: NotificationService
    
    
    var body: some View {
        NavigationView {
            List(notificationService.notifications) { notification in
                VStack(alignment: .leading) {
                    Text(notification.message)
                        .font(.headline)
                        
                    
                    Text("\(notification.receivedAt, formatter: dateFormatter)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
//            .navigationTitle("Notifications")
            
        }
    }
    
    
    private var dateFormatter: DateFormatter {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .short
            return formatter
        }
}

#Preview {
    AlarmView()
}
