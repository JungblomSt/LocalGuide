

import Foundation
import MapKit

struct Guides: Codable {
    var guides: [Guide]
}

struct Guide: Identifiable, Hashable, Codable {
    var id: UUID
    var title: String
    var city: String
    var category: String
    var description: String
    var longitude: Double
    var latitude: Double
    var imageURL: String?
    var audioURL: String?
    var createdBy: String?
    
    var coordinates: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    init (id: String, title: String, city: String, category: String, description: String, longitude: Double, latitude: Double, image: String? = nil, audioURL: String? = nil, createdBy: String?) {
        self.id = UUID(uuidString: id) ?? UUID ()
        self.title = title
        self.city = city
        self.category = category
        self.description = description
        self.longitude = longitude
        self.latitude = latitude
        self.imageURL = image
        self.audioURL = audioURL
        self.createdBy = createdBy
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
    
    // -- Sätt in den här knappen i en view om du vill föra över datan till Firestore --
    
    //        Button("Ladda upp Sample Data till Firebase") {
    //            Task {
    //                await GuideManager.shared.uploadSampleData()
    //            }
    //        }
    
    static let sampleData: [Guide] = [
        Guide(
            id: "1",
            title: "Gamla Stan",
            city: "Stockholm",
            category: "history",
            description: "Gamla Stan är hjärtat av Stockholm och en av Europas bäst bevarade medeltidsstäder. Kullerstensgatorna, de färgglada fasaderna och de smala gränderna skapar en unik atmosfär som tar dig tillbaka i tiden till 1200-talet, då staden grundades på den lilla ön Stadsholmen. Här reser sig Kungliga slottet majestätiskt med sina 609 rum – ett av världens största palats som fortfarande används som officiell kunglig residens. Strax intill ligger Storkyrkan, Stockholms äldsta kyrka, där Karl X Gustav gifte sig och kungliga kröningar avhölls. Stortorget, stadens äldsta torg, är omgivet av färgsprakande handelshus från 1700-talet och är platsen för det berömda Stockholmsblodbadet 1520. Längs Österlånggatan och Västerlånggatan hittar man charmiga caféer, restauranger, antikvariat och konstgallerier. Nobelmuseet på Stortorget berättar om pristagarna och Alfred Nobels arv. En promenad längs Skeppsbron bjuder på storslagen utsikt över Saltsjön och Djurgårdsbrunnsviken. Gamla Stan är en levande stadsdel som lockar miljontals besökare varje år men ändå behåller sin genuina karaktär.",
            longitude: 18.0686,
            latitude: 59.3233,
            image: "https://emvwr2994ad.exactdn.com/wp-content/uploads/2019/10/old-town-stockholm-1-2.jpg?strip=all&quality=77",
            audioURL: "https://audio.example.com/guides/gamla-stan.mp3"
        ),
        Guide(
            id: "2",
            title: "Liseberg",
            city: "Göteborg",
            category: "kids",
            description: "Liseberg är Skandinaviens mest besökta nöjespark och ett oumbärligt besöksmål mitt i centrala Göteborg. Sedan öppningen 1923 i samband med Jubileumsutställningen har parken vuxit till att erbjuda över 40 åkattraktioner för alla åldrar och smaker. Flaggskeppsattraktionen Helix är en av Europas mest hyllade stålberg, med dubbla loopbanor och imponerande hastigheter som får adrenalinet att pumpa. För de yngsta besökarna finns Lisebergsbyn med karuseller, miniatyrbilar och sagoliknande miljöer. Parken är känd för sina magnifika blomsterplanteringar – över 50 000 växter pryder parkens gångar varje säsong, vilket gett Liseberg smeknamnet Blommornas park. Under sommarhalvåret bjuds besökarna på konserter och shower med stora inhemska och internationella artister. Julmarknaden på Liseberg är en av Nordens mest älskade jultraditioner, med glögg, pepparkakshjärtan och ett hav av ljus som lyser upp de mörka novemberkvällarna. Parkens centrala läge, precis vid Korsvägen, gör den lätt att nå med spårvagn eller gångväg från Göteborgs centralstation.",
            longitude: 11.9925,
            latitude: 57.6952,
            image: "https://upload.wikimedia.org/wikipedia/commons/thumb/2/2b/Liseberg%2C_20221223.jpg/250px-Liseberg%2C_20221223.jpg"
        ),
        Guide(
            id: "3",
            title: "Turning Torso",
            city: "Malmö",
            category: "art",
            description: "Turning Torso reser sig 190 meter över Malmös västra hamn och är Skandinaviens högsta skyskrapa samt en av de mest arkitektoniskt remarkabla byggnaderna i Norden. Byggnaden, ritad av den spanske stjärnarkitekten Santiago Calatrava och invigd 2005, består av nio kubiska segment som vrider sig 90 grader från botten till topp – en form inspirerad av en vridande mänsklig figur. Den spektakulära formen är inte enbart estetisk utan speglar Calatravas filosofi om att arkitektur och skulptur är oupplösligt förenade. Turning Torso är en bostadsbyggnad med 147 lägenheter fördelade på 54 våningar, och de övre våningarna erbjuder panoramautsikt över Öresund, Köpenhamn och på klara dagar ända till den svenska landsbygden i öster. Byggnaden har blivit en symbol för Malmös förvandling från industristad till modern kunskapsstad. Den omgivande stadsdelen Västra Hamnen är ett föredöme inom hållbar stadsplanering, med lågenergibyggnader, gröna tak och en levande strandpromenad. Turning Torso har vunnit flera internationella arkitekturpriser och figurerar regelbundet på listor över världens vackraste byggnader.",
            longitude: 12.9921,
            latitude: 55.6136,
            image: "https://upload.wikimedia.org/wikipedia/commons/thumb/a/af/Turning_Torso_3.jpg/250px-Turning_Torso_3.jpg",
            audioURL: "https://audio.example.com/guides/turning-torso.mp3"
        ),
        Guide(
            id: "4",
            title: "Visby ringmur",
            city: "Visby",
            category: "history",
            description: "Visby på Gotland är en av Nordeuropas bäst bevarade medeltidsstäder och ringmuren som omger staden är ett av Sveriges mest imponerande historiska monument. Muren uppfördes under 1200- och 1300-talen och sträcker sig drygt 3,6 kilometer runt stadskärnan med sina karaktäristiska torn och portar. Ursprungligen byggdes muren som ett försvarsverk för att skydda den tyska handelsstaden mot angrepp – Visby var under medeltiden en av Hansans viktigaste hamnar i Östersjön. Muren är välbevarad med 27 torn och tre bevarade stadsgrindar, och det är möjligt att promenera längs delar av murkrönet för en unik vy över staden och havet. Innanför muren ligger en tät kärna av välbevarade gotiska kyrkoruiner, kullerstensgatorna och handelshus i kalksten som vittnar om stadens storhetstid. UNESCO utsåg Visby till världsarv 1995 på grund av stadens exceptionellt välbevarade medeltida karaktär. Varje år i augusti förvandlas staden under Medeltidsveckan, då tusentals besökare klär sig i historiska dräkter och deltar i turneringar, marknader och festligheter.",
            longitude: 18.2948,
            latitude: 57.6389,
            image: "https://upload.wikimedia.org/wikipedia/commons/thumb/a/ad/Visby_ringmur_vid_%C3%96stergravar.jpg/250px-Visby_ringmur_vid_%C3%96stergravar.jpg",
            audioURL: "https://audio.example.com/guides/visby-ringmur.mp3"
        ),
        Guide(
            id: "5",
            title: "Icehotel",
            city: "Jukkasjärvi",
            category: "other",
            description: "I den lilla byn Jukkasjärvi, 20 kilometer öster om Kiruna, skapar konstnärer och hantverkare varje vinter något unikt och förgängligt – ett helt hotell byggt av is och snö från den bredvid liggande Torne älv. Icehotel öppnade 1990 och var världens allra första ishotell, och har sedan dess lockat hundratusentals besökare från hela världen. Hotellet byggs om varje höst med hjälp av hundratals ton kristallklart naturis och snö, och rivs naturligt ned av vårens töväder. Varje säsong inbjuds internationella konstnärer att utforma unika sviter – en konstinstallation man faktiskt sover i. Temperaturerna inne i hotellet håller sig stabilt runt minus fem grader, och gästerna sover i isolerande sovsäckar på renskinnsklädda sängar av is. Förutom det traditionella vinterhotellet finns sedan 2016 Icehotel 365, en permanent del som hålls fryst året om med hjälp av solpaneler. Besökare kan uppleva hundspannsäventyr, snöskoterexpeditioner och norrskensjakter. Hotellets bar, The Icebar, serverar drinkar i glas av is.",
            longitude: 20.6579,
            latitude: 67.8557,
            image: "https://upload.wikimedia.org/wikipedia/commons/thumb/5/56/Main_hall_ICEHOTEL_Sweden.jpg/250px-Main_hall_ICEHOTEL_Sweden.jpg"
        ),
        Guide(
            id: "6",
            title: "Kullaberg",
            city: "Kullabygden",
            category: "nature",
            description: "Kullabergshalvön i nordvästra Skåne är en av södra Sveriges mest dramatiska naturmiljöer och ett eldorado för naturälskare, klättrare och vandrare. Naturreservatet skyddar ett unikt landskap där klippor av gnejs och granit stupar brant ned mot Öresund och Skälderviken, formade av miljoner år av geologiska krafter och havsvindar. Halvöns höjdpunkt, Kullaberg, reser sig 188 meter över havet och erbjuder på klara dagar utsikt ända till danska Helsingör och Bornholm. Den karaktäristiska Kullens fyr, byggd 1561 och därmed en av Skandinaviens äldsta fyrar, tronar majestätiskt på klippspetsen. Längs kusten löper ett välmärkt vandringsnät med stigar genom ek- och bokskog, förbi grottor och längs brant klippstrand. Kullaberg är känt för sin rika biologiska mångfald – här häckar pilgrimsfalkar och havsörnar, och i havet utanför simmar tumlare. Smultronplatsen Mölle by med sin pittoreska hamn och färgglada fiskarstugor ligger vid halvöns västra spets och bjuder på god fisk och caféidyll efter vandringen.",
            longitude: 12.4500,
            latitude: 56.3000,
            image: "https://upload.wikimedia.org/wikipedia/commons/thumb/5/53/Kullaberg_01_november_2023_bild_5.jpg/500px-Kullaberg_01_november_2023_bild_5.jpg"
        ),
        Guide(
            id: "7",
            title: "Åre",
            city: "Åre",
            category: "sports",
            description: "Åre är Sveriges och Skandinaviens absolut ledande skidort och ett världskänt vintersportcentrum beläget i Jämtlands fjällvärld. Med 89 pister, 42 liftar och ett vertikalfall på 890 meter erbjuder Åre en variation som tillfredsställer allt från nybörjare till tävlingsskidåkare. Orten har arrangerat alpina världscuptävlingar sedan 1950-talet och var värd för alpina VM 1954 och 2019, vilket befäste dess position på den internationella skidkartan. Längst upp på berget, vid toppen av Åreskutan på 1 420 meters höjd, ligger Himlaskepp – en av Europas allra högst belägna restauranger med utsikt över ett hav av fjälltoppar. Under sommarhalvåret omvandlas Åre till ett mekka för mountainbikeåkare, vandringsentusiaster och fiskare. Byn Åre med sina charmiga träbyggnader, butiker, restauranger och krogar skapar en livlig après-ski-atmosfär. Åre erbjuder även skidskola, snowpark för freestyleåkare och nattkörning på belysta nedfarter. Tåget från Stockholm tar circa fyra timmar och stannar direkt i byn.",
            longitude: 13.0821,
            latitude: 63.3986,
            image: "https://upload.wikimedia.org/wikipedia/commons/thumb/9/9a/%C3%85resj%C3%B6n_Dcastor_2003.jpg/330px-%C3%85resj%C3%B6n_Dcastor_2003.jpg",
            audioURL: "https://audio.example.com/guides/are.mp3"
        ),
        Guide(
            id: "8",
            title: "Abisko nationalpark",
            city: "Abisko",
            category: "nature",
            description: "Abisko nationalpark, belägen i norra Lappland vid södra stranden av Torneträsk, är en av Sveriges vackraste och mest storslagna naturmiljöer. Parkens 77 kvadratkilometer skyddades redan 1909 och rymmer ett unikt klimatficka med Skandinaviens lägsta nederbördsmängd, vilket skapar ovanligt klara nätter och oslagbara förutsättningar för norrskensobservationer. Abisko Aurora Sky Station, tillgängligt med gondolbana, är en av världens bästa platser för att beskåda norrskenet. Från slutet av maj till mitten av juli strålar midnattssolen utan avbrott – ett magiskt fenomen som förvandlar nätterna till varma guldiga kvällar. Abisko canyon erbjuder vandring längs dramatiska raviner och forsande vatten. Den välkände Kungsleden, Sverige och Skandinaviens mest berömda vandringsled, startar i Abisko och sträcker sig 44 mil söderut till Hemavan. Djurlivet är rikt – ripor, fjällrävar och ibland lodjur och björn kan observeras. Samiska kulturmiljöer och renmigration hör till platsens historia och nutid.",
            longitude: 18.7726,
            latitude: 68.3496,
            image: "https://upload.wikimedia.org/wikipedia/commons/thumb/9/91/Abisko_-_KMB_-_16000300023822.jpg/500px-Abisko_-_KMB_-_16000300023822.jpg",
            audioURL: "https://audio.example.com/guides/abisko.mp3"
        ),
        Guide(
            id: "9",
            title: "Vadstena slott",
            city: "Vadstena",
            category: "history",
            description: "Vadstena slott vid Vätterns östra strand är ett av Sveriges mest välbevarade och historiskt betydelsefulla renässansslott. Byggnationen påbörjades på order av Gustav Vasa på 1540-talet och fullbordades av hans söner Johan III och Karl IX under de följande decennierna. Slottet byggdes ursprungligen som ett försvarsverk för att skydda det strategiskt viktiga Vättern, men omvandlades successivt till en kunglig residens med rika renässansinredningar. Den mäktiga fyrkantiga byggnaden med fyra runda hörntorn och de välbevarade vallgravarna är ett skolboksexempel på nordisk renässansarkitektur. Inuti slottet finns välbevarade salar, en slottskyrka och utställningar om Vasatidens historia och konst. Vadstena stad i sig är ett historiskt juveler – Birgittinordens moderkyrka Vadstena klosterkyrka från 1300-talet är en av de viktigaste pilgrimskyrkorna i Norden. Den medeltida stadskärnan med kullerstensgatorna och de gamla trähusen ger Vadstena en unik tidsresakänsla. Sommartid anordnas medeltidsmarknad, konserter och teaterföreställningar i slottets vackra miljö.",
            longitude: 14.8921,
            latitude: 58.4486,
            image: "https://upload.wikimedia.org/wikipedia/commons/thumb/b/bf/Vadstena.slottet.jpg/330px-Vadstena.slottet.jpg"
        ),
        Guide(
            id: "10",
            title: "Höga Kusten",
            city: "Kramfors",
            category: "nature",
            description: "Höga Kusten längs Ångermanälvens mynning och norrut utmed Bottenhavet är ett av Sveriges och Nordens mest dramatiska kustlandskap. Området utsågs till UNESCO-världsarv år 2000 på grund av det pågående landhöjningsfenomenet – efter inlandsisens avsmältning för 10 000 år sedan höjer sig marken här fortfarande med upp till 8 millimeter per år, den snabbaste landhöjningen i världen. Resultatet är ett landskap av branta klippor, djupa vikar, skogklädda öar och smala sund. Skuleskogens nationalpark mitt i området erbjuder vandringar med dramatiska klippväggar och utsiktsplatser som Slåttdalsberget, varifrån man ser havet och ön Ulvön breda ut sig. Från hamnen i Docksta går båtar ut till öarna, och Höga Kustenleden är en 130 kilometer lång vandringsled längs kustbranterna. Havsbadet är populärt under sommarmånaderna, och de lokala fiskebyarna erbjuder rökt strömming och annan lokal mat. Nätterna är mörka och stjärnhimlen enastående – perfekt för naturfotografer.",
            longitude: 18.1500,
            latitude: 62.8000,
            image: "https://upload.wikimedia.org/wikipedia/commons/thumb/1/1e/T%C3%A4rnetvattnet.JPG/250px-T%C3%A4rnetvattnet.JPG",
            audioURL: "https://audio.example.com/guides/hoga-kusten.mp3"
        )
    ]
}
