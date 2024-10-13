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

import KakaoSDKCommon
import KakaoSDKAuth

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
    var deviceTokenString: String?
    
    var notificationService: NotificationService?
    
    private var processedNotifications = Set<String>()
    
    //카카오 api 네이티브 앱 키
    let kakaoAppKey = Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] ?? ""

    
    func application( _ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UNUserNotificationCenter.current().delegate = self
        application.registerForRemoteNotifications()
       
        KakaoSDK.initSDK(appKey: kakaoAppKey as! String)
        
        return true
    }
  
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // 디바이스 토큰을 서버로 전송
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        deviceTokenString = token
        UserDefaults.standard.set(token, forKey: "device_token")
    }
    
    func application(_ app: UIApplication, open url: URL,
                         options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
            // 카카오 로그인 처리를 위한 콜백
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                return AuthController.handleOpenUrl(url: url)
            }
            return false
        }
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        
        let sceneConfig = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
        
        sceneConfig.delegateClass = SceneDelegate.self
        
        return sceneConfig
        
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        handleNotification(userInfo)
        completionHandler(.newData)
    }
    
    
    
    // 푸시 알림 수신 (앱이 포그라운드에 있을 때)
        func userNotificationCenter(
            _ center: UNUserNotificationCenter,
            willPresent notification: UNNotification,
            withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            handleNotification(notification)
            completionHandler([.banner, .sound])
        }

        // 푸시 알림 수신 (사용자가 알림을 클릭했을 때)
        func userNotificationCenter(
            _ center: UNUserNotificationCenter,
            didReceive response: UNNotificationResponse,
            withCompletionHandler completionHandler: @escaping () -> Void) {
                
            handleNotification(response.notification)
            completionHandler()
                
        }
    
    
    
    
    private func handleNotification(_ userInfo: [AnyHashable: Any]) {
        UserDefaults.standard.set(true, forKey: "new_notification")
        notificationService?.notification_flag = true
        
        if let messageAny = userInfo["message"], let message = messageAny as? String {
            let notificationItem = NotificationItem(message: message, receivedAt: Date())
            notificationService?.saveNotification(notificationItem)
        } else {
            print("Message not found or not a string")
        }
    }
    

        // 푸시 알림 데이터 처리
        private func handleNotification(_ notification: UNNotification) {
            
            let userInfo = notification.request.content.userInfo
            
            let identifier = notification.request.identifier
               
           // 이미 처리된 알림인지 확인
           guard !processedNotifications.contains(identifier) else {
               return  // 이미 처리된 경우 무시
           }
            processedNotifications.insert(identifier)
            
            //새로운 알림이 오면 불리언값 기기에 저장
            UserDefaults.standard.set(true, forKey: "new_notification")
            notificationService?.notification_flag = true
            VarCollectionFile.myPrint(title: "handleNotification()", content: notificationService?.notification_flag)
            
            if let messageAny = userInfo["message"], let message = messageAny as? String {
                let notificationItem = NotificationItem(message: message, receivedAt: Date())
                notificationService?.saveNotification(notificationItem)
            } else {
                print("Message not found or not a string")
            }
            
        }
} //AppDelegate

extension Notification.Name {
    static let didReceiveDeviceToken = Notification.Name("didReceiveDeviceToken")
}




//--@--------------------------------------------------------------------------------------------

class NotificationService: ObservableObject {
    @Published var notifications: [NotificationItem] = []
    @Published var notification_flag: Bool = UserDefaults.standard.bool(forKey: "new_notification")
    
    private let notificationsKey = "notifications"
    
    init() {
        notifications = fetchNotifications()
    }

    func saveNotification(_ notification: NotificationItem) {
            notifications.insert(notification, at: 0)
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


