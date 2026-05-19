

import Foundation
import MapKit

class Guide: Identifiable {
    var id: UUID
    var title: String
    var description: String
    var longitude: Double
    var latitude: Double
    var imageURL: String?
    
    var coordinates: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    init (id: String, title: String, description: String, longitude: Double, latitude: Double, image: String? = nil) {
        self.id = UUID(uuidString: id) ?? UUID ()
        self.title = title
        self.description = description
        self.longitude = longitude
        self.latitude = latitude
        self.imageURL = image
    }
}
