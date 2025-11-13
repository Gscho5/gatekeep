//
//  BallKnowledgeView.swift
//  Gatekeep
//
//  Created by Gabe Schoor on 11/12/25.
//
import SwiftUI

struct BallKnowledgeView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "#0D1117").ignoresSafeArea()
                
                VStack {
                    Text("Explore")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text("Coming soon: Advanced analytics")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.6))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
            }
            .navigationBarHidden(true)
        }
    }
}
