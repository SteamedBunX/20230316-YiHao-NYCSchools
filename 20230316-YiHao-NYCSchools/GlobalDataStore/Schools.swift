//
//  Schools.swift
//  20230316-YiHao-NYCSchools
//
//  Created by yi.a.hao on 3/16/23.
//

import Foundation

class Schools {
    static let shared = Schools()
    private(set) var schoolsArray: [School] = []
    // need awareness if loading is still happening
    private(set) var onAddSchool: [(() -> Void)?] = []
    public var loading = true
    private init() {}

    func addSchool(_ school: School) {
        schoolsArray.append(school)
        // notify any subscriber
        onAddSchool.forEach{ $0?()}
    }

    func registerOnSchoolAdded(_ callback: (() -> Void)?) {
        onAddSchool.append(callback)
    }
}
