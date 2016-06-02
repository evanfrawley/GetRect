//
//  MapViewController.swift
//  GetRect
//
//  Created by Evan on 6/1/16.
//  Copyright © 2016 iGuest. All rights reserved.
//

import UIKit
import Mapbox

class MapViewController: UIViewController, MGLMapViewDelegate {

    

    @IBOutlet weak var toolbar: UIToolbar!
    var mapView:MGLMapView!
    @IBOutlet weak var container: UIView!
    let mbStyle:NSURL = NSURL(string: "mapbox://styles/mapbox/dark-v9")!
    var centerPt:CLLocationCoordinate2D = CLLocationCoordinate2D()
    var centerAnnotation:MGLPointAnnotation = MGLPointAnnotation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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

    
    @IBAction func testButton(sender: AnyObject) {
        let test = mapView.centerCoordinate
        print("\(test.latitude), \(test.longitude)")
    }
    
    func mapViewRegionIsChanging(mapView: MGLMapView) {
        mapView.removeAnnotation(self.centerAnnotation)
        self.centerAnnotation.coordinate = mapView.centerCoordinate
        mapView.addAnnotation(self.centerAnnotation)
    }
    
    func mapView(mapView: MGLMapView, regionDidChangeAnimated animated: Bool) {
        self.centerPt = mapView.centerCoordinate
        mapView.removeAnnotation(self.centerAnnotation)
        self.centerAnnotation.coordinate = mapView.centerCoordinate
        mapView.addAnnotation(self.centerAnnotation)
        
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
