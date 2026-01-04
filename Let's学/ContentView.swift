import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \LearningGoal.createdAt, order: .reverse) private var goals: [LearningGoal]
    
    @State private var showingAddGoal = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(goals) { goal in
                    NavigationLink(destination: GoalDetailView(goal: goal)) {
                        VStack(alignment: .leading, spacing: 5) {
                            Text(goal.title)
                                .font(.headline)
                            
                            // 进度条预览
                            ProgressView(value: min(goal.totalHoursDone, goal.targetHours), total: goal.targetHours)
                                .tint(.accentColor)
                            
                            Text("已完成 \(String(format: "%.1f", goal.totalHoursDone)) / \(String(format: "%.0f", goal.targetHours)) 小时")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                }
                .onDelete(perform: deleteGoals)
            }
            .navigationTitle("学习目标")
            .toolbar {
                ToolbarItem(placement: .primaryAction) { // 解决 macOS 兼容性报错
                    Button(action: { showingAddGoal = true }) {
                        Label("添加目标", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddGoal) {
                AddGoalView()
            }
            .overlay {
                if goals.isEmpty {
                    ContentUnavailableView("暂无目标", systemImage: "book.closed", description: Text("点击右上角 + 开始设定你的月度目标"))
                }
            }
        }
    }

    private func deleteGoals(offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(goals[index])
        }
    }
}
