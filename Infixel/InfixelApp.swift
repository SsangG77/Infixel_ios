//
//  InfixelApp.swift
//  Infixel
//
//  Created by 차상진 on 2023/09/12.
//

import SwiftUI
import UIKit
import UserNotifications
import Foundation
import Combine

@available(iOS 17.0, *)
@main
struct InfixelApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var notificationService = NotificationService()
    
    @AppStorage("isLoggedIn") var isLoggedIn = false
    
    
    var body: some Scene {
        WindowGroup {
            ContentView(isLoggedIn: $isLoggedIn)
                .environmentObject(notificationService)
                .onAppear {
                    appDelegate.notificationService = notificationService
                }
               
        }
        
    }
}




//@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    var notificationService: NotificationService?

    
    func application( _ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            print("Permission granted: \(granted)")
        }
        
        UNUserNotificationCenter.current().delegate = self
        application.registerForRemoteNotifications()
        
//        if let app = UIApplication.shared.delegate as? AppDelegate {
//            self.notificationService = app.notificationService
//        }
        
        if notificationService == nil {
            print("Failed to initialize NotificationService")
        }
        
        return true
    }

    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // 디바이스 토큰을 서버로 전송
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("Device Token: \(token)")
        
        // 토큰을 서버로 전송하는 함수 호출
        sendDeviceTokenToServer(token)
    }
    
    
    func sendDeviceTokenToServer(_ token: String) {
        // 서버로 디바이스 토큰을 전송하는 로직
        guard let url = URL(string: "http://192.168.31.200:3000/user/device-token") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: Any] = ["device_token": token, "user_id": UserDefaults.standard.string(forKey: "user_id")]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error sending token: \(error)")
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                print("Invalid response")
                return
            }
            
            print("Device token sent successfully")
        }
        
        task.resume()
    }
    
    
    // 푸시 알림 수신 (앱이 포그라운드에 있을 때)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }

    // 푸시 알림 수신 (앱이 백그라운드에 있을 때 또는 사용자가 알림을 클릭했을 때)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        handleNotification(response.notification)
        completionHandler()
    }

        // 푸시 알림 데이터 처리
        private func handleNotification(_ notification: UNNotification) {
            let userInfo = notification.request.content.userInfo
            

            if let messageAny = userInfo["message"], let message = messageAny as? String {
                let notificationItem = NotificationItem(message: message, receivedAt: Date())
                notificationService?.saveNotification(notificationItem)
            } else {
                print("Message not found or not a string")
            }
        }
}


class NotificationService: ObservableObject {
    @Published var notifications: [NotificationItem] = []
    
    private let notificationsKey = "notifications"
    
    init() {
        notifications = fetchNotifications()
        
    }

    func saveNotification(_ notification: NotificationItem) {
            notifications.append(notification)
            saveNotifications()
        }

    private func saveNotifications() {
        if let data = try? JSONEncoder().encode(notifications) {
            UserDefaults.standard.set(data, forKey: notificationsKey)
        }
    }

    func fetchNotifications() -> [NotificationItem] {
        if let data = UserDefaults.standard.data(forKey: notificationsKey),
           let notifications = try? JSONDecoder().decode([NotificationItem].self, from: data) {
            return notifications
        }
        return []
    }
}

struct NotificationItem: Identifiable, Codable {
    var id = UUID()
    var message: String
    var receivedAt: Date
}


