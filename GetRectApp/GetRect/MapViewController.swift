//
//  MapViewController.swift
//  GetRect
//
//  Created by Evan on 6/1/16.
//  Copyright © 2016 iGuest. All rights reserved.
//

import UIKit
import Mapbox
import MapKit

class MapViewController: UIViewController, MGLMapViewDelegate {

    @IBOutlet weak var toolbar: UIToolbar!
    var mapView:MGLMapView!
    let mbStyle:NSURL = NSURL(string: "mapbox://styles/mapbox/dark-v9")!
    var centerPt:CLLocationCoordinate2D = CLLocationCoordinate2D()
    var centerAnnotation:MGLPointAnnotation = MGLPointAnnotation()
    var centerCircle:MGLPolygon = MGLPolygon()
    
    @IBOutlet weak var radiusSlider: UISlider!
    
    var rad:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.rad = Int(self.radiusSlider.value * 100)
        mapView = MGLMapView(frame: view.bounds)
        mapView.styleURL = mbStyle
        mapView.setCenterCoordinate(CLLocationCoordinate2DMake(47.6062, -122.3321), zoomLevel: 11.0, animated: false)

        mapView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        print("before")
        let pt = MGLPointAnnotation()
        pt.coordinate = CLLocationCoordinate2D(latitude: 47.6062, longitude: -122.3321)
        view.insertSubview(mapView, atIndex:0)
        
        
        print("afteR")
        // remember to set the delegate (or much of this will not work)
        mapView.delegate = self

    }
    
    func mapViewRegionIsChanging(mapView: MGLMapView) {
        updateMap()
    }
    @IBAction func sliderValueChanged(sender: AnyObject) {
        self.rad = Int(self.radiusSlider.value) * 100
        updateMap()
    }
    
    func mapView(mapView: MGLMapView, regionDidChangeAnimated animated: Bool) {
        updateMap()
        DB.sharedInstance.updateFromMap(self.rad, loc: self.centerPt)
    }
    
    func updateMap(){
        self.centerPt = mapView.centerCoordinate
        mapView.removeAnnotation(self.centerAnnotation)
        mapView.removeAnnotation(self.centerCircle)
        self.centerAnnotation.coordinate = mapView.centerCoordinate
        mapView.addAnnotation(self.centerAnnotation)
        self.centerCircle = polygonCircleForCoordinate(self.centerAnnotation.coordinate, withMeterRadius: Double(self.rad))
        mapView.addAnnotation(self.centerCircle)
    }
    
    func polygonCircleForCoordinate(coordinate: CLLocationCoordinate2D, withMeterRadius: Double) ->MGLPolygon {
        let degreesBetweenPoints = 8.0
        let numberOfPoints = floor(360.0 / degreesBetweenPoints)
        let distRadians: Double = withMeterRadius / 6371000.0
        let centerLatRadians: Double = coordinate.latitude * M_PI / 180
        let centerLonRadians: Double = coordinate.longitude * M_PI / 180
        var coordinates = [CLLocationCoordinate2D]()
        
        for index in 0 ..< Int(numberOfPoints) {
            let degrees: Double = Double(index) * Double(degreesBetweenPoints)
            let degreeRadians: Double = degrees * M_PI / 180
            let pointLatRadians: Double = asin(sin(centerLatRadians) * cos(distRadians) + cos(centerLatRadians) * sin(distRadians) * cos(degreeRadians))
            let pointLonRadians: Double = centerLonRadians + atan2(sin(degreeRadians) * sin(distRadians) * cos(centerLatRadians), cos(distRadians) - sin(centerLatRadians) * sin(pointLatRadians))
            let pointLat: Double = pointLatRadians * 180 / M_PI
            let pointLon: Double = pointLonRadians * 180 / M_PI
            let point: CLLocationCoordinate2D = CLLocationCoordinate2DMake(pointLat, pointLon)
            coordinates.append(point)
        }
        
        let polygon = MGLPolygon(coordinates: &coordinates, count: UInt(coordinates.count))
        return polygon
    }
    
    func mapView(mapView: MGLMapView, alphaForShapeAnnotation annotation: MGLShape) -> CGFloat {
        return 0.5
    }
    func mapView(mapView: MGLMapView, strokeColorForShapeAnnotation annotation: MGLShape) -> UIColor {
        return UIColor.whiteColor()
    }
    
    func mapView(mapView: MGLMapView, fillColorForPolygonAnnotation annotation: MGLPolygon) -> UIColor {
        return UIColor(red: 59/255, green: 178/255, blue: 208/255, alpha: 1)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
