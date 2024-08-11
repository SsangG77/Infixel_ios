//
//  InfixelApp.swift
//  Infixel
//
//  Created by 차상진 on 2023/09/12.
//

import SwiftUI
import UIKit
import UserNotifications

@available(iOS 17.0, *)
@main
struct InfixelApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @AppStorage("isLoggedIn") var isLoggedIn = false
    
    
    var body: some Scene {
        WindowGroup {
            ContentView(isLoggedIn: $isLoggedIn)
               
        }
        
    }
}




//@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?

    func application( _ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // UNUserNotificationCenter 대리자 설정
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.delegate = self
        
        // 푸시 알림 등록
        application.registerForRemoteNotifications()
        
//        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting authorization for notifications: \(error)")
            }
            
            if granted {
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            } else {
                print("Notification permission denied")
            }
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
        
        let parameters: [String: Any] = ["device_token": token, "user_id": "12345"]
        
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
    
    //앱이 foreground일때 푸시 알림이 왔을때
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            // 알림을 화면에 표시할 때 사용할 옵션 (배너, 소리 등)
            completionHandler([.banner, .sound])
        
        let userInfo = notification.request.content.userInfo
        VarCollectionFile.myPrint(title: "notification user info", content: userInfo)
    }

    // 사용자가 알림을 클릭했을 때 처리하는 메서드
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // 알림 클릭에 대한 처리 로직
        print("User interacted with notification: \(response.notification.request.content.userInfo)")

        completionHandler()
    }
}

