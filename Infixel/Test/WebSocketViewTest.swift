//
//  WebSocketViewTest.swift
//  Infixel
//
//  Created by 차상진 on 7/12/24.
//

import SwiftUI

struct Ranking: Codable, Identifiable {
    var id: String { name }
    let name: String
    let score: Int
}

class WebSocketManager: ObservableObject {
    private var webSocketTask: URLSessionWebSocketTask?
    @Published var rankings: [Ranking] = []

    func connect() {
        guard let url = URL(string: "ws://localhost:3000/chart") else { return }
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
        if let rankings = try? decoder.decode([Ranking].self, from: data) {
            DispatchQueue.main.async {
                self.rankings = rankings
            }
        }
    }

    func disconnect() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
    }
}

struct WebSocketViewTest: View {
    @StateObject private var webSocketManager = WebSocketManager()

    var body: some View {
        VStack {
            Text("실시간 순위")
                .font(.largeTitle)
                .padding()

            List(webSocketManager.rankings) { ranking in
                HStack {
                    Text(ranking.name)
                    Spacer()
                    Text("\(ranking.score)")
                }
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
    WebSocketViewTest()
}
