//
//  CustomStackView.swift
//  WeatherApplication
//
//  Created by Roman Krusman on 06.03.2024.
//

//
//  CustomStackView.swift
//  WeatherAppScrolling (iOS)
//
//  Created by Balaji on 15/06/21.
//

import SwiftUI

struct CustomStackView<Title: View, Content: View>: View {
    var titleView: Title
    var contentView: Content
    @State var topOffset: CGFloat = 0
    @State var bottomOffset: CGFloat = 0
    
    init(@ViewBuilder titleView: @escaping () -> Title, @ViewBuilder contentView: @escaping () -> Content) {
        self.contentView = contentView()
        self.titleView = titleView()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            titleView
                .font(.callout)
                .lineLimit(1)
                .frame(height: 38)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)
                .background(.ultraThinMaterial,in: CustomCorner(corners: bottomOffset < 38 ? .allCorners : [.topLeft,.topRight], radius: 12))
                .zIndex(1)
            
            VStack {
                Divider()
                
                contentView
                    .padding()
            }
            .background(.ultraThinMaterial,in: CustomCorner(corners: [.bottomLeft,.bottomRight], radius: 12))
            .offset(y: topOffset >= 120 ? 0 : -(-topOffset + 120))
            .zIndex(0)
            .clipped()
            .opacity(getOpacity())
        }
        .colorScheme(.dark)
        .cornerRadius(12)
        .opacity(getOpacity())
        .offset(y: topOffset >= 120 ? 0 : -topOffset + 120)
        .offsetChange { rect in
            let minY = rect.minY
            let maxY = rect.maxY
            
            self.topOffset = minY
            self.bottomOffset = maxY - 120
        }
        .modifier(CornerModifier(bottomOffset: $bottomOffset))
       
    }
    
    func getOpacity()->CGFloat{
        if bottomOffset < 28{
            let progress = bottomOffset / 28
            return progress
        }
        
        return 1
    }
}

#Preview {
    HomeView()
}
