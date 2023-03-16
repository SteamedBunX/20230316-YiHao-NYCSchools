//
//  ExpandableSchoolCell.swift
//  20230316-YiHao-NYCSchools
//
//  Created by yi.a.hao on 3/16/23.
//

import UIKit

class ExpandableSchoolCell: UITableViewCell {

    var delegate: ExpandableSchoolCellDelegate?
    static let identifier = "ExpandableSchoolCell"
    @IBOutlet weak var schoolNameLable: UILabel!
    @IBOutlet weak var summaryView: UIView!
    @IBOutlet weak var satAverage: UILabel!
    @IBOutlet weak var detailView: UIView!
    var expanded = false
    @IBOutlet weak var reading: UILabel!
    @IBOutlet weak var writing: UILabel!
    @IBOutlet weak var mathing: UILabel!
    var index = 0
    var indexPath: IndexPath?

    override func awakeFromNib() {
        super.awakeFromNib()

        // make the detail expands or retract open when tapped
        let tapGastureRecognizer = UITapGestureRecognizer(target: self, action: #selector(changeExpandState))
        summaryView.addGestureRecognizer(tapGastureRecognizer)
        summaryView.isUserInteractionEnabled = true
    }

    @objc func changeExpandState() {
        detailView.isHidden = !detailView.isHidden
        delegate?.didChangeExpandedState(for: detailView.isHidden ? nil : indexPath)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    public func config(school: School, index: IndexPath, expanded: Bool) {
        schoolNameLable.text = school.name
        satAverage.text = "\(school.sat.satTotal)"
        reading.text = "READING: \(school.sat.satReading)"
        writing.text = "WRITING: \(school.sat.satWriting)"
        mathing.text = "MATHING: \(school.sat.satMathing)"
        detailView.isHidden = !expanded
        self.index = index.row
        self.indexPath = index
    }
    
}

protocol ExpandableSchoolCellDelegate {
    func didTapDetailsButton(for index: Int)
    func didChangeExpandedState(for index: IndexPath?)
}
