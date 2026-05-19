

import Foundation
import MapKit

struct Guide: Identifiable {
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
extension Guide{
    func distance(from location: CLLocation) -> CLLocationDistance {
        CLLocation(latitude: latitude, longitude: longitude).distance(from: location)
    }
    
    static let sampleData: [Guide] = [
        Guide(
            id: "1",
            title: "Gamla Stan, Stockholm",
            description: "Stockholms medeltida gamla stad med kullerstensgator och färgglada byggnader.",
            longitude: 18.0686,
            latitude: 59.3233
        ),
        Guide(
            id: "2",
            title: "Liseberg, Göteborg",
            description: "Skandinaviens mest besökta nöjespark mitt i Göteborg.",
            longitude: 11.9925,
            latitude: 57.6952
        ),
        Guide(
            id: "3",
            title: "Turning Torso, Malmö",
            description: "Skandinaviens högsta skyskrapa och ett ikoniskt landmärke i Malmö.",
            longitude: 12.9921,
            latitude: 55.6136
        ),
        Guide(
            id: "4",
            title: "Visby ringmur, Gotland",
            description: "Välbevarad medeltida stadsmur från 1200-talet, ett UNESCO-världsarv.",
            longitude: 18.2948,
            latitude: 57.6389
        ),
        Guide(
            id: "5",
            title: "Icehotel, Jukkasjärvi",
            description: "Världens första ishotell, byggt varje vinter av is och snö från Torne älv.",
            longitude: 20.6579,
            latitude: 67.8557
        ),
        Guide(
            id: "6",
            title: "Kullaberg, Skåne",
            description: "Dramatisk klippkust med naturreservat, fyrar och fantastisk utsikt över Öresund.",
            longitude: 12.4500,
            latitude: 56.3000
        ),
        Guide(
            id: "7",
            title: "Åre, Jämtland",
            description: "Sveriges populäraste skidort med alpina pister och Sveriges högsta restaurang.",
            longitude: 13.0821,
            latitude: 63.3986
        ),
        Guide(
            id: "8",
            title: "Abisko nationalpark, Lappland",
            description: "En av Sveriges vackraste nationalparker med norrskensvisningar och midnattssol.",
            longitude: 18.7726,
            latitude: 68.3496
        ),
        Guide(
            id: "9",
            title: "Vadstena slott",
            description: "Praktfullt renässansslott vid Vätterns strand, byggt på 1500-talet av Gustav Vasa.",
            longitude: 14.8921,
            latitude: 58.4486
        ),
        Guide(
            id: "10",
            title: "Höga Kusten, Västernorrland",
            description: "UNESCO-världsarv med dramatiska klippor, djupa fjordar och unik natur.",
            longitude: 18.1500,
            latitude: 62.8000
        )
    ]
        
    
        
}
