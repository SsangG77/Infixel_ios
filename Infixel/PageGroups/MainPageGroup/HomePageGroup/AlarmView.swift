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
            VStack {
                
                //버튼은 알림 테스트 끝나면 삭제 예정
                Button(action: {
                    print("버튼")
                    UserDefaults.standard.removeObject(forKey: "notifications")
                    notificationService.notifications = []
                }) {
                    Text("알림 삭제")
                }
                .frame(width: 100, height: 45)
                .cornerRadius(15)
                .background(.blue)
                
                List(notificationService.notifications) { notification in
                    VStack(alignment: .leading) {
                        Text(notification.message)
                            .font(.headline)
                        
                        
                        Text("\(notification.receivedAt, formatter: dateFormatter)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
            
        }//NavigationView
        .onAppear {
            if UserDefaults.standard.bool(forKey: "new_notification") {

                UserDefaults.standard.set(false, forKey: "new_notification")
                notificationService.notification_flag = false
            }
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
