//
//  ViewController.swift
//  Memory
//
//  Created by Yuhyun Chung on 11/11/18.
//  Copyright © 2018 Yuhyun Chung. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Alamofire

class LocationAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?){
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        
        super.init()
    }
}

class ViewController: UIViewController, UISearchBarDelegate {

    // singleton for userdata.
    var model:UserData?
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var longtitudeLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    
    let locationManager = CLLocationManager()
    var pinView : MKAnnotationView!
    
    var displayLongtitude: String = ""
    var displayLatitude: String = ""
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        mapView.delegate = self
        
        model = UserData.sharedInstance
        mapView.mapType = MKMapType.standard

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        
        // initialize with my current Location.
         checkLocationServices()
        
        if CLLocationManager.locationServicesEnabled(){
            print("hello")
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
        else{
            //initialize with my current Location.
            checkLocationServices()
        }
        
        
        

        

        
    }
    
    @IBAction func addPin(_ sender: UILongPressGestureRecognizer) {
        
        let location = sender.location(in: self.mapView)
        let locCoord = self.mapView.convert(location, toCoordinateFrom: self.mapView)
        
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = locCoord
        displayLongtitude = String(format:"%f", locCoord.longitude);
        longtitudeLabel.text = displayLongtitude;
        displayLatitude = String(format:"%f", locCoord.latitude)
        latitudeLabel.text = displayLatitude;
        
        annotation.title = "Store"
        annotation.subtitle = "Location of sotre"
        
        //self.mapView.removeAnnotation(mapView.annotations as! MKAnnotation)
        self.mapView.addAnnotation(annotation)
        
        performSegue(withIdentifier: "AddPlaceSegue", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "AddPlaceSegue", let PlaceSaveViewController = segue.destination as? PlaceSaveViewController{
            PlaceSaveViewController.displayLatitude = self.displayLatitude
            PlaceSaveViewController.displayLongtitude = self.displayLongtitude
        }
    }
    
    @IBAction func getMyLocation(_ sender: UIButton) {
        let status  = CLLocationManager.authorizationStatus()
        
        if status == .notDetermined {
        locationManager.requestWhenInUseAuthorization()
            return
        }
        else if status == .denied || status == .restricted {
            let alert = UIAlertController(title: "Location Services Disabled", message: "Please enable Location Services in Settings", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            
            present(alert, animated: true, completion: nil)
            return
        }
        
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    
    // search
    
    @IBAction func searchButton(_ sender: UIBarButtonItem) {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // Start to ignore user.
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        // Activity Indicator
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        
        self.view.addSubview(activityIndicator)
        
        // Hide search bar
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        
        // Create the search request
        let searchRequest = MKLocalSearchRequest()
        searchRequest.naturalLanguageQuery = searchBar.text
        
        let activeSearch = MKLocalSearch(request: searchRequest)
        
        activeSearch.start { (response, error) in
            
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            
            if response == nil {
                print("Error")
                // I can pop an alert
            } else {
                // have actual result
                // Remove annotations
                
                //let annotations = self.mapView.annotations
                //self.mapView.removeAnnotation(annotations as! MKAnnotation)
                
                // Getting data
                let latitude = response?.boundingRegion.center.latitude
                let longitude = response?.boundingRegion.center.longitude
                
                // Create annotation
                let annotation = MKPointAnnotation()
                annotation.title = searchBar.text
                annotation.coordinate = CLLocationCoordinate2DMake(latitude!, longitude!)
                self.mapView.addAnnotation(annotation)
                
                // Zooming in on annotation
                let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude!, longitude!)
                let span = MKCoordinateSpanMake(0.1,0.1)
                let region = MKCoordinateRegionMake(coordinate,span)
                self.mapView.setRegion(region, animated: true)
            }
            
        }
    }
    
    func setupLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func centerViewOnUserLocation() {
        mapView.userTrackingMode = .follow
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled(){
            setupLocationManager()
            checkLocationAuthorization()
        } else{
            print("hey")
        }
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
            break
        case .denied:
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            break
        case .authorizedAlways:
            break
        }
    }

}

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        mapView.userTrackingMode = .follow
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}

extension ViewController: MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation.isMember(of: MKUserLocation.self){
            return nil
        }
        
        let reuseId = "ProfilePinView"
        
        pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        if pinView == nil {
            pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        }
        
        pinView.canShowCallout = true
        pinView.isDraggable = true
        
        pinView.image = UIImage(named: "pin")
        
        return pinView
        
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationViewDragState, fromOldState oldState:MKAnnotationViewDragState){
        
        if newState == MKAnnotationViewDragState.ending{
            if let coordinate = view.annotation?.coordinate{
                
                print(coordinate.latitude)
                
                view.dragState = MKAnnotationViewDragState.none
            }
        }
        
    }
    
    @objc func mapView(_ rendererForMapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer{
        
        let renderer = MKCircleRenderer(overlay: overlay)
        renderer.fillColor = UIColor.black.withAlphaComponent(0.5)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 2
        return renderer
    }
}

