//
//  LearningGoal.swift
//  PasinaOn
//
//  Created by Rizki Fitriani on 11/06/26.
//

import Foundation
import SwiftData

@Model
final class LearningGoal {

    var title: String
    var goalDescription: String
    var targetDate: Date

    init(
        title: String,
        goalDescription: String,
        targetDate: Date
    ) {
        self.title = title
        self.goalDescription = goalDescription
        self.targetDate = targetDate
    }
}
