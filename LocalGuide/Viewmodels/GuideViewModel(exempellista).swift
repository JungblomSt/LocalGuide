import Foundation
import Observation

@Observable
class GuideViewModel {
    var guides: [Guide] = [
        Guide(
            id: "1",
            title: "Botaniska Trädgården",
            description: "En av Europas största botaniska trädgårdar med fri entré. Perfekt för promenader i naturen mitt i staden.",
            longitude: 11.950377,
            latitude: 57.682853,
            image: "https://www.botaniska.se/image.jpg"
        ),
        Guide(
            id: "2",
            title: "Skansen Kronan",
            description: "Historisk 1600-talsfästning på Skansberget med en av stadens bästa utsikter. Öppet dygnet runt.",
            longitude: 11.955359,
            latitude: 57.696059
        ),
        Guide(
            id: "3",
            title: "Liseberg",
            description: "Skandinaviens mest besökta nöjespark med berg-och-dalbanor och underhållning för hela familjen.",
            longitude: 11.992464,
            latitude: 57.695219,
            image: "https://www.liseberg.se/image.jpg"
        ),
        Guide(
            id: "4",
            title: "Universeum",
            description: "Vetenskapsmuseum med tropisk regnskog, akvarium och interaktiva utställningar. Öppet 10–18 varje dag.",
            longitude: 11.988530,
            latitude: 57.695768
        ),
        Guide(
            id: "5",
            title: "Trädgårdsföreningen",
            description: "Vacker stadspark från 1842 med rosor, palmhus och café. Öppet 07–20 dagligen.",
            longitude: 11.976402,
            latitude: 57.706358
        )
    ]
}
