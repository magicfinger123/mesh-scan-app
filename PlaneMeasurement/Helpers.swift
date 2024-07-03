//
//  Helpers.swift
//  PlaneMeasurement
//
//  Created by Adwith Mukherjee on 6/16/24.
//

import UIKit
import SceneKit

func skPoint(_ point: CGPoint) -> CGPoint {
    let height = UIScreen.main.bounds.height
    return CGPoint(x: point.x, y: height - point.y) // Adjust the y-coordinate to flip the origin.
}

func calculateDistanceInInches(from position1: SCNVector3, to position2: SCNVector3) -> Float {
    let distance = simd_distance(simd_float3(position1), simd_float3(position2))
    return distance * 100 * 0.3937
}

func calculateDistance(from p1: CGPoint, p2: CGPoint)  -> Float{
    let xDist = (p2.x - p1.x); //[2]
    let yDist = (p2.y - p1.y); //[3]
    let distance = sqrt((xDist * xDist) + (yDist * yDist));
    let ppi: CGFloat = 476  // PPI for iPhone 13 mini
    let distanceInInches = pointsToInches(points: distance, ppi: ppi)
    return Float(distanceInInches)
}
func pointsToInches(points: CGFloat, ppi: CGFloat) -> CGFloat {
    return points / ppi
}

typealias Float2 = SIMD2<Float>
typealias Float3 = SIMD3<Float>

extension Float {
    static let degreesToRadian = Float.pi / 180
}

extension matrix_float3x3 {
    mutating func copy(from affine: CGAffineTransform) {
        columns.0 = Float3(Float(affine.a), Float(affine.c), Float(affine.tx))
        columns.1 = Float3(Float(affine.b), Float(affine.d), Float(affine.ty))
        columns.2 = Float3(0, 0, 1)
    }
}
