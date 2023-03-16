//
//  Coordinator.swift
//  20230316-YiHao-NYCSchools
//
//  Created by yi.a.hao on 3/16/23.
//

import UIKit

class Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vc = SchoolTableViewController()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
}
