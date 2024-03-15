//
//  ContentView.swift
//  WeatherApp
//
//  Created by Roman Krusman on 06.03.2024.
//

//
//  ContentView.swift
//  WeatherApplication
//
//  Created by Roman Krusman on 02.03.2024.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = WeatherViewModel()
    @AppStorage("temperatureUnit") private var temperatureUnit: String = "Celsius"
    @State private var offset: CGFloat = 0
    var size: CGSize
    var topEdge: CGFloat
    var body: some View {
        NavigationStack {
            ZStack {
                GeometryReader { proxy in
                    Image(viewModel.imageForCondition("\(viewModel.condition)"))
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: proxy.size.width, height: proxy.size.height)
                }
                .ignoresSafeArea()
                .overlay(.ultraThinMaterial)
                
                ScrollView(.vertical){
                    VStack(spacing: 8){
                        VStack(alignment: .center, spacing: 5) {
                            Text("Tallinn")
                                .font(.system(size: 35))
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)
                            Text("\(viewModel.temperature)")
                                .font(.system(size: 80))
                                .foregroundStyle(.white)
                                .fontWeight(.light)
                                .opacity(getTitleOpactiy())
                            
                            Text("\(viewModel.condition)")
                                .foregroundStyle(.white)
                                .fontWeight(.semibold)
                                .font(.system(size: 20))
                                .opacity(getTitleOpactiy())
                            
                            HStack {
                                Text("H:\(viewModel.tempMax)")
                                Text("L:\(viewModel.tempMin)")
                            }
                            .font(.system(size: 20))
                            .foregroundStyle(.white)
                            .fontWeight(.semibold)
                            .opacity(getTitleOpactiy())
                        }
                        .shadow(radius: 5)
                        .offset(y: -offset)
                        .offset(y: offset > 0 ? (offset / size.width) * 100 : 0)
                        .offset(y: getTitleOffset())
                        
                        CustomStackView {
                            Label {
                                Text("HOURLY")
                            } icon: {
                                Image(systemName: "clock")
                            }
                        } contentView: {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 10) {
                                    ForEach(viewModel.dailyForecasts, id: \.dt_txt) { forecast in
                                        VStack {
                                            Text("\(viewModel.formatDate(from: forecast.dt_txt))")
                                                .fontWeight(.semibold)
                                            Image(systemName: viewModel.symbolForCondition(forecast.weather.first?.main ?? ""))
                                                .symbolRenderingMode(.multicolor)
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 35, height: 35)
                                            Text("\(Int(round(forecast.main.temp)))°")
                                                .fontWeight(.semibold)
                                        }
                                        .padding(.horizontal)
                                        .padding(.vertical, 10)
                                        .cornerRadius(10)
                                        .shadow(radius: 5)
                                    }
                                }
                            }
                        }
                        WeatherDataView(viewModelWD: viewModel)
                    }
                    .padding()
                    .padding(.top,topEdge)
                    .offsetChange { rect in
                        let minY = rect.minY
                        offset = minY
                    }
                }
                .scrollIndicators(.hidden)
            }
            .onAppear {
                viewModel.fetchWeather()
//                Timer.scheduledTimer(withTimeInterval: 3600, repeats: true) { _ in
//                    viewModel.fetchWeather()
//                    print("Weather Updated")
//                }
            }
        }
    }
    func getTitleOffset() -> CGFloat {
        if offset < 0 {
            let progress = -offset / 120
            let newOffset = (progress <= 1.0 ? progress : 1) * 20
            return -newOffset
        }
        
        return 0
    }
    
    func getTitleOpactiy() -> CGFloat {
        let titleOffset = -getTitleOffset()
        let progress = titleOffset / 20
        let opacity = 1 - progress
        
        return opacity
    }
}

#Preview {
    HomeView()
}

struct OffsetKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}

extension View {
    @ViewBuilder
    func offsetChange(offset: @escaping (CGRect) -> ()) -> some View {
        self
            .overlay {
                GeometryReader(content: { geometry in
                    let rect = geometry.frame(in: .global)
                    
                    Color.clear
                        .preference(key: OffsetKey.self, value: rect)
                        .onPreferenceChange(OffsetKey.self, perform: { value in
                            offset(value)
                        })
                })
            }
    }
}
