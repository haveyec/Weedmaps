//
//  LocationManager.swift
//  WeedmapsChallenge
//
//  Created by Havic on 4/18/19.
//  Copyright © 2019 Weedmaps, LLC. All rights reserved.
//

import UIKit
import CoreLocation

class WMLocationManager: UIViewController, CLLocationManagerDelegate {
	let manager = CLLocationManager()


	override func viewDidLoad() {
		super.viewDidLoad()


		//For use when the app is open & in background
		manager.requestAlwaysAuthorization()

		if CLLocationManager.locationServicesEnabled(){
			manager.delegate = self
			manager.desiredAccuracy = kCLLocationAccuracyBest
			manager.startUpdatingLocation()
		}

	}

	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		if let location = locations.first{
			print(location)
		}
	}


	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		if status == .authorizedAlways {

		}
	}

	
}
