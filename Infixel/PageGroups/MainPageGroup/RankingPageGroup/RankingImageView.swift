////
////  RankingImageView.swift
////  Infixel
////
////  Created by 차상진 on 7/13/24.
////
//
//import SwiftUI
//
//
//
//
//struct RankingImage: Codable, Identifiable, Hashable {
//    
//    var rank: Int
//    var id: String
//    var link: String
//    var user_nick: String
//    var profile_image: String
//    var pic: Int
//    var description: String
//}
//
//struct RankingUser: Codable, Identifiable, Hashable {
//    var rank: Int
//    var id: String
//    var user_id: String
//    var profile_image:String
//    var follower_count:String
//    var pic_count:String
//}
//
//
//
//
//
//class WebSocketManager: ObservableObject {
//    private var webSocketTask: URLSessionWebSocketTask?
//    @Published var rankingImages: [RankingImage] = []
//    @Published var rankingUsers: [RankingUser] = []
//    @Published var type:Bool = false
//
//    func connect() {
//        var urlString = ""
//        
//        
//        if type {
//            urlString = VarCollectionFile.rankingImageURL
//        } else {
//            urlString = VarCollectionFile.rankingUserURL
//        }
//        
//        guard let url = URL(string: urlString) else { return }
//        webSocketTask = URLSession.shared.webSocketTask(with: url)
//        webSocketTask?.resume()
//        receiveMessage()
//        
//    }
//
//    func receiveMessage() {
//        webSocketTask?.receive { [weak self] result in
//            switch result {
//            case .failure(let error):
//                print("WebSocket error: \(error)")
//                return
//            case .success(let message):
//                switch message {
//                case .data(let data):
//                    self?.handleMessageData(data)
//                case .string(let text):
//                    if let data = text.data(using: .utf8) {
//                        self?.handleMessageData(data)
//                    }
//                @unknown default:
//                    fatalError()
//                }
//            }
//            self?.receiveMessage()
//        }
//    }
//
//    func handleMessageData(_ data: Data) {
//        
//        do {
//            if type {
//                let rankings: [RankingImage] = try decodeData(ofType: RankingImage.self, from: data)
//                DispatchQueue.main.async {
//                    self.rankingImages = rankings
//                }
//            } else {
//                let rankingUsers: [RankingUser] = try decodeData(ofType: RankingUser.self, from: data)
//                DispatchQueue.main.async {
//                    self.rankingUsers = rankingUsers
//                }
//            }
//        } catch {
//            print("Decoding failed")
//        }
//            
//        
//    }
//    
//    func decodeData<T: Decodable>(ofType type: T.Type, from data: Data) throws -> [T] {
//        let decoder = JSONDecoder()
//        return try decoder.decode([T].self, from: data)
//    }
//
//    func disconnect() {
//        webSocketTask?.cancel(with: .goingAway, reason: nil)
//    }
//} //class - WebSocketManager
//
//
//
//
//struct RankingImageView: View {
//    @StateObject private var webSocketManager = WebSocketManager()
//    @EnvironmentObject var appState: AppState
//    
//    @Binding var showImageViewer: Bool
//
//    var body: some View {
//        VStack {
//            
//            ScrollView {
//                LazyVStack {
//                    ForEach($webSocketManager.rankingImages) { ranking in
//                        VStack {
//                            RankingImageSingleView(ranking: ranking.rank, imageURL: ranking.link, pic: ranking.pic, profile_image: ranking.profile_image, user_nick: ranking.user_nick, description: ranking.description)
//                                .padding()
//                                .onTapGesture {
//                                    appState.selectImage(imageUrl: ranking.link.wrappedValue, imageId: ranking.id.wrappedValue)
//                                    showImageViewer = true
//                                }
//                        }
//                        .frame(width: UIScreen.main.bounds.width)
//                    }
//                }
//                .padding(.top, 50)
//            }
//            
//        }
//        //.ignoresSafeArea()
//        .onAppear {
//            webSocketManager.type = true
//            webSocketManager.connect()
//            print(webSocketManager.type)
//        }
//        .onDisappear {
//            webSocketManager.disconnect()
//            appState.selectImageReset()
//        }
//    }
//}
//
//#Preview {
//    RankingImageView(showImageViewer: .constant(false))
//}














