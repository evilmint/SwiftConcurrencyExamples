//
//  ViewController.swift
//  Example 7 - Structured Concurrency
//
//  Created by Aleksander Lorenc on 08/06/2021.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var tableView: UITableView!

    var weathers: [Weather] = []
    var fetchWeatherHandle: Task.Handle<Void, Never>?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = UIRefreshControl(frame: .zero, primaryAction: UIAction(handler: { [weak self] _ in
            self?.fetchWeather()
        }))
        fetchWeather()
    }

    fileprivate func fetchWeather() {
        // Cancel previous weather fetching if it hasn't yet completed
        fetchWeatherHandle?.cancel()

        // Assign a new task to the local task handle
        fetchWeatherHandle = async {
            await withThrowingTaskGroup(of: Weather.self) { group in
                var weathers: [Weather] = []

                // Spawn a task which fetches weather for each city
                for city in City.someList {
                    // If the task is cancelled - break and stop further execution
                    if Task.isCancelled {
                        // Refresh quickly multiple times to observe the behavior.
                        // Additionally you can use the proxy to see whether the requests
                        // did not actually fire
                        print("Cancelling")
                        break
                    }

                    group.async {
                        return try await self.getWeatherForCity(city)
                    }
                }

                do {
                    // Collect results from spawned tasks
                    for try await weather in group {
                        weathers.append(weather)
                    }
                } catch {
                    // Handle error in the future
                }


                if Task.isCancelled {
                    print("Cancelling")
                    return
                }

                updateWeathers(weathers)
            }
        }
    }

    // Update weathers on the main actor (main queue)
    @MainActor func updateWeathers(_ weathers: [Weather]) {
        self.weathers = weathers.sorted { $0.name < $1.name }

        tableView.refreshControl?.endRefreshing()
        tableView.reloadData()
    }

    func getWeatherForCity(_ city: City) async throws -> Weather {
        // Please replace with your own API key - this should be used for single or a few
        // refreshes.
        let apiKey = "99330a144e77d86e783a108ebc92d559"
        var urlComponents = URLComponents(string: "https://api.openweathermap.org/data/2.5/weather")!
        urlComponents.queryItems = [
            .init(name: "q", value: city.name),
            .init(name: "appid", value: apiKey)
        ]

        let url = urlComponents.url!

        // Fetches data using the new URLSession async methods
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(Weather.self, from: data)
    }

    @IBAction func refreshButtonTapped(_ sender: Any) {
        fetchWeather()
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath) as! WeatherCell

        let weather = weathers[indexPath.row]
        cell.configure(with: weather)

        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        weathers.count
    }
}

extension ViewController: UITableViewDelegate {}
