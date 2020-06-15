//
//  ViewController.swift
//  To Visit Places_Gagandeep kaur_C0770112
//
//  Created by Mac on 6/14/20.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit
import MapKit
class ViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mkMapView: MKMapView!
    let mLocationManager = CLLocationManager()
    let SPAN = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    @IBOutlet weak var mSegmentControl: UISegmentedControl!
    var mTransportType: MKDirectionsTransportType = .automobile
    var mCoordinates: CLLocationCoordinate2D?
    var index: Int?
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupLocationManager()
        addDoubleTapGesture()
        setupAnnotation()
        
        
        // Do any additional setup after loading the view.
    }
    
    func setupAnnotation()
    {
        if index != nil
        {
            let (lat, long, _) = Utilities.get(index: index!)
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            annotation.title = "My Destination"
            mkMapView.addAnnotation(annotation)
        }
    }
    
    func setupLocationManager()
    {
        mLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        mLocationManager.requestWhenInUseAuthorization()
    }
    
    func addDoubleTapGesture()
    {
        let tap_gesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureRecognized))
        tap_gesture.numberOfTapsRequired = 2
        mkMapView.addGestureRecognizer(tap_gesture)
    }
    
    @objc func tapGestureRecognized(gesture: UITapGestureRecognizer)
    {
        let touch_point = gesture.location(in: mkMapView)
        let coordinates = mkMapView.convert(touch_point,toCoordinateFrom: mkMapView)
        self.mCoordinates = coordinates
        let annotation = MKPointAnnotation()
        annotation.title = "My Destination"
        annotation.coordinate = coordinates
        mkMapView.removeAnnotations(mkMapView.annotations)
        mkMapView.addAnnotation(annotation)
    }
    
    
    @IBAction func FindMyWayClicked(_ sender: Any)
    {
        if let location = mLocationManager.location?.coordinate
        {
            let region = MKCoordinateRegion.init(center: location,span: SPAN)
            mkMapView.setRegion(region, animated: true)
        }
    }
    
    
    @IBAction func NavigateClicked(_ sender: Any)
        
    {
        if let destination = mCoordinates, let source = mLocationManager.location?.coordinate
        {
            mkMapView.removeOverlays(mkMapView.overlays)
            let request = createDirectionRequest(from: source,to: destination)
            let directions = MKDirections(request: request)
            directions.calculate { [unowned self] (response, error) in
                guard let response = response else
                {
                    //TODO: Alert user no response
                    return
                }
                
                for route in response.routes
                {
                    self.mkMapView.addOverlay(route.polyline)
                    self.mkMapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                }
            }
        }
        else
        {
            //TODO: Add Alert for destination or source error
        }
    }
    
    func createDirectionRequest(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> MKDirections.Request
    {
        let starting_location = MKPlacemark(coordinate: from)
        let destination = MKPlacemark(coordinate: to)
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: starting_location)
        request.destination = MKMapItem(placemark: destination)
        request.transportType = self.mTransportType
        request.requestsAlternateRoutes = false
        return request
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        if(mTransportType == .automobile)
        {
            renderer.strokeColor = .systemRed
        }
        else if(mTransportType == .walking)
        {
            renderer.strokeColor = .systemBlue
        }
        //        renderer.strokeColor = .systemRed
        return renderer
    }
    
    @IBAction func transportTypeChanged(_ sender: Any) {
        switch mSegmentControl.selectedSegmentIndex
        {
        case 0:
            self.mTransportType = .automobile
        case 1:
            self.mTransportType = .walking
        default:
            break
        }
    }
    
    @IBAction func ZoomIn(_ sender: Any) {
        var region: MKCoordinateRegion = mkMapView.region
        region.span.latitudeDelta /= 2.0
        region.span.longitudeDelta /= 2.0
        mkMapView.setRegion(region, animated: true)
    }
    
    @IBAction func ZoomOut(_ sender: Any)
    {
        var region: MKCoordinateRegion = mkMapView.region
        region.span.latitudeDelta = min(region.span.latitudeDelta * 2.0, 180.0)
        region.span.longitudeDelta = min(region.span.longitudeDelta * 2.0, 180.0)
        mkMapView.setRegion(region, animated: true)
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            return nil
        }
        let pinAnnotation = mkMapView.dequeueReusableAnnotationView(withIdentifier: "droppablePin") ?? MKPinAnnotationView()
        pinAnnotation.image = UIImage(named: "ic_place")
        pinAnnotation.canShowCallout = true
        let btn = UIButton(type: .detailDisclosure)
        btn.setImage(UIImage(systemName: "star"), for: .normal)
        pinAnnotation.rightCalloutAccessoryView = btn
        return pinAnnotation
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let destination = CLLocation(latitude: view.annotation!.coordinate.latitude, longitude: view.annotation!.coordinate.longitude)
        CLGeocoder().reverseGeocodeLocation(destination, completionHandler: {(placemarks, error) in
            if error != nil {
                print("Reverse geocoder failed with error" + error!.localizedDescription )
                return
            }
            if (placemarks != nil && placemarks?.count ?? 0 > 0)
            {
                let name = (placemarks?[0].subThoroughfare ?? " " ) + (placemarks?[0].thoroughfare ?? " ")
                Utilities.add(latitude: view.annotation!.coordinate.latitude, longitude: view.annotation!.coordinate.longitude, name: name)
            }
            
        })
    }
}
