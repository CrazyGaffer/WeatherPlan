//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Roman Krusman on 06.03.2024.
//

import Foundation

class WeatherViewModel: ObservableObject {
    @Published var temperature: String = "--"
    @Published var condition: String = "__"
    @Published var tempMin: String = "--"
    @Published var tempMax: String = "--"
    @Published var humidity: String = "--"
    @Published var windSpeed: String = "--"
    @Published var gustSpeed: String = "--"
    @Published var feelsLike: String = "--"
    @Published var windDirection: String = "--"
    @Published var pressure: String = "--"
    @Published var name: String = "--"
    @Published var sunset: String = "--"
    @Published var sunrise: String = "--"
    @Published var pop: String = "--"
    @Published var dailyForecasts: [ForecastTimeSlot] = []
    
    func fetchWeather() {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/forecast?q=Tallinn&appid=73beda9f03d1f20f69eef6e23537bafe&units=metric") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            do {
                let weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    
                    if let firstForecast = weatherResponse.list.first {
                        self.temperature = "\(Int(round(firstForecast.main.temp)))°"
                        self.condition = firstForecast.weather.first?.main ?? "--"
                        self.tempMin = "\(Int(round(firstForecast.main.temp_min)))°"
                        self.tempMax = "\(Int(round(firstForecast.main.temp_max)))°"
                        self.humidity = "\(firstForecast.main.humidity)"
                        self.windSpeed = "\(Int(round(firstForecast.wind.speed * 3.6)))"
                        self.gustSpeed = firstForecast.wind.gust != nil ? "\(Int(round((firstForecast.wind.gust! * 3.6))))" : "--"
                        self.feelsLike = "\(Int(round(firstForecast.main.feels_like)))°"
                        self.windDirection = "\(Int(round(firstForecast.wind.deg)))°"
                        self.pressure = "\(firstForecast.main.pressure)"
                        self.pop = "\(Int(firstForecast.pop * 100))"
                    }
                    
                    self.name = weatherResponse.city.name
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "HH:mm"
                    self.sunset = dateFormatter.string(from: Date(timeIntervalSince1970: weatherResponse.city.sunset))
                    self.sunrise = dateFormatter.string(from: Date(timeIntervalSince1970: weatherResponse.city.sunrise))
                    
                    self.processForecasts(weatherResponse.list)
                }
            } catch {
                print("Decoding error: \(error)")
            }
        }
        
        task.resume()
    }
    
    func processForecasts(_ forecasts: [ForecastTimeSlot]) {
        let calendar = Calendar.current
        let now = Date()
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: now)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        self.dailyForecasts = forecasts.filter { forecast in
            guard let forecastDate = formatter.date(from: forecast.dt_txt) else { return false }
            return calendar.isDate(forecastDate, inSameDayAs: now) || (tomorrow != nil && calendar.isDate(forecastDate, inSameDayAs: tomorrow!))
        }
    }
    
    func formatDate(from dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date = inputFormatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "HH"
            return outputFormatter.string(from: date)
        } else {
            return "Unknown Date"
        }
    }
    
    func symbolForCondition(_ condition: String) -> String {
        switch condition {
        case "Clear":
            return "sun.max.fill"
        case "Clouds":
            return "cloud.fill"
        case "Rain":
            return "cloud.rain.fill"
        case "Thunderstorm":
            return "cloud.bolt.rain.fill"
        case "Snow":
            return "snow"
        case "Mist", "Smoke", "Haze", "Dust", "Fog":
            return "cloud.fog.fill"
        default:
            return "questionmark.circle.fill"
        }
    }
    
    func imageForCondition(_ condition: String) -> String {
        switch condition {
        case "Clear":
            return "clear"
        case "Clouds":
            return "sky"
        case "Rain":
            return "rain"
        default:
            return "night"
        }
    }
}

struct WeatherResponse: Codable {
    let list: [ForecastTimeSlot]
    let city: City
}

struct City: Codable {
    let name: String
    let sunrise: TimeInterval
    let sunset: TimeInterval
}

struct ForecastTimeSlot: Codable {
    let dt: TimeInterval
    let main: Main
    let weather: [Weather]
    let wind: Wind
    let dt_txt: String
    let pop: Double
}

struct Main: Codable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Int
    let humidity: Int
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct Wind: Codable {
    let speed: Double
    let gust: Double?
    let deg: Double
}



