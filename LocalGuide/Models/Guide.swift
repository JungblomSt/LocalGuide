

import Foundation
import MapKit

class Guide: Identifiable {
    var id: UUID
    var title: String
    var category: String
    var description: String
    var longitude: Double
    var latitude: Double
    var imageURL: String?
    
    var coordinates: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    init (id: String, title: String, category: String, description: String, longitude: Double, latitude: Double, image: String? = nil) {
        self.id = UUID(uuidString: id) ?? UUID ()
        self.title = title
        self.category = category
        self.description = description
        self.longitude = longitude
        self.latitude = latitude
        self.imageURL = image
    }
}

enum Category: String, CaseIterable, Identifiable {

    case other
    case history
    case nature
    case art
    case sports
    case food
    case kids
    
    var id: Self { self }
    
    var displayName: String {
        switch self {
        case .other: return "Övrigt"
        case .history: return "Historia"
        case .nature: return "Natur"
        case .art: return "Konst"
        case .sports: return "Idrott"
        case .food: return "Mat och dryck"
        case .kids: return "Barnvänligt"
        }
    }
}
