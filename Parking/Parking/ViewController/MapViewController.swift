//
//  MapViewController.swift
//  Parking
//
//  Created by Kseniia Piskun on 20.08.2024.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    private var viewModel = MapViewVM()
    var mapPinView: MKAnnotationView?
    var isRegionChangeFromUserInteraction = false
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var outputLabel: UILabel!
    @IBOutlet private weak var parkingButton: UIButton!
    @IBAction private func parkingActionTapped(_ sender: Any) {
        startParkingTapped()
    }
    @IBAction private func zoomOutTapped(_ sender: Any) {
        var region = mapView.region
        region.span.latitudeDelta = min(region.span.latitudeDelta * 2.0, 180.0)
        region.span.longitudeDelta = min(region.span.longitudeDelta * 2.0, 180.0)
        mapView.setRegion(region, animated: true)
    }
    @IBAction private func zoomInTapped(_ sender: Any) {
        var region = mapView.region
        region.span.latitudeDelta /= 2.0
        region.span.longitudeDelta /= 2.0
        mapView.setRegion(region, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        setupPin()
        loadData()
    }
    
    private func loadData() {
        viewModel.loadData { [weak self] in
            guard let self = self else { return }
            if let region = self.viewModel.getRegion() {
                self.mapView.setRegion(region, animated: true)
            }
            self.drawZones()
        }
    }

    // MARK: - MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polygon = overlay as? MKPolygon else {
            return MKOverlayRenderer(overlay: overlay)
        }

        let renderer = MKPolygonRenderer(polygon: polygon)
        renderer.strokeColor = Consts.Colors.strokeColor
        renderer.lineWidth = Consts.Values.strokeLineWidth

        renderer.fillColor = fillColor(for: polygon)
        return renderer
    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        mapPinView?.isHidden = true
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        mapPinView?.isHidden = false
        
        let newCoordinate = mapView.centerCoordinate
        viewModel.mapPin.coordinate = newCoordinate
        
        updateSelectedZone(at: newCoordinate)
        
        mapView.selectAnnotation(viewModel.mapPin, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "CustomPin"
        
        if annotation is CustomAnnotation {
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? CustomAnnotationView
            
            if annotationView == nil {
                annotationView = CustomAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
            } else {
                annotationView?.annotation = annotation
            }
            
            mapPinView = annotationView
            
            return annotationView
        }
        
        return nil
    }
    
    // MARK: - Helpers
    
    private func drawZones() {
        mapView.removeOverlays(mapView.overlays)
        let overlays = viewModel.createOverlays()
        mapView.addOverlays(overlays)
    }
    
    private func setupPin() {
        viewModel.mapPin = CustomAnnotation(coordinate: mapView.centerCoordinate, title: Consts.Strings.noZoneSelectedTitle, subtitle: Consts.Strings.noZoneSelectedSubtitle)
        mapView.addAnnotation(viewModel.mapPin)
    }
    
    private func startParkingTapped() {
        guard let selectedZone = viewModel.selectedZone else {
            updateOutputLabel(for: .noZone)
            return
        }
        
        switch viewModel.parkingState {
            
        case .notStarted:
            if viewModel.isParkingAvailable() {
                viewModel.parkingState = .started
                updateOutputLabel(for: .start)
            } else {
                updateOutputLabel(for: .start)
                parkingButton.isEnabled = false
            }
            
        case .started:
            viewModel.parkingState = .notStarted
            updateOutputLabel(for: .end)
            parkingButton.isEnabled = false
            
        case .ended:
            viewModel.parkingState = .ended
        }
    }
    

    private func fillColor(for polygon: MKPolygon) -> UIColor {
        guard let zone = viewModel.locationData?.zones.first(where: { $0.id == polygon.title }) else {
            return Consts.Colors.clearColor
        }

        switch (zone.id == viewModel.selectedZone?.id, zone.paymentIsAllowed) {
        case (true, _):
            return Consts.Colors.selectedZoneColor
        case (false, "1"):
            return Consts.Colors.availableZoneColor
        default:
            return Consts.Colors.unavailableZoneColor
        }
    }
    
    private func updateParkingButtonState() {
        switch viewModel.parkingState {
            
        case .notStarted:
            if viewModel.isParkingAvailable() {
                parkingButton.isEnabled = true
                parkingButton.setTitle(Consts.Strings.startParking, for: .normal)
            } else {
                parkingButton.isEnabled = false
                parkingButton.setTitle(Consts.Strings.parkingNotAvailable, for: .normal)
            }
            
        case .started:
            parkingButton.isEnabled = true
            parkingButton.setTitle(Consts.Strings.endParking, for: .normal)
            
        case .ended :
            parkingButton.setTitle(Consts.Strings.startParking, for: .normal)
        }
    }
    
    private func updateSelectedZone(at coordinate: CLLocationCoordinate2D) {
        if let selectedZone = viewModel.updateSelectedZone(mapCenter: coordinate) {
            viewModel.mapPin.title = selectedZone.name
            viewModel.mapPin.subtitle = "Price: \(selectedZone.currency)\(selectedZone.servicePrice)"
            
            let action: MapViewVM.ParkingAction = .start
            updateOutputLabel(for: action, coordinate: coordinate)
        } else {
            viewModel.mapPin.title = Consts.Strings.noZoneSelectedTitle
            viewModel.mapPin.subtitle = Consts.Strings.noZoneSelectedSubtitle
            
            updateOutputLabel(for: .noZone, coordinate: coordinate)
        }

        refreshMapAnnotation(viewModel.mapPin, in: mapView)
        drawZones()
        updateParkingButtonState()
    }

    
    private func refreshMapAnnotation(_ annotation: MKAnnotation, in mapView: MKMapView) {
        mapView.removeAnnotation(annotation)
        mapView.addAnnotation(annotation)
    }
    
    private func updateOutputLabel(for action: MapViewVM.ParkingAction, coordinate: CLLocationCoordinate2D? = nil) {
        guard let selectedZone = viewModel.selectedZone else {
            outputLabel.text = String(
                format: Consts.Strings.outsideZoneMessage,
                coordinate?.latitude ?? 0.0,
                coordinate?.longitude ?? 0.0
            )
            return
        }

        switch action {
        case .start:
            let status = selectedZone.paymentIsAllowed == "1" ? "Available" : "Not available"
            let coordinateText = coordinate != nil ? String(
                format: Consts.Strings.zoneInfoMessage,
                selectedZone.name,
                selectedZone.currency,
                selectedZone.servicePrice,
                coordinate!.latitude,
                coordinate!.longitude,
                status
            ) : String(
                format: Consts.Strings.parkingStartedMessage,
                selectedZone.name,
                selectedZone.currency,
                selectedZone.servicePrice
            )
            outputLabel.text = coordinateText

        case .end:
            outputLabel.text = String(
                format: Consts.Strings.parkingEndedMessage,
                selectedZone.name
            )

        case .noZone:
            outputLabel.text = String(
                format: Consts.Strings.outsideZoneMessage,
                coordinate?.latitude ?? 0.0,
                coordinate?.longitude ?? 0.0
            )
        }
    }
}
