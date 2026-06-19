//
//  LearningEntry.swift
//  PasinaOn
//
//  Created by Rizki Fitriani on 11/06/26.
//

import Foundation
import SwiftData

@Model
final class LearningEntry {

    var title: String
    var topic: String
    var reflection: String
    var date: Date
    var isCompleted: Bool

    init(
        title: String,
        topic: String,
        reflection: String,
        date: Date = .now,
        isCompleted: Bool = false
    ) {
        self.title = title
        self.topic = topic
        self.reflection = reflection
        self.date = date
        self.isCompleted = isCompleted
    }
}
