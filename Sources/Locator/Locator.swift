import CoreLocation
import Combine

public typealias Coordinate = (lat: Double, lon: Double)

public class Locator: NSObject, ObservableObject {
    
    public static var _currentCity: CurrentValueSubject<String, Never> = .init("-")
    
    private let manager: CLLocationManager = .init()
    private let geoCoder: CLGeocoder = .init()
    
    public var currentLocationUpdate: PassthroughSubject<Coordinate, Never> = .init()
    public var statusUpdate: PassthroughSubject<CLAuthorizationStatus, Never> = .init()
    public var currenLocation: Coordinate?
    public var currentCity: String = "-"
    public var status: CLAuthorizationStatus {
        return manager.authorizationStatus
    }
    
    public var isAuthorized: Bool {
        return isAuthorizedAlways || isAuthorizedWhenInUse
    }
    
    public var isAuthorizedAlways: Bool {
        return status == .authorizedAlways
    }
    public var isAuthorizedWhenInUse: Bool {
        return manager.authorizationStatus == .authorizedWhenInUse
    }
    
    public override init() {
        super.init()
        manager.delegate = self
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }
}

extension Locator: CLLocationManagerDelegate {
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else  { return }
        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude
        geoCoder.reverseGeocodeLocation(location) { [weak self] placemark, _ in
            if let city = placemark?[0].locality {
                self?.currentCity = city
                Locator._currentCity.send(city)
            }
        }
        
        let cooridante = (lat: lat, lon: lon)
        currenLocation = cooridante
        currentLocationUpdate.send(cooridante)
        currentLocationUpdate.send(completion: .finished)
    }
    
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        guard manager.authorizationStatus != .notDetermined else { return }
        statusUpdate.send(manager.authorizationStatus)
    }
    
}
