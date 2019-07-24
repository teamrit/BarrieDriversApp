//
//  ViewController.swift
//  BarrieDriversApp
//
//  Created by Singh Singh on 2019-07-24.
//  Copyright © 2019 Amritpal Singh. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    var driverDetails = DriverDetails()
    var customAnnotation = CustomAnnotationCallout()
    let barrieLat = 44.3894
    let barrieLong = -79.6903
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setMapVariables()
        dealWithDrivers()
    }
    
    func generateRandomCoordinate() -> CLLocationCoordinate2D {
        let random1 = generateRandomNumber()
        let random2 = generateRandomNumber()
        
        let delta1 = 0.007 * random1
        let delta2 = 0.005 * random2
        
        let driverLocation = CLLocationCoordinate2D(latitude: barrieLat + delta1, longitude: barrieLong + delta2)
        
        return driverLocation
        
    }
    
    func generateRandomNumber() -> Double {
        let int = Int.random(in: -10...10)
        return Double(int)
    }
    
    func dealWithDrivers() {
        for driver in driverDetails.phoneNumbers {
            print(driver.key, " : ", driver.value)
            
            // Adding annotation for the map view
            let annotation = MKPointAnnotation()
            annotation.coordinate = generateRandomCoordinate()
            annotation.title = driver.key
            annotation.subtitle = driver.value

            mapView.addAnnotation(annotation)
        }
        
        mapView.register(CustomAnnotationCallout.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        
    }

    func setMapVariables() {
        // Barrie: 44.3894° N, 79.6903° W
        
        let centre : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: self.barrieLat,
                                                                     longitude: self.barrieLong)
        let deltaLat = 0.1
        let deltaLong = 0.1
        let coordinateSpan = MKCoordinateSpan(latitudeDelta: deltaLat, longitudeDelta: deltaLong)
        
        let region = MKCoordinateRegion(center: centre, span: coordinateSpan)
        
        self.mapView.setRegion(region, animated: true)
        
        let newRegion = MKCoordinateRegion(center: centre, span: MKCoordinateSpan(latitudeDelta: deltaLat * 0.5 , longitudeDelta: deltaLong * 0.5))
        
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { // Change `2.0` to the desired number of seconds.
//            // Code you want to be delayed
//            self.mapView.setRegion(newRegion, animated: true)
//        }
        
        
        
        
        
    }
    
    class CustomAnnotationCallout : MKMarkerAnnotationView {
        override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
            super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
            
            self.canShowCallout = true
            
            let callButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 20))
            callButton.setTitle("Call", for: .normal)
            callButton.setTitleColor(.black, for: .normal)
            callButton.addTarget(self, action: #selector(CustomAnnotationCallout.callPhoneNumber), for: .touchUpInside)
            self.rightCalloutAccessoryView = callButton
            //            self.calloutOffset(as)
            
        }
        
        @objc func callPhoneNumber(_sender: Any) {
            print("call the driver")
            let driverPhoneNumber = annotation?.subtitle!
            let urlString = "tel://\(driverPhoneNumber!)"
            
            if let url = URL(string: urlString) {
                UIApplication.shared.openURL(url)
            } else {
                print("bad number")
            }
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    

}

