//
//  Coordinator.swift
//  20230316-YiHao-NYCSchools
//
//  Created by yi.a.hao on 3/16/23.
//

import UIKit

class Coordinator {
    var navigationController: UINavigationController
    var detailViewController: SchoolDetailsViewController?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vc = SchoolTableViewController()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }

    func presentDetailView(for school: School) {
        print("we inside the coordinator")
        if detailViewController == nil {
            detailViewController = SchoolDetailsViewController()
            detailViewController?.coordinator = self
        }
        guard let detailViewController = detailViewController else { return }
        detailViewController.config(for: school)
        navigationController.pushViewController(detailViewController, animated: true)
    }
}
