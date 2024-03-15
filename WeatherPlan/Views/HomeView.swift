//
//  HomeView.swift
//  WeatherApp
//
//  Created by Roman Krusman on 15.03.2024.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            let topEdge = proxy.safeAreaInsets.top
            
            ContentView(size: size, topEdge: topEdge)
                .ignoresSafeArea(.all, edges: .top)
        }
        
    }
}

#Preview {
    HomeView()
}
