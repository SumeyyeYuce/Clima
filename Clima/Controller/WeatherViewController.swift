//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    var locationManager = CLLocationManager() //Telefonun mevcut GPS verileri almaktan sorumlu olur.
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        //Bunu en başa yazmamızın nedeni Konumu talep etmeden önce, WeatherViewController'ı temsilci olarak ayarlamak gerektiğinden.
        locationManager.delegate = self
        
        //Kullanıcılardan Konumları için izin isteme
        locationManager.requestWhenInUseAuthorization()
        
        //Kullanıcının mevcut konumunun bir kerelik teslim edilmesini talep eder.
        locationManager.requestLocation()
        
        //weatherManager'ın delege özelliği nil olmaz
        
        weatherManager.delegate = self
        searchTextField.delegate = self
        
    }
    
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
        
    }
    
}

//MARK: - UITextFieldDelegete

extension WeatherViewController: UITextFieldDelegate {
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
        print(searchTextField.text!)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        print(searchTextField.text!)
        return true
    }
    
    //Burada klavyeden searche herhangi bir değişim yapılıp yapılmadığına bakılıyor.
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true //Değişime izin ver
        }
        else{
            textField.placeholder = "Type something"
            return false //Değişime izin verme
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //  searchTextField.text O şehrin hava durumunu almak için
        
        if let city = searchTextField.text {
            weatherManager.fetchWeather(cityName: city)
        }
        searchTextField.text = ""
    }
}

//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
            
        }
    }
    func didFailWithError(error: Error){
        print(error)
    }
}

//MARK: - CLLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude //Enlem
            let lon = location.coordinate.longitude //Boylam
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
