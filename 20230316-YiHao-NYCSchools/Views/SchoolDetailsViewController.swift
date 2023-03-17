//
//  SchoolDetailsViewController.swift
//  20230316-YiHao-NYCSchools
//
//  Created by yi.a.hao on 3/16/23.
//

import UIKit

class SchoolDetailsViewController: UIViewController {

    @IBOutlet weak var schoolName: UILabel!
    @IBOutlet weak var tableView: UITableView!
    weak var coordinator: Coordinator?
    var school: School?

    // im just gonna put all the sections here
    let sections = [
        "City",
        "Overview",
        "Total Students",
        "Graduation Rate",
        "SAT",
        "Academic Opportunities",
        "ELL Programs",
        "Language Classes",
        "AP Courses",
        "Location",
        "Phone",
        "Fax",
        "Email",
        "Website"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DetailInfoCell.self, forCellReuseIdentifier: DetailInfoCell.identifier)
        self.schoolName?.text = school?.name ?? ""
    }

    public func config(for school: School) {
        self.school = school
        self.schoolName?.text = school.name
        tableView?.reloadData()
    }
}

extension SchoolDetailsViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 4:
                return 5 // SAT saction got 5
            case 5:
                return max(school?.academicOpportunities.count ?? 0, 1) // Gonna display N/A if there is nothing in it
            default:
                return 1
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Was gonna add clickable to website phone number and email but oh well, only so much you can do in one day.
        let cell = tableView.dequeueReusableCell(withIdentifier: DetailInfoCell.identifier) as! DetailInfoCell
        switch indexPath.section {
            case 0:
                cell.config(text: school?.city ?? "")
            case 1:
                cell.config(text: school?.overview ?? "")
            case 2:
                cell.config(text: school?.totalStudents ?? "")
            case 3:
                cell.config(text: parseGraduationRate(school?.graduationRate))
            case 4:
                switch indexPath.row {
                    case 0:
                        cell.config(text: "Total Taker: \(school?.sat.satTaker ?? 0)")
                    case 1:
                        cell.config(text: "Reading: \(school?.sat.satReading ?? 0)")
                    case 2:
                        cell.config(text: "Writing: \(school?.sat.satWriting ?? 0)")
                    case 3:
                        cell.config(text: "Mathing: \(school?.sat.satMathing ?? 0)")
                    default:
                        cell.config(text: "Combined: \(school?.sat.satTotal ?? 0)")
                }
            case 5:
                if school?.academicOpportunities.count == 0 {
                    cell.config(text: "N/A")
                } else if indexPath.row >= school?.academicOpportunities.count ?? 0{
                    cell.config(text: "")
                } else {
                    cell.config(text: school?.academicOpportunities[indexPath.row] ?? "")
                }
            case 6:
                cell.config(text: school?.ellPrograms ?? "")
            case 7:
                cell.config(text: school?.languageClasses ?? "")
            case 8:
                cell.config(text: school?.apCources ?? "")
            case 9:
                cell.config(text: school?.location ?? "")
            case 10:
                cell.config(text: school?.phone ?? "")
            case 11:
                cell.config(text: school?.fax ?? "")
            case 12:
                cell.config(text: school?.email ?? "")
            case 13:
                cell.config(text: school?.website ?? "")
            default:
                cell.config(text: "")
        }
        return cell
    }

    // was gonna write it inline but was kinda messy :/
    func parseGraduationRate(_ _rate: String?) -> String{
        guard let rate = _rate else { return "N/A" }
        guard let rateDouble = Double(rate) else { return "N/A" }
        return String(format: "%.2f%%", rateDouble)
    }

}
