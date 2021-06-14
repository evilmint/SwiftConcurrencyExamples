//
//  ViewController.swift
//  Example 9 - AsyncSequence
//
//  Created by Aleksander Lorenc on 12/06/2021.
//

import UIKit

struct ViewModel {
    let weatherSupplier = WeatherSupplier()
}

class ViewController: UIViewController {
    @IBOutlet var temperatureLabel: UILabel!

    var fetchWeatherTask: Task.Handle<Void, Never>?

    let viewModel = ViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        startFetchingWeather()
    }

    private func startFetchingWeather() {
        guard fetchWeatherTask == nil else { return }

        fetchWeatherTask = async {
            for await weather in viewModel.weatherSupplier {
                updateWeather(weather)
            }
        }
    }

    @IBAction func startFetchingWeatherTouched(_ sender: Any) {
        startFetchingWeather()
    }

    @IBAction func stopFetchingWeatherTouched(_ sender: Any) {
        stopFetchingWeather()
    }

    private func stopFetchingWeather() {
        fetchWeatherTask?.cancel()
        fetchWeatherTask = nil
    }

    @MainActor
    func updateWeather(_ weather: Weather) {
        temperatureLabel.text = String(format: "%@ %.0f℃", weather.city, weather.temp)
    }
}