//
//  RankingImageView.swift
//  Infixel
//
//  Created by 차상진 on 7/13/24.
//

import SwiftUI




struct RankingImage: Codable, Identifiable, Hashable {
    
    var rank: Int
    var id: String
    var link: String
    var user_nick: String
    var profile_image: String
    var pic: Int
    var description: String
}

struct RankingUser: Codable, Identifiable, Hashable {
    var rank: Int
    var id: String
    var user_id: String
    var profile_image:String
    var follower_count:String
    var pic_count:String
}





class WebSocketManager: ObservableObject {
    private var webSocketTask: URLSessionWebSocketTask?
    @Published var rankingImages: [RankingImage] = []
    @Published var rankingUsers: [RankingUser] = []
    @Published var type:Bool = false

    func connect() {
        var urlString = ""
        
        
        if type {
            urlString = VarCollectionFile.rankingImageURL
        } else {
            urlString = VarCollectionFile.rankingUserURL
        }
        
        guard let url = URL(string: urlString) else { return }
        webSocketTask = URLSession.shared.webSocketTask(with: url)
        webSocketTask?.resume()
        receiveMessage()
        
    }

    func receiveMessage() {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .failure(let error):
                print("WebSocket error: \(error)")
                return
            case .success(let message):
                switch message {
                case .data(let data):
                    self?.handleMessageData(data)
                case .string(let text):
                    if let data = text.data(using: .utf8) {
                        self?.handleMessageData(data)
                    }
                @unknown default:
                    fatalError()
                }
            }
            self?.receiveMessage()
        }
    }

    func handleMessageData(_ data: Data) {
        
        do {
            if type {
                let rankings: [RankingImage] = try decodeData(ofType: RankingImage.self, from: data)
                DispatchQueue.main.async {
                    
                    self.rankingImages = rankings
                }
            } else {
                let rankingUsers: [RankingUser] = try decodeData(ofType: RankingUser.self, from: data)
                DispatchQueue.main.async {
                    self.rankingUsers = rankingUsers
                }
            }
        } catch {
            print("Decoding failed")
        }
            
        
    }
    
    func decodeData<T: Decodable>(ofType type: T.Type, from data: Data) throws -> [T] {
        let decoder = JSONDecoder()
        return try decoder.decode([T].self, from: data)
    }

    func disconnect() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
    }
} //class - WebSocketManager




struct RankingImageView: View {
    @StateObject private var webSocketManager = WebSocketManager()
    @EnvironmentObject var appState: AppState
    
    @Binding var showImageViewer: Bool

    var body: some View {
        VStack {
            
            ScrollView {
                LazyVStack {
                    ForEach($webSocketManager.rankingImages) { ranking in
                        VStack {
                            RankingImageSingleView(ranking: ranking.rank, imageURL: ranking.link, pic: ranking.pic, profile_image: ranking.profile_image, user_nick: ranking.user_nick, description: ranking.description)
                                .padding()
                                .onTapGesture {
                                    appState.selectImage(imageUrl: ranking.link.wrappedValue, imageId: ranking.id.wrappedValue)
                                    showImageViewer = true
                                }
                        }
                        .frame(width: UIScreen.main.bounds.width)
                    }
                }
                .padding(.top, 50)
            }
            
        }
        //.ignoresSafeArea()
        .onAppear {
            webSocketManager.type = true
            webSocketManager.connect()
            print(webSocketManager.type)
        }
        .onDisappear {
            VarCollectionFile.myPrint(title: "RankingImageView - disconnect()", content: "웹소켓 종료됨")
            webSocketManager.disconnect()
            appState.selectImageReset()
        }
    }
}

#Preview {
    RankingImageView(showImageViewer: .constant(false))
}
