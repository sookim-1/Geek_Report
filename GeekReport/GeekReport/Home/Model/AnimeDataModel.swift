//
//  AnimeDataModel.swift
//  GeekReport
//
//  Created by sookim on 4/8/24.
//

import Foundation

// MARK: - AnimeData
struct AnimeData: Codable, Hashable {
    
    let id = UUID()
    let animeID: Int
    let title: String
    let imageURLs: ImageURLs

    enum CodingKeys: String, CodingKey {
        case animeID = "mal_id"
        case imageURLs = "images"
        case title
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: AnimeData, rhs: AnimeData) -> Bool {
        return lhs.id == rhs.id
    }
    
}

// MARK: - ImageURLs
struct ImageURLs: Codable {
    let jpgURLs: JpgURLs

    enum CodingKeys: String, CodingKey {
        case jpgURLs = "jpg"
    }
}

// MARK: - JpgURLs
struct JpgURLs: Codable {
    let basicImageURL: String
    let smallImageURL: String
    let largeImageURL: String

    enum CodingKeys: String, CodingKey {
        case basicImageURL = "image_url"
        case smallImageURL = "small_image_url"
        case largeImageURL = "large_image_url"
    }
}


// MARK: - SampleData
extension AnimeData {
    static var defaultData: [Self] {
        return [
            AnimeData(animeID: 52991, title: "Sousou no Frieren", imageURLs: ImageURLs(jpgURLs: JpgURLs(basicImageURL: "https://cdn.myanimelist.net/images/anime/1015/138006.jpg", smallImageURL: "https://cdn.myanimelist.net/images/anime/1015/138006t.jpg", largeImageURL: "https://cdn.myanimelist.net/images/anime/1015/138006l.jpg"))),

            AnimeData(animeID: 5114, title: "Fullmetal Alchemist: Brotherhood", imageURLs: ImageURLs(jpgURLs: JpgURLs(basicImageURL: "https://cdn.myanimelist.net/images/anime/1208/94745.jpg", smallImageURL: "https://cdn.myanimelist.net/images/anime/1208/94745t.jpg", largeImageURL: "https://cdn.myanimelist.net/images/anime/1208/94745l.jpg"))),

            AnimeData(animeID: 9253, title: "Steins;Gate", imageURLs: ImageURLs(jpgURLs: JpgURLs(basicImageURL: "https://cdn.myanimelist.net/images/anime/1935/127974.jpg", smallImageURL: "https://cdn.myanimelist.net/images/anime/1935/127974t.jpg", largeImageURL: "https://cdn.myanimelist.net/images/anime/1935/127974l.jpg"))),

            AnimeData(animeID: 28977, title: "Gintama°", imageURLs: ImageURLs(jpgURLs: JpgURLs(basicImageURL: "https://cdn.myanimelist.net/images/anime/3/72078.jpg", smallImageURL: "https://cdn.myanimelist.net/images/anime/3/72078t.jpg", largeImageURL: "https://cdn.myanimelist.net/images/anime/3/72078l.jpg"))),

            AnimeData(animeID: 38524, title: "Shingeki no Kyojin Season 3 Part 2", imageURLs: ImageURLs(jpgURLs: JpgURLs(basicImageURL: "https://cdn.myanimelist.net/images/anime/1517/100633.jpg", smallImageURL: "https://cdn.myanimelist.net/images/anime/1517/100633t.jpg", largeImageURL: "https://cdn.myanimelist.net/images/anime/1517/100633l.jpg"))),

            AnimeData(animeID: 39486, title: "Gintama: The Final", imageURLs: ImageURLs(jpgURLs: JpgURLs(basicImageURL: "https://cdn.myanimelist.net/images/anime/1245/116760.jpg", smallImageURL: "https://cdn.myanimelist.net/images/anime/1245/116760t.jpg", largeImageURL: "https://cdn.myanimelist.net/images/anime/1245/116760l.jpg"))),

            AnimeData(animeID: 11061, title: "Hunter x Hunter (2011)", imageURLs: ImageURLs(jpgURLs: JpgURLs(basicImageURL: "https://cdn.myanimelist.net/images/anime/1337/99013.jpg", smallImageURL: "https://cdn.myanimelist.net/images/anime/1337/99013t.jpg", largeImageURL: "https://cdn.myanimelist.net/images/anime/1337/99013l.jpg"))),

            AnimeData(animeID: 9969, title: "Gintama'", imageURLs: ImageURLs(jpgURLs: JpgURLs(basicImageURL: "https://cdn.myanimelist.net/images/anime/4/50361.jpg", smallImageURL: "https://cdn.myanimelist.net/images/anime/4/50361t.jpg", largeImageURL: "https://cdn.myanimelist.net/images/anime/4/50361l.jpg"))),

            AnimeData(animeID: 15417, title: "Gintama': Enchousen", imageURLs: ImageURLs(jpgURLs: JpgURLs(basicImageURL: "https://cdn.myanimelist.net/images/anime/1452/123686.jpg", smallImageURL: "https://cdn.myanimelist.net/images/anime/1452/123686t.jpg", largeImageURL: "https://cdn.myanimelist.net/images/anime/1452/123686l.jpg"))),

            AnimeData(animeID: 820, title: "Ginga Eiyuu Densetsu", imageURLs: ImageURLs(jpgURLs: JpgURLs(basicImageURL: "https://cdn.myanimelist.net/images/anime/1976/142016.jpg", smallImageURL: "https://cdn.myanimelist.net/images/anime/1976/142016t.jpg", largeImageURL: "https://cdn.myanimelist.net/images/anime/1976/142016l.jpg"))),

            AnimeData(animeID: 41467, title: "Bleach: Sennen Kessen-hen", imageURLs: ImageURLs(jpgURLs: JpgURLs(basicImageURL: "https://cdn.myanimelist.net/images/anime/1908/135431.jpg", smallImageURL: "https://cdn.myanimelist.net/images/anime/1908/135431t.jpg", largeImageURL: "https://cdn.myanimelist.net/images/anime/1908/135431l.jpg"))),

            AnimeData(animeID: 43608, title: "Kaguya-sama wa Kokurasetai: Ultra Romantic", imageURLs: ImageURLs(jpgURLs: JpgURLs(basicImageURL: "https://cdn.myanimelist.net/images/anime/1160/122627.jpg", smallImageURL: "https://cdn.myanimelist.net/images/anime/1160/122627t.jpg", largeImageURL: "https://cdn.myanimelist.net/images/anime/1160/122627l.jpg"))),

            AnimeData(animeID: 34096, title: "Gintama.", imageURLs: ImageURLs(jpgURLs: JpgURLs(basicImageURL: "https://cdn.myanimelist.net/images/anime/3/83528.jpg", smallImageURL: "https://cdn.myanimelist.net/images/anime/3/83528t.jpg", largeImageURL: "https://cdn.myanimelist.net/images/anime/3/83528l.jpg"))),

            AnimeData(animeID: 42938, title: "Fruits Basket: The Final", imageURLs: ImageURLs(jpgURLs: JpgURLs(basicImageURL: "https://cdn.myanimelist.net/images/anime/1085/114792.jpg", smallImageURL: "https://cdn.myanimelist.net/images/anime/1085/114792t.jpg", largeImageURL: "https://cdn.myanimelist.net/images/anime/1085/114792l.jpg"))),

            AnimeData(animeID: 918, title: "Gintama", imageURLs: ImageURLs(jpgURLs: JpgURLs(basicImageURL: "https://cdn.myanimelist.net/images/anime/10/73274.jpg", smallImageURL: "https://cdn.myanimelist.net/images/anime/10/73274t.jpg", largeImageURL: "https://cdn.myanimelist.net/images/anime/10/73274l.jpg"))),

            AnimeData(animeID: 54492, title: "Kusuriya no Hitorigoto", imageURLs: ImageURLs(jpgURLs: JpgURLs(basicImageURL: "https://cdn.myanimelist.net/images/anime/1708/138033.jpg", smallImageURL: "https://cdn.myanimelist.net/images/anime/1708/138033t.jpg", largeImageURL: "https://cdn.myanimelist.net/images/anime/1708/138033l.jpg"))),

            AnimeData(animeID: 4181, title: "Clannad: After Story", imageURLs: ImageURLs(jpgURLs: JpgURLs(basicImageURL: "https://cdn.myanimelist.net/images/anime/1299/110774.jpg", smallImageURL: "https://cdn.myanimelist.net/images/anime/1299/110774t.jpg", largeImageURL: "https://cdn.myanimelist.net/images/anime/1299/110774l.jpg"))),

            AnimeData(animeID: 28851, title: "Koe no Katachi", imageURLs: ImageURLs(jpgURLs: JpgURLs(basicImageURL: "https://cdn.myanimelist.net/images/anime/1122/96435.jpg", smallImageURL: "https://cdn.myanimelist.net/images/anime/1122/96435t.jpg", largeImageURL: "https://cdn.myanimelist.net/images/anime/1122/96435l.jpg"))),

            AnimeData(animeID: 35180, title: "3-gatsu no Lion 2nd Season", imageURLs: ImageURLs(jpgURLs: JpgURLs(basicImageURL: "https://cdn.myanimelist.net/images/anime/3/88469.jpg", smallImageURL: "https://cdn.myanimelist.net/images/anime/3/88469t.jpg", largeImageURL: "https://cdn.myanimelist.net/images/anime/3/88469l.jpg"))),

            AnimeData(animeID: 2904, title: "Code Geass: Hangyaku no Lelouch R2", imageURLs: ImageURLs(jpgURLs: JpgURLs(basicImageURL: "https://cdn.myanimelist.net/images/anime/1088/135089.jpg", smallImageURL: "https://cdn.myanimelist.net/images/anime/1088/135089t.jpg", largeImageURL: "https://cdn.myanimelist.net/images/anime/1088/135089l.jpg"))),

        ]
    }
}
