//
//  MapTransform.swift
//  UWP-Navigation-iOS
//
//  Created by Kyle Zawacki on 6/29/15.
//  Copyright © 2015 App Factory. All rights reserved.
//
//  This class contains all of the important logic for dealing with the Google Map view, from populating the map with all of the zone polygon overlays
// to recognizing and responding to touches on said overlays or on Parkside buildings.

import UIKit

class MapTransform: MapObject, GMSMapViewDelegate
{
    // MARK: Properties
    var map:GMSMapView?
    var parkingZoneList:[ZonePolygon]?
    var buidlingZoneList:[ZonePolygon]?
    var passedViewController:MainViewController?
    
    // MARK: Map Initialization
    func setupMapWithParent(controller:MainViewController)
    {
        let camera:GMSCameraPosition = GMSCameraPosition.cameraWithLatitude(Constants.DEFAULT_CAMERA_LAT, longitude: Constants.DEFAULT_CAMERA_LON, zoom: 17)
        
        self.map = GMSMapView.mapWithFrame(self.frame, camera: camera)
        self.map!.delegate = self
        self.addSubview(self.map!)
        self.passedViewController = controller
                
        buildPolymap()
    }
    
    func buildPolymap()
    {
        let polyfactory:Polyfactory = Polyfactory()
        self.parkingZoneList = polyfactory.parkingZones
        self.buidlingZoneList = polyfactory.buildingZones
        
        for zonePoly:ZonePolygon in self.parkingZoneList!
        {
            zonePoly.polygon!.strokeColor = UIColor.blackColor()
            zonePoly.polygon!.map = self.map
            
            print(zonePoly.id!)
        }
        
        for buildingPoly:ZonePolygon in self.buidlingZoneList!
        {
            buildingPoly.polygon!.fillColor = UIColor.clearColor()
            buildingPoly.polygon!.map = self.map
            print(buildingPoly.id!)
        }
    }
    
    func colorMap(withFullnessAndConfidenceLevels fullnessConfidenceStrings:[String])
    {
        for(var i = 0; i < fullnessConfidenceStrings.count; i++)
        {
            let levels = fullnessConfidenceStrings[i]
            let fullnessString:String = levels.componentsSeparatedByString(",")[0]
            let confidenceString:String = levels.componentsSeparatedByString(",")[1]
            
            let fullness:Int = Int(fullnessString)!
            let confidence:Int = Int(confidenceString)!
            
            if let zone:ZonePolygon = self.parkingZoneList![i]
            {
                if (fullness > 66) {
                    zone.polygon!.fillColor = UIColor.redColor()
                }
                else if (fullness >= 33 && fullness <= 66) {
                    zone.polygon!.fillColor = UIColor.yellowColor()
                }
                else if(fullness < 33) {
                    zone.polygon!.fillColor = UIColor.greenColor()
                }
            }
            
//            if (Double.valueOf(confidence) > 66) {
//                this.color = Color.argb(255, Color.red(color), Color.green(color), Color.blue(color));
//            }
//            if (Double.valueOf(confidence) >= 33 && Double.valueOf(confidence) <= 66) {
//                this.color = Color.argb(170, Color.red(color), Color.green(color), Color.blue(color));
//            }
//            if (Double.valueOf(confidence) < 33) {
//                this.color = Color.argb(85, Color.red(color), Color.green(color), Color.blue(color));
//            }
//            if (Double.valueOf(fullness) == -1) {
//                this.color = Color.DKGRAY;
//            }
        }
    }
    
    // MARK: Map Interaction
    func mapView(mapView: GMSMapView!, didTapOverlay overlay: GMSOverlay!)
    {
        let zoneTapped:ZonePolygon? = getZoneTapped(withOverlayTapped: overlay)
        
        if let zone = zoneTapped
        {
            print(zone.id!)
            self.passedViewController?.displayAlertForZone(zone)
        } else
        {
            print("Nothing")
        }
        
    }
    
    func getZoneTapped(withOverlayTapped overlay:GMSOverlay) -> ZonePolygon?
    {
        for zone:ZonePolygon in self.parkingZoneList!
        {
            if(zone.polygon == overlay)
            {
                return zone
            }
        }
        
        for zone:ZonePolygon in self.buidlingZoneList!
        {
            if(zone.polygon == overlay)
            {
                return zone
            }
        }
        
        return nil
    }
    
    
}
