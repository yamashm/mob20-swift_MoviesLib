//
//  MapViewController.swift
//  MoviesLib
//
//  Created by Usuário Convidado on 26/09/20.
//  Copyright © 2020 FIAP. All rights reserved.
//

import UIKit
import MapKit

final class MapViewController: UIViewController{
    
    // MARK: - IBOutlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Properties
    lazy var locationManager = CLLocationManager();
    
    // MARK: - Super Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        requestAuthorization()
    }
    
    // MARK: - IBActions
    
    // MARK: - Methods
    private func setupView(){
        mapView.mapType = .standard
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        mapView.delegate = self
        searchBar.delegate = self
        
    }
    
    private func requestAuthorization(){
        
        locationManager.requestWhenInUseAuthorization()
    }
}

extension MapViewController: MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.lineWidth = 7.0
        renderer.strokeColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        return renderer
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        let camera  = MKMapCamera()
        camera.centerCoordinate = view.annotation!.coordinate
        camera.pitch = 80
        camera.altitude = 100
        mapView.setCamera(camera, animated: true)
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: mapView.userLocation.coordinate))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: view.annotation!.coordinate))
        
        let directions = MKDirections(request: request)
        directions.calculate{ (response, error) in
            if error == nil {
                guard let response = response, let route = response.routes.sorted(by: {$0.distance < $1.distance}).first else {return}
                print("Nome:", route.name)
                print("Distancia:", route.distance)
                print("Duracao:", route.expectedTravelTime)
                for step in route.steps {
                    print("Em", step.distance, "metros", step.instructions)
                }
                self.mapView.removeOverlays(self.mapView.overlays)
                self.mapView.addOverlay(route.polyline, level: .aboveRoads)
            }
        }
    }
}

extension MapViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder() //Tira foco da search bar
        
        let request = MKLocalSearch.Request()
        request.region = mapView.region
        request.naturalLanguageQuery = searchBar.text
        
        let search = MKLocalSearch(request: request)
        search.start{ (response, error) in
            if error == nil{
                guard let response = response else {return}
                self.mapView.removeAnnotations(self.mapView.annotations)
                for item in response.mapItems {
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = item.placemark.coordinate
                    annotation.title = item.name
                    annotation.subtitle = item.url?.absoluteString
                    self.mapView.addAnnotation(annotation)
                }
                self.mapView.showAnnotations(self.mapView.annotations, animated: true)
            }
        }
    }
}
