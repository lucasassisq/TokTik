import UIKit

/// I'm using final here, because is faster and my class won't be overriden
/// Doc ref: https://developer.apple.com/swift/blog/?id=27
///

final class FeedViewController: ViewController<FeedView> {

    // MARK: - Private variables

    private let viewModel: FeedViewModel

    // MARK: - Initializer

    init(viewModel: FeedViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        loadFeed()
        configSwipes()
        setActionsButtons()
    }
}

// MARK: - Extension

extension FeedViewController {

    // MARK: - Private Methods

    private func configSwipes() {

        ///
        /// Swipe for some movements
        /// Left will give a like
        /// Right will give a clap
        /// Up will show the next video
        /// Down will show the last video
        ///

        let swipeGestureRecognizerDown = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(_:)))
        swipeGestureRecognizerDown.direction = .right

        customView.addGestureRecognizer(createSwipeGestureRecognizer(for: .up))
        customView.addGestureRecognizer(createSwipeGestureRecognizer(for: .down))
        customView.addGestureRecognizer(createSwipeGestureRecognizer(for: .left))
        customView.addGestureRecognizer(createSwipeGestureRecognizer(for: .right))
    }

    private func setActionsButtons() {
        customView.viewLeft.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.increaseLike(_:))))
        customView.viewRight.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.increaseClap(_:))))
    }

    @objc func increaseLike(_ sender: UITapGestureRecognizer? = nil) {
        let like = viewModel.increaseLike()
        customView.likesCount.text = "\(like)"
    }

    @objc func increaseClap(_ sender: UITapGestureRecognizer? = nil) {
        let clap = viewModel.increaseClap()
        customView.clapsCount.text = "\(clap)"
    }

    private func loadFeed() {
        viewModel.fetchVideoData()
        guard let firstUrl = viewModel.videos?.looks.first?.compressedForIosURL else { return }
        customView.loadVideoFromUrl(url: firstUrl)
    }

    private func loadNextVideo() {
        if viewModel.videos?.looks.count ?? 0 > viewModel.index + 1 {
            if let video = viewModel.videos?.looks[viewModel.index + 1] {
                viewModel.index += 1
                customView.loadVideoFromUrl(url: video.compressedForIosURL)
                customView.clapsCount.text = "\(video.claps ?? 0)"
                customView.likesCount.text = "\(video.likes ?? 0 )"
            }
        }
    }

    private func loadPreviousVideo() {
        if viewModel.index > 0 {
            if let video = viewModel.videos?.looks[viewModel.index - 1] {
                viewModel.index -= 1
                customView.loadVideoFromUrl(url: video.compressedForIosURL)
                customView.clapsCount.text = "\(video.claps ?? 0)"
                customView.likesCount.text = "\(video.likes ?? 0)"
            }
        }
    }

    private func createSwipeGestureRecognizer(for direction: UISwipeGestureRecognizer.Direction) -> UISwipeGestureRecognizer {
        let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(_:)))
        swipeGestureRecognizer.direction = direction
        return swipeGestureRecognizer
    }

    @objc private func didSwipe(_ sender: UISwipeGestureRecognizer) {
        switch sender.direction {
        case .up:
            loadNextVideo()
        case .down:
            loadPreviousVideo()
        case .left:
            swippedLeft()
        case .right:
            swippedRight()

        default:
            break
        }
    }

    private func swippedLeft() {
        var frame = customView.playerLayer.frame
        frame.origin.x -= 100.0

        UIView.animate(withDuration: 0.25) {
            self.customView.playerLayer.frame = frame
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            UIView.animate(withDuration: 0.25) {
                var backFrame = frame
                backFrame.origin.x = 0
                self.customView.playerLayer.frame = backFrame
                self.increaseClap()
            }
        })
    }


    private func swippedRight() {
        var frame = customView.playerLayer.frame
        frame.origin.x += 100.0

        UIView.animate(withDuration: 0.25) {
            self.customView.playerLayer.frame = frame
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            UIView.animate(withDuration: 0.25) {
                var backFrame = frame
                backFrame.origin.x = 0
                self.customView.playerLayer.frame = backFrame
                self.increaseLike()
            }
        })
    }
}
