import Foundation

// MARK: - Class

final class FeedViewModel {

    // MARK: - Private variables

    private let coordinator: AppCoordinator

    // MARK: - Internal variables

    var index = 0
    var videos: Looks?
    
    // MARK: - Initializer

    init(coordinator: AppCoordinator) {
        self.coordinator = coordinator
    }
}

// MARK: - Extension

extension FeedViewModel {

    // MARK: - Private methods

    func loadJson(from filename: String) -> Data? {
        guard
            let path =  Bundle(for: type(of: self)).path(forResource: filename, ofType: "json"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
        else { return nil }
        return data
    }

    func getModel<T>(model: T.Type, jsonName: String) -> T? where T: Decodable {
        let jsonDecoder = JSONDecoder()
        if let json = self.loadJson(from: jsonName),
           let data = try? jsonDecoder.decode(model, from: json) {
            return data
        } else {
            print("Decoding error \(String(describing: T.self))")
            return nil
        }
    }

    // MARK: - Internal methods

    func fetchVideoData() {
        videos = getModel(model: Looks.self, jsonName: "mock")        
    }

    func increaseLike() -> Int {
        var like = 0
        if var video = videos?.looks[index] {
            if video.likes == nil {
                video.likes = 1
                like = 1
            } else {
                if let likes = video.likes {
                    video.likes = likes + 1
                    like = likes + 1
                }
            }
            videos?.looks[index] = video
        }
        return like
    }

    func increaseClap() -> Int {
        var clap = 0
        if var video = videos?.looks[index] {
            if video.claps == nil {
                video.claps = 1
                clap = 1
            } else {
                if let claps = video.claps {
                    video.claps = claps + 1
                    clap = claps + 1
                }
            }
            videos?.looks[index] = video
        }

        return clap
    }
}
