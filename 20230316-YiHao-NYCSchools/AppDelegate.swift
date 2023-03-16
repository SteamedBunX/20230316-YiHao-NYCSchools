//
//  AppDelegate.swift
//  20230316-YiHao-NYCSchools
//
//  Created by yi.a.hao on 3/16/23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // loading the school data in async
        let queue = DispatchQueue.global(qos: .userInitiated)
        queue.async {
            let satScores = self.loadSATScores()
            let filePath = Bundle.main.path(forResource: "2017_DOE_High_School_Directory", ofType: "csv")!
            let csvString = try? String(contentsOfFile: filePath, encoding: .utf8)
            let data = csvString?.components(separatedBy: .newlines) ?? []

            for school in data.dropFirst() {
                // was using components, then relize there are , in some datas
                // has to be done manually
                var schoolData = [String]()
                var currentField = ""
                // Just gonna assume "" means string literal
                var inQuotes = false

                for char in school {
                    // only , outside of "" are considered as seperator
                    if char == "," && !inQuotes {
                        schoolData.append(currentField
                            .trimmingCharacters(in: .whitespaces).trimmingCharacters(in: CharacterSet(charactersIn: "\"")))
                        currentField = ""
                    } else if char == "\"" {
                        inQuotes.toggle()
                    } else {
                        currentField.append(char)
                    }
                }
                // invalid data, that last data index i need is 450
                if schoolData.count < 451 { continue }

                var academicOpportunities = [String]()
                for i in 5...9 {
                    if schoolData[i] != "" {
                        academicOpportunities.append(schoolData[i])
                    }
                }
                let schoolDetail = School(
                    dbn: schoolData[0],
                    name: schoolData[1],
                    sat: satScores[schoolData[0]] ?? SAT(satTaker: 0, satReading: 0, satWriting: 0, satMathing: 0, satTotal: 0),
                    overview: schoolData[3],
                    academicOpportunities: academicOpportunities,
                    ellPrograms: schoolData[10],
                    languageClasses: schoolData[11],
                    apCources: schoolData[12],
                    city: schoolData[450],
                    neighborhood: schoolData[14],
                    isSharedSpace: schoolData[15] == "Yes",
                    location: schoolData[18],
                    phone: schoolData[19],
                    fax: schoolData[20],
                    email: schoolData[21],
                    website: schoolData[22],
                    grades: schoolData[26],
                    totalStudents: schoolData[27],
                    time: "\(schoolData[28]) - \(schoolData[29])",
                    extracurricular: schoolData[31],
                    graduationRate: schoolData[36])
                Schools.shared.addSchool(schoolDetail)

            }
            Schools.shared.loading = false
        }
        return true
    }

    func loadSATScores() -> [String: SAT] {
        var satScores = [String: SAT]()
        let filePath = Bundle.main.path(forResource: "2012_SAT_Results", ofType: "csv")!
        let csvString = try? String(contentsOfFile: filePath, encoding: .utf8)
        let data = csvString?.components(separatedBy: .newlines) ?? []

        for satScore in data.dropFirst() {
            let satScoreData = satScore.components(separatedBy: ";")
            // invalid data
            if satScoreData.count < 6 { continue }
            let reading = Int(satScoreData[3]) ?? 0
            let writing = Int(satScoreData[5]) ?? 0
            let mathing = Int(satScoreData[4]) ?? 0
            satScores[satScoreData[0]] = SAT(satTaker: Int(satScoreData[2]) ?? 0, satReading: reading, satWriting: writing, satMathing: mathing, satTotal: reading + writing + mathing)
        }
        return satScores
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

