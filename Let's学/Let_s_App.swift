import SwiftUI
import SwiftData

@main
struct StudyTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        // 关键：注册我们定义的两个模型
        .modelContainer(for: [LearningGoal.self, LearningLog.self])
    }
}
