//
//  CustomAnnotationView.swift
//  Parking
//
//  Created by Kseniia Piskun on 22.08.2024.
//

import MapKit

class CustomAnnotationView: MKAnnotationView {
    override var annotation: MKAnnotation? {
        didSet {
            self.image = resizeImage(image: UIImage(named: "Map_pin_icon")!, targetSize: CGSize(width: 24, height: 32))
            self.centerOffset = CGPoint(x: 0, y: -(image?.size.height ?? 32.0) / 2)
            self.canShowCallout = true
        }
    }

    private func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let rect = CGRect(origin: .zero, size: targetSize)
        UIGraphicsBeginImageContextWithOptions(targetSize, false, 0.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
