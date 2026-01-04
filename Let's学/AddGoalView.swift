import SwiftUI
import SwiftData

struct AddGoalView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var title = ""
    @State private var targetHours = 20.0
    
    var body: some View {
        NavigationStack {
            Form {
                Section("目标设置") {
                    TextField("目标名称 (如: 学习 Swift)", text: $title)
                    HStack {
                        Text("月度目标时长")
                        Spacer()
                        Text("\(Int(targetHours)) 小时").bold()
                    }
                    Slider(value: $targetHours, in: 1...200, step: 1)
                }
            }
            .navigationTitle("新增学习目标")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("添加") {
                        let newGoal = LearningGoal(title: title, targetHours: targetHours)
                        modelContext.insert(newGoal)
                        dismiss()
                    }
                    .disabled(title.isEmpty)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") { dismiss() }
                }
            }
        }
    }
}
