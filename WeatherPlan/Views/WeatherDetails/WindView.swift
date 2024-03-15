//
//  WindView.swift
//  WeatherApplication
//
//  Created by Roman Krusman on 06.03.2024.
//

import SwiftUI

struct WindView: View {
    @ObservedObject var viewModel: WeatherViewModel

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                windSpeedView(speed: viewModel.windSpeed, label: "Wind")
                Divider()
                windSpeedView(speed: viewModel.gustSpeed, label: "Gusts")
            }
            .font(.system(size: 30))
            .fontWeight(.semibold)
            .foregroundStyle(.white)

            Spacer()

            if let rotationAngle = Double(viewModel.windDirection.trimmingCharacters(in: CharacterSet(charactersIn: "°"))) {
                VStack {
                    Image(systemName: "arrow.down")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.white)
                        .rotationEffect(.degrees(rotationAngle))
                }
                .padding()

            }
        }
    }

    @ViewBuilder
    private func windSpeedView(speed: String, label: String) -> some View {
        HStack {
            Text(speed)
                .frame(width: 40, alignment: .trailing)
            VStack(alignment: .leading){
                Text("KM/H")
                    .foregroundStyle(.secondary)
                    .font(.system(size: 16))
                Text(label)
                    .font(.system(size: 18))
            }
        }
    }
}

