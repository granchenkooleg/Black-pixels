//
//  UIImage+Ext.swift
//  TC
//
//  Created by Oleg Granchenko on 22.04.2021.
//

import UIKit

extension UIImage {
    var blackPixelCount: Int {
        var count = 0
        for x in 0..<Int(size.width) {
            for y in 0..<Int(size.height) {
                count = count + (isPixelBlack(CGPoint(x: CGFloat(x), y: CGFloat(y))) ? 1 : 0)
            }
        }

        return count
    }

    private func isPixelBlack(_ point: CGPoint) -> Bool {
        let pixelData = cgImage?.dataProvider?.data
        let pointerData: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)

        let pixelInfo = Int(((size.width * point.y) + point.x)) * 4

        let maxValue: CGFloat = 255.0
        let compare: CGFloat = 0.3 //Tolerance

        if (CGFloat(pointerData[pixelInfo]) / maxValue) > compare { return false }
        if (CGFloat(pointerData[pixelInfo + 1]) / maxValue) > compare { return false }
        if (CGFloat(pointerData[pixelInfo + 2]) / maxValue) > compare { return false }

        return true
    }
    
    func resizedImage( for size: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { (context) in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
