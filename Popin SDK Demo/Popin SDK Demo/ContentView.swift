//
//  ContentView.swift
//  Popin SDK Demo
//
//  Created by Ashwin on 28/01/26.
//

import SwiftUI
import PopinCall

struct ContentView: View {
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
            
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(0..<50) { index in
                        HStack(spacing: 12) {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 60, height: 60)
                                .overlay(
                                    Text("\(index + 1)")
                                        .font(.headline)
                                        .foregroundColor(.gray)
                                )
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Item \(index + 1)")
                                    .font(.headline)
                                Text("This is a description for item \(index + 1). Some dummy content to fill the space.")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .lineLimit(2)
                            }
                            
                            Spacer()
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
        }
    }
}

#Preview {
    ContentView()
}
