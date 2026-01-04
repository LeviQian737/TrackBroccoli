//
//  Models.swift
//  Let's学
//
//  Created by Qian dede on 1/4/26.
//

import Foundation
import SwiftData

@Model
final class LearningGoal {
    var title: String
    var targetHours: Double
    var createdAt: Date
    // 级联删除：删除目标时，关联的打卡记录也会删除
    @Relationship(deleteRule: .cascade, inverse: \LearningLog.goal)
    var logs: [LearningLog] = []
    
    init(title: String, targetHours: Double) {
        self.title = title
        self.targetHours = targetHours
        self.createdAt = Date()
    }
    
    // 计算属性：已完成总小时数
    var totalHoursDone: Double {
        let totalMinutes = logs.reduce(0) { $0 + $1.durationMinutes }
        return Double(totalMinutes) / 60.0
    }
}

@Model
final class LearningLog {
    var content: String
    var durationMinutes: Int
    var date: Date
    var goal: LearningGoal?
    
    init(content: String, durationMinutes: Int, goal: LearningGoal) {
        self.content = content
        self.durationMinutes = durationMinutes
        self.date = Date()
        self.goal = goal
    }
}
