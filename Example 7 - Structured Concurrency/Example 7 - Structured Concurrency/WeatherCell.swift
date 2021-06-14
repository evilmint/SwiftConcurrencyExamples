//
//  WeatherCell.swift
//  Example 7 - Structured Concurrency
//
//  Created by Aleksander Lorenc on 10/06/2021.
//

import Foundation
import UIKit

class WeatherCell: UITableViewCell {
    @IBOutlet var descriptionLabel: UILabel!

    func configure(with weather: Weather) {
        descriptionLabel?.text = String(format: "%@ - %.0f℃", weather.name, weather.degreesCelsius)
    }
}
