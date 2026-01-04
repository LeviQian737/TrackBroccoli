import SwiftUI
import SwiftData

struct GoalDetailView: View {
    @Bindable var goal: LearningGoal
    @State private var showLogSheet = false
    @State private var logContent = ""
    @State private var logDuration = 30

    var body: some View {
        List {
            Section("当月进度") {
                VStack(spacing: 15) {
                    let progress = goal.targetHours > 0 ? goal.totalHoursDone / goal.targetHours : 0
                    
                    ZStack {
                        Circle()
                            .stroke(Color.gray.opacity(0.2), lineWidth: 15)
                        Circle()
                            .trim(from: 0, to: CGFloat(min(progress, 1.0)))
                            .stroke(Color.blue, style: StrokeStyle(lineWidth: 15, lineCap: .round))
                            .rotationEffect(.degrees(-90))
                        
                        VStack {
                            Text("\(Int(progress * 100))%")
                                .font(.system(size: 40, weight: .bold))
                            Text("完成率")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .frame(height: 200)
                    .padding()
                    
                    Text("目标总时长: \(String(format: "%.0f", goal.targetHours)) 小时")
                        .font(.subheadline)
                }
            }
            
            Section("打卡历史") {
                if goal.logs.isEmpty {
                    Text("尚无记录").foregroundStyle(.secondary)
                } else {
                    ForEach(goal.logs.sorted(by: { $0.date > $1.date })) { log in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(log.content).font(.body)
                                Text(log.date.formatted(date: .abbreviated, time: .shortened))
                                    .font(.caption).foregroundStyle(.secondary)
                            }
                            Spacer()
                            Text("\(log.durationMinutes) 分钟").bold()
                        }
                    }
                }
            }
        }
        .navigationTitle(goal.title)
        .toolbar {
            Button("打卡") { showLogSheet = true }
        }
        .sheet(isPresented: $showLogSheet) {
            NavigationStack {
                Form {
                    TextField("今天学了什么？", text: $logContent)
                    Stepper("学习时长: \(logDuration) 分钟", value: $logDuration, in: 5...600, step: 5)
                }
                .navigationTitle("记录学习内容")
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("保存") {
                            let newLog = LearningLog(content: logContent, durationMinutes: logDuration, goal: goal)
                            goal.logs.append(newLog)
                            logContent = ""
                            showLogSheet = false
                        }
                        .disabled(logContent.isEmpty)
                    }
                    ToolbarItem(placement: .cancellationAction) {
                        Button("取消") { showLogSheet = false }
                    }
                }
            }
            .presentationDetents([.medium])
        }
    }
}
