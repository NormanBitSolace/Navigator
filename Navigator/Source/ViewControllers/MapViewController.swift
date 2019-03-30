import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!

    func setAnnotation(location: CLLocationCoordinate2D, title: String, subtitle: String) {
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = title
        annotation.subtitle = subtitle
        mapView.addAnnotation(annotation)
    }

    func setAstroAnnotation() {
        let location = CLLocationCoordinate2D(latitude: 34.002680,longitude: -118.484260)
        setAnnotation(location: location, title: "Astro Doughnut & Fried Chicken", subtitle: "Now open")    }
}
