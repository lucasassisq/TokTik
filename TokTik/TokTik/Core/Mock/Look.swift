// MARK: - Looks

struct Looks: Codable {
    var looks: [Look]
}

// MARK: - Look

struct Look: Codable {

    enum CodingKeys: String, CodingKey {
        case id
        case songURL = "song_url"
        case body
        case profilePictureURL = "profile_picture_url"
        case username
        case compressedForIosURL = "compressed_for_ios_url"
        case likes
        case claps
    }

    let id: Int
    let songURL: String
    let body: String
    let profilePictureURL: String
    let username: String
    let compressedForIosURL: String
    var likes: Int? = 0
    var claps: Int? = 0
}
