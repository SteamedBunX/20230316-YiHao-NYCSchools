//
//  SchoolTableViewController.swift
//  20230316-YiHao-NYCSchools
//
//  Created by yi.a.hao on 3/16/23.
//

import UIKit

class SchoolTableViewController: UIViewController {


    @IBOutlet weak var tableView: UITableView!
    var coordinator: Coordinator?
    var currentlyExpanded: IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName:ExpandableSchoolCell.identifier, bundle: nil), forCellReuseIdentifier: ExpandableSchoolCell.identifier)
        tableView.estimatedRowHeight = 70
        tableView.rowHeight = UITableView.automaticDimension
        Schools.shared.registerOnSchoolAdded(dataChanged)
    }

    func dataChanged() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension SchoolTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Schools.shared.schoolsArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ExpandableSchoolCell.identifier) as! ExpandableSchoolCell
        cell.config(school: Schools.shared.schoolsArray[indexPath.row], index: indexPath, expanded: indexPath == currentlyExpanded)
        cell.delegate = self
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.currentlyExpanded == indexPath {
            return 200
        }
        return 70
    }
}

extension SchoolTableViewController: ExpandableSchoolCellDelegate {
    func didTapDetailsButton(for index: Int) {

    }

    func didChangeExpandedState(for index: IndexPath?) {
        if !Schools.shared.loading {
            currentlyExpanded = index
            tableView.reloadRows(at: [index ?? IndexPath(row: 0, section: 0)], with: .automatic)
        }
    }
}
