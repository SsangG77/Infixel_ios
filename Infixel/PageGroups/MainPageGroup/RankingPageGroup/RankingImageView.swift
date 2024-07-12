//
//  RankingImageView.swift
//  Infixel
//
//  Created by 차상진 on 7/13/24.
//

import SwiftUI




struct Ranking: Codable, Identifiable {
    var id: String { name }
    let name: String
    let score: Int
}



class WebSocketManager: ObservableObject {
    private var webSocketTask: URLSessionWebSocketTask?
    //@Published var rankings: [Ranking] = []
    @Published var rankingImages: [SlideImage] = []

    func connect() {
        guard let url = URL(string: VarCollectionFile.webSocketChartURL) else { return }
        webSocketTask = URLSession.shared.webSocketTask(with: url)
        webSocketTask?.resume()
        receiveMessage()
    }

    func receiveMessage() {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .failure(let error):
                print("WebSocket error: \(error)")
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
        let decoder = JSONDecoder()
        print(decoder)
        if let rankings = try? decoder.decode([SlideImage].self, from: data) {
            DispatchQueue.main.async {
                self.rankingImages = rankings
            }
        }
    }

    func disconnect() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
    }
} //class - WebSocketManager




struct RankingImageView: View {
    @StateObject private var webSocketManager = WebSocketManager()

    var body: some View {
        VStack {
            List($webSocketManager.rankingImages) { ranking in
                
                VStack {
                    RankingImageSingleView(ranking: .constant(2), imageURL: ranking.link, pic: ranking.pic, profile_image: ranking.profile_image, user_nick: ranking.user_nick, description: ranking.description)
                }
                .frame(width: UIScreen.main.bounds.width)
                
                
            }
        }
        .onAppear {
            webSocketManager.connect()
        }
        .onDisappear {
            webSocketManager.disconnect()
        }
    }
}

#Preview {
    RankingImageView()
}
