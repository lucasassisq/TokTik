import UIKit
import AVFoundation

// MARK: - Class

final class FeedView: UIView {

    // MARK: - Layout views

    let playerLayer = AVPlayerLayer()

    lazy var viewLeft: UIView = {
        $0.heightAnchor.constraint(equalToConstant: 70.0).isActive = true
        $0.widthAnchor.constraint(equalToConstant: 70.0).isActive = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.addSubview(heartEmoji)
        $0.addSubview(likesCount)
        return $0
    }(UIView())

    let heartEmoji: UILabel = {
        $0.text = "❤️"
        $0.font = UIFont(name: "CourierNewPS-BoldMT", size: 32.0)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())

    let likesCount: UILabel = {
        $0.text = "0"
        $0.textColor = .white
        $0.font = UIFont(name: "CourierNewPS-BoldMT", size: 18.0)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())

    lazy var viewRight: UIView = {
        $0.heightAnchor.constraint(equalToConstant: 70.0).isActive = true
        $0.widthAnchor.constraint(equalToConstant: 70.0).isActive = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.addSubview(clapsEmoji)
        $0.addSubview(clapsCount)
        return $0
    }(UIView())

    private let clapsEmoji: UILabel = {
        $0.font = UIFont(name: "CourierNewPS-BoldMT", size: 32.0)
        $0.text = "👏🏻"
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())

    let clapsCount: UILabel = {
        $0.text = "0"
        $0.textColor = .white
        $0.font = UIFont(name: "CourierNewPS-BoldMT", size: 18.0)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())

    // MARK: - Initializer

    init() {
        super.init(frame: .zero)
        addSubviews()
        setViewLeftConstraints()
        setViewRightConstraints()
        setClapsEmojiConstrints()
        setLikesConstraints()
        setClapesConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Override methods

    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }
}

// MARK: - Extension

extension FeedView {

    // MARK: - Private methods

    private func addSubviews() {
        layer.addSublayer(playerLayer)
        addSubview(viewLeft)
        addSubview(viewRight)

    }

    private func setViewLeftConstraints() {
        NSLayoutConstraint.activate([
            viewLeft.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0),
            viewLeft.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    private func setLikesConstraints() {
        NSLayoutConstraint.activate([
            likesCount.centerXAnchor.constraint(equalTo: heartEmoji.centerXAnchor),
            likesCount.topAnchor.constraint(equalTo: heartEmoji.bottomAnchor, constant: 2.0)
        ])
    }

    private func setClapesConstraints() {
        NSLayoutConstraint.activate([
            clapsCount.centerXAnchor.constraint(equalTo: clapsEmoji.centerXAnchor),
            clapsCount.topAnchor.constraint(equalTo: clapsEmoji.bottomAnchor, constant: 2.0)
        ])
    }

    private func setViewRightConstraints() {
        NSLayoutConstraint.activate([
            viewRight.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.0),
            viewRight.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    private func setClapsEmojiConstrints() {
        NSLayoutConstraint.activate([
            clapsEmoji.trailingAnchor.constraint(equalTo: viewRight.trailingAnchor),
            clapsEmoji.topAnchor.constraint(equalTo: viewRight.topAnchor)
        ])
    }

    // MARK: - Internal methods

    func loadVideoFromUrl(url: String) {
        guard let url = URL(string: url) else { return }
        let player = AVPlayer(url: url)
        player.isMuted = false
        player.actionAtItemEnd = .none
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerItemDidReachEnd(notification:)),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: player.currentItem)
        player.play()
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.player = player
    }

    @objc func playerItemDidReachEnd(notification: Notification) {
        playerLayer.player?.seek(to: CMTime.zero)
    }
}
