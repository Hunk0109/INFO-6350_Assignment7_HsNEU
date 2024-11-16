import Foundation

struct Artist {
    let id: Int
    var name: String
    var age: String
    var email: String
}

struct Album {
    let id: Int
    let artistId: Int
    var title: String
    var releaseDate: String
    var endDate: String
    var premium_amoumt: String
    var policyType: String
}

struct Song {
    var id: Int
    var artist_id: Int
    var album_id: Int
    var genre_id: Int
    var title: String
    var duration: Double
    var favorite: Bool
    var dateOfClaim: String
}

struct Genre {
    let id: Int
    var name: String
    var paymentAmount: String
    var paymentDate: String
    var paymentMethod: String
    var paymentStatus: String
}

class SharedData {
    static let shared = SharedData()
    var artists: [Artist] = []
    var albums: [Album] = []
    var songs: [Song] = []
    var genres: [Genre] = []
    var artistAlbumsDict: [Int: [Album]] = [:]
}

