//
//  MapObject.swift
//  UWP-Navigation-iOS
//
//  Created by Kyle Zawacki on 6/29/15.
//  Copyright © 2015 App Factory. All rights reserved.
//
//  Class currently defunt until further notice

import UIKit

class MapObject: UIView
{
    
    func pointInPolygon(withPoint point:CLLocationCoordinate2D, andPolygon polygon:GMSPolygon) -> Bool
    {
        // ray casting alogrithm http://rosettacode.org/wiki/Ray-casting_algorithm
        var crossings:Int = 0
        let path:GMSPath = polygon.path
        
        for i in 0 ..< path.count()
        {
            let coordA:CLLocationCoordinate2D = path.coordinateAtIndex(i)
            var j = i + 1
            
            //to close the last edge, you have to take the first point of your polygon
            if j >= path.count()
            {
                j = 0
            }
            
            let coordB:CLLocationCoordinate2D = path.coordinateAtIndex(j)
            
            
            if(rayCrossesSegment(inPoint: point, fromA: coordA, toB: coordB))
            {
                crossings++
            }
        }
        
        return (crossings % 2 == 1)
    }
    
    /**
    * Ray Casting algorithm checks, for each segment, if the point is 1) to the left of the segment
    * and 2) not above nor below the segment. If these two conditions are met, it returns true
    * */
    func rayCrossesSegment(inPoint point:CLLocationCoordinate2D, fromA a:CLLocationCoordinate2D, toB b:CLLocationCoordinate2D) -> Bool
    {
        var px:Double = point.longitude
        var py:Double = point.latitude
        
        var ax:Double = a.longitude
        var ay:Double = a.latitude
        
        var bx:Double = b.longitude
        var by:Double = b.latitude
        
        if (ax > by)
        {
            ax = b.longitude;
            ay = b.latitude;
            bx = a.longitude;
            by = a.latitude;
        }
        
        // alter longitude to cater for 180 degree crossings
        if (px < 0 || ax < 0 || bx < 0)
        {
            px += 360;
            ax += 360;
            bx += 360;
        }
        
        // if the point has the same latitude as a or b, increase slightly py
        if(py == ay || py == by)
        {
            py += 0.00000001
        }
        
        
        // if the point is above, below or to the right of the segment, it returns false
        if ((py > by || py < ay) || (px > max(ax, bx)))
        {
            return false;
        } else if (px < min(ax, bx)) // if the point is not above, below or to the right and is to the left, return true
        {
            return true;
        } else
        {
            let red:Double = (ax != bx) ? ((by - ay) / (bx - ax)) : Double.infinity;
            let blue:Double = (ax != px) ? ((py - ay) / (px - ax)) : Double.infinity;
            return (blue >= red);
        } // if the two above conditions are not met, you have to compare the slope of segment [a,b] (the red one here) and segment [a,p] (the blue one here) to see if your point is to the left of segment [a,b] or not
    }
    
}
