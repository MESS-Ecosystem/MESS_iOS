//
//  TitleRow.swift
//  MESS
//
//  Created by khush on 28/04/2026.
//

import SwiftUI

struct TitleRow: View {

    var username: String
    @State var isConnected: Bool
    
    init(username: String = "Hideo Kojima", isConnected: Bool){
        self.username = username
        self.isConnected = isConnected
    }
    
    var body: some View {
        HStack(spacing: 15){
            Image("ProfileSamPorter")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 50, height: 50)
                .clipShape(.circle)
            VStack(alignment: .leading){
                Text(username)
                    .font(.title3)
                    .bold()
                    .foregroundStyle(Color("ThemedText"))
                if isConnected {
                    Text("Online")
                        .font(.caption)
                        .foregroundStyle(.gray)
                        .transition(.opacity)
                }
            }
            
            Spacer()
            ZStack{
                Image(systemName: "phone.fill")
                    .foregroundStyle(.gray)
                    .clipShape(.circle)
                    .padding(10)
                    .background(.white)
                    .clipShape(.circle)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        
    }
}

#Preview {
    TitleRow(isConnected: false)
        .background(Color("Background"))
        .clipShape(.capsule)
        .padding()
}
