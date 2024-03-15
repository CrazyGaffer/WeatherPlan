//
//  WeatherDataView.swift
//  WeatherApplication
//
//  Created by Roman Krusman on 06.03.2024.
//

import SwiftUI

struct WeatherDataView: View {
    @ObservedObject var viewModelWD: WeatherViewModel
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                CustomStackView {
                    Label {
                        Text("FEELS LIKE")
                        
                    } icon: {
                        Image(systemName: "thermometer.medium")
                    }
                } contentView: {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(viewModelWD.feelsLike)
                            .font(.title)
                            .fontWeight(.semibold)
                        
                        Text("Lorem ipsum dolor sit amet.")
                            .font(.footnote)
                            .fontWeight(.semibold)
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity,maxHeight: .infinity, alignment: .leading)
                }
                CustomStackView {
                    Label {
                        Text("HUMIDITY")
                        
                    } icon: {
                        Image(systemName: "humidity")
                    }
                } contentView: {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("\(viewModelWD.humidity)%")
                            .font(.title)
                            .fontWeight(.semibold)
                        
                        Text("Lorem ipsum dolor sit amet.")
                            .font(.footnote)
                            .fontWeight(.semibold)
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity,maxHeight: .infinity, alignment: .leading)
                }
            }
            CustomStackView {
                Label {
                    Text("WIND")
                } icon: {
                    Image(systemName: "wind")
                }
            } contentView: {
                WindView(viewModel: viewModelWD)
            }
            HStack {
                CustomStackView {
                    Label {
                        Text("PRESSURE")
                        
                    } icon: {
                        Image(systemName: "barometer")
                    }
                } contentView: {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("\(viewModelWD.pressure) hPa")
                            .font(.title)
                            .fontWeight(.semibold)
                        
                        Text("Lorem ipsum dolor sit amet.")
                            .font(.footnote)
                            .fontWeight(.semibold)
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity,maxHeight: .infinity, alignment: .leading)
                }
                CustomStackView {
                    Label {
                        Text("VISIBILITY")
                        
                    } icon: {
                        Image(systemName: "eye.fill")
                    }
                } contentView: {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("\(viewModelWD.humidity) m")
                            .font(.title)
                            .fontWeight(.semibold)
                        
                        Text("Lorem ipsum dolor sit amet.")
                            .font(.footnote)
                            .fontWeight(.semibold)
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity,maxHeight: .infinity, alignment: .leading)
                }
            }
            HStack {
                CustomStackView {
                    Label {
                        Text("SUNSET")
                        
                    } icon: {
                        Image(systemName: "sunset.fill")
                    }
                } contentView: {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("\(viewModelWD.sunset)")
                            .font(.title)
                            .fontWeight(.semibold)
                        
                        Text("Lorem ipsum dolor sit amet \(viewModelWD.sunrise)")
                            .font(.footnote)
                            .fontWeight(.semibold)
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity,maxHeight: .infinity, alignment: .leading)
                }
                CustomStackView {
                    Label {
                        Text("PRECIPITATION")
                        
                    } icon: {
                        Image(systemName: "drop.fill")
                    }
                } contentView: {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("\(viewModelWD.pop)%")
                            .font(.title)
                            .fontWeight(.semibold)
                        
                        Text("Lorem ipsum dolor sit amet.")
                            .font(.footnote)
                            .fontWeight(.semibold)
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity,maxHeight: .infinity, alignment: .leading)
                }
            }
            CustomStackView {
                Label {
                    Text("REPORT AN ISSUE")
                    
                } icon: {
                    Image(systemName: "exclamationmark.bubble.fill")
                }
            } contentView: {
                VStack(alignment: .leading, spacing: 10) {
                    Text("You can describe the current contiditions at your local to help improve forecasts.")
                        .font(.footnote)
                        .fontWeight(.semibold)
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity,maxHeight: .infinity, alignment: .leading)
            }
            .onTapGesture {
                if let url = URL(string: "https://openweathermap.org/") {
                    UIApplication.shared.open(url)
                }
            }
            .frame(maxHeight: .infinity)
        }
    }
}

#Preview {
    HomeView()
}
