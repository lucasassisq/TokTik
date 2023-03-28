import UIKit

// MARK: - Class

final class AppCoordinator: Coordinator {

    // MARK: - Internal variables

    weak var parent: Coordinator?
    var children = [Coordinator]()
    var navigationController: UINavigationController

    // MARK: - Initializers

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}

extension AppCoordinator {

    // MARK: Internal methods

    func start() {
        let viewModel = FeedViewModel(coordinator: self)
        let viewController = FeedViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
        navigationController.isNavigationBarHidden = true
    }
}
