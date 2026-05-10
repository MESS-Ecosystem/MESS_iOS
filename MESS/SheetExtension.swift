//
//  SheetExtension.swift
//  MESS
//
//  Created by khush on 10/05/2026.
//

import SwiftUI

extension ContentView {

    public var connectionSheet: some View {

        NavigationView {

            VStack(alignment: .center, spacing: 20) {

                Text("Enter Server URI")
                    .font(.title2)
                    .bold()

                TextField(
                    "Socket URI",
                    text: $inputText
                )
                .foregroundStyle(.white)
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(.capsule)
                .padding(.horizontal)
                Button("Connect") {
                    connectToServer()
                    showingAlert = false
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(.ultraThinMaterial)
                .foregroundColor(.white)
                .clipShape(.capsule)
                .padding(.horizontal)

//                Spacer()

            }
            .padding()
            .navigationTitle("Connect")
            .navigationBarTitleDisplayMode(.inline)

        }

    }

}
