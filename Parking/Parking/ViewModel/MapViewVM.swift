//
//  MapViewVM.swift
//  Parking
//
//  Created by Kseniia Piskun on 21.08.2024.
//

import MapKit

class MapViewVM {
    enum ParkingAction {
        case start
        case end
        case noZone
    }

    enum ParkingState {
            case notStarted
            case started
        case ended
        }

    private let jsonLoader = JSONLoader()
    private(set) var locationData: LocationData?
    private(set) var selectedZone: Zone?
    var parkingState: ParkingState = .notStarted
    var mapPin: CustomAnnotation = CustomAnnotation(coordinate: CLLocationCoordinate2D(), title: Consts.Strings.noZoneSelectedTitle, subtitle: Consts.Strings.noZoneSelectedSubtitle)
    
    func loadData(completion: @escaping () -> Void) {
        if let data = jsonLoader.loadJSONData(from: "data") {
            if let rootData = jsonLoader.parseJSON(jsonData: data) {
                self.locationData = rootData.locationData
            }
        }
        completion()
    }
    
    func getRegion() -> MKCoordinateRegion? {
        guard let locationData = locationData else { return nil }
        let bounds = locationData.bounds
        return MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: (bounds.north + bounds.south) / 2,
                                                                 longitude: (bounds.west + bounds.east) / 2),
                                  span: MKCoordinateSpan(latitudeDelta: bounds.north - bounds.south,
                                                         longitudeDelta: bounds.east - bounds.west))
    }
    
    func createOverlays() -> [MKPolygon] {
        guard let locationData = locationData else { return [] }
        return locationData.zones.map { zone in
            let polygon = zone.polygonMK
            polygon.title = zone.id
            return polygon
        }
    }
    
    func updateSelectedZone(mapCenter: CLLocationCoordinate2D) -> Zone? {
        guard let locationData = locationData else { return nil }
        for zone in locationData.zones {
            let polygon = zone.polygonMK
            let renderer = MKPolygonRenderer(polygon: polygon)
            let mapPoint = MKMapPoint(mapCenter)
            let point = renderer.point(for: mapPoint)
            if renderer.path.contains(point) {
                selectedZone = zone
                return zone
            }
        }
        selectedZone = nil
        return nil
    }
    
    func isParkingAvailable() -> Bool {
        return selectedZone?.paymentIsAllowed == "1"
    }
}
