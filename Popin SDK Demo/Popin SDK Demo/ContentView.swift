//
//  ContentView.swift
//  Popin SDK Demo
//
//  Created by Ashwin on 28/01/26.
//

import SwiftUI
import Combine
import PopinCall

class PopinEventLog: ObservableObject, PopinInitListener, PopinEventsListener {
    @Published var events: [String] = []

    private func append(_ message: String) {
        DispatchQueue.main.async {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm:ss"
            self.events.append("[\(formatter.string(from: Date()))] \(message)")
        }
    }

    // MARK: - PopinInitListener
    func onInitComplete(userId: Int) { append("Init complete — userId: \(userId)") }
    func onInitFailed(reason: String) { append("Init failed: \(reason)") }

    // MARK: - PopinEventsListener
    func onPermissionGiven() { append("Permission given") }
    func onPermissionDenied() { append("Permission denied") }
    func onCallStart() { append("Call started") }
    func onCallAbandoned() { append("Call abandoned") }
    func onQueuePositionChanged(position: Int) { append("Queue position: \(position)") }
    func onCallMissed() { append("Call missed") }
    func onCallNetworkFailure(participant: String) { append("Network failure — participant: \(participant)") }
    func onCallConnected() { append("Call connected") }
    func onCallFailed() { append("Call failed") }
    func onCallEnd() { append("Call ended") }
}

struct ContentView: View {
    @StateObject private var eventLog = PopinEventLog()

    var body: some View {
        VStack(spacing: 0) {
            Button(action: {
                let config = Popin.shared?.getConfig()
                config?.product = PopinProduct(
                    id: "SKU-123",
                    name: "Wireless Headphones",
                    image: "https://example.com/product.jpg",
                    url: "https://example.com/products/headphones",
                    description: "Noise-cancelling wireless headphones",
                    extra: "$299.99"
                )
                Popin.shared?.startCall()
            }) {
                Text("Make Call")
                    .padding()
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .frame(width: 200)
            .padding()

            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        if eventLog.events.isEmpty {
                            Text("No events yet...")
                                .font(.system(.caption, design: .monospaced))
                                .foregroundColor(.secondary)
                                .padding()
                        } else {
                            Text(eventLog.events.joined(separator: "\n"))
                                .font(.system(.caption, design: .monospaced))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                        }
                        Color.clear.frame(height: 1).id("bottom")
                    }
                }
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal)
                .padding(.bottom)
                .onChange(of: eventLog.events.count) { _ in
                    withAnimation {
                        proxy.scrollTo("bottom", anchor: .bottom)
                    }
                }
            }
        }
        .onAppear {
            let config = Popin.shared?.getConfig()
            config?.initListener = eventLog
            config?.eventsListener = eventLog
        }
    }
}

#Preview {
    ContentView()
}
