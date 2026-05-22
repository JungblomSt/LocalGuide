

import Foundation
import MapKit

struct Guide: Identifiable, Hashable {
    var id: UUID
    var title: String
    var city: String
    var category: String
    var description: String
    var longitude: Double
    var latitude: Double
    var imageURL: String?
    var audioURL: String?
    
    var coordinates: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    init (id: String, title: String, city: String, category: String, description: String, longitude: Double, latitude: Double, image: String? = nil, audioURL: String? = nil) {
        self.id = UUID(uuidString: id) ?? UUID ()
        self.title = title
        self.city = city
        self.category = category
        self.description = description
        self.longitude = longitude
        self.latitude = latitude
        self.imageURL = image
        self.audioURL = nil
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

extension Guide{
    func distance(from location: CLLocation) -> CLLocationDistance {
        CLLocation(latitude: latitude, longitude: longitude).distance(from: location)
    }
    
    
    // MARK: Tillfällig exempeldata
    static let sampleData: [Guide] = [
        Guide(
            id: "1",
            title: "Gamla Stan",
            city: "Stockholm",
            category: "history",
            description: "Gamla Stan är hjärtat av Stockholm och en av Europas bäst bevarade medeltidsstäder. \n Gamla Stan är hjärtat av Stockholm och en av Europas bäst bevarade medeltidsstäder. Kullerstensgatorna, de färgglada fasaderna och de smala gränderna skapar en unik atmosfär. Här finns Kungliga slottet, Storkyrkan och Stortorget – platser som vittnar om mer än sju hundra år av svensk historia. Längs Österlånggatan hittar man caféer, restauranger och konstgallerier. En promenad längs Skeppsbron ger en storslagen vy över vattnet som omger ön på alla sidor.",
            longitude: 18.0686,
            latitude: 59.3233,
            image: "https://upload.wikimedia.org/wikipedia/commons/thumb/1/1f/Gamla_stan_bank.jpg/1280px-Gamla_stan_bank.jpg"
        ),
        Guide(
            id: "2",
            title: "Liseberg",
            city: "Göteborg",
            category: "kids",
            description: "Skandinaviens mest besökta nöjespark mitt i Göteborg.",
            longitude: 11.9925,
            latitude: 57.6952
        ),
        Guide(
            id: "3",
            title: "Turning Torso",
            city: "Malmö",
            category: "art",
            description: "Skandinaviens högsta skyskrapa och ett ikoniskt landmärke i Malmö.",
            longitude: 12.9921,
            latitude: 55.6136
        ),
        Guide(
            id: "4",
            title: "Visby ringmur",
            city: "Visby",
            category: "history",
            description: "Välbevarad medeltida stadsmur från 1200-talet, ett UNESCO-världsarv.",
            longitude: 18.2948,
            latitude: 57.6389
        ),
        Guide(
            id: "5",
            title: "Icehotel",
            city: "Jukkasjärvi",
            category: "other",
            description: "Världens första ishotell, byggt varje vinter av is och snö från Torne älv.",
            longitude: 20.6579,
            latitude: 67.8557
        ),
        Guide(
            id: "6",
            title: "Kullaberg",
            city: "Kullabygden",
            category: "nature",
            description: "Dramatisk klippkust med naturreservat, fyrar och fantastisk utsikt över Öresund.",
            longitude: 12.4500,
            latitude: 56.3000
        ),
        Guide(
            id: "7",
            title: "Åre",
            city: "Åre",
            category: "sports",
            description: "Sveriges populäraste skidort med alpina pister och Sveriges högsta restaurang.",
            longitude: 13.0821,
            latitude: 63.3986
        ),
        Guide(
            id: "8",
            title: "Abisko nationalpark",
            city: "Abisko",
            category: "nature",
            description: "En av Sveriges vackraste nationalparker med norrskensvisningar och midnattssol.",
            longitude: 18.7726,
            latitude: 68.3496
        ),
        Guide(
            id: "9",
            title: "Vadstena slott",
            city: "Vadstena",
            category: "history",
            description: "Praktfullt renässansslott vid Vätterns strand, byggt på 1500-talet av Gustav Vasa.",
            longitude: 14.8921,
            latitude: 58.4486
        ),
        Guide(
            id: "10",
            title: "Höga Kusten",
            city: "Kramfors",
            category: "nature",
            description: "UNESCO-världsarv med dramatiska klippor, djupa fjordar och unik natur.",
            longitude: 18.1500,
            latitude: 62.8000
        )
    ]
}
