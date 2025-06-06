import SwiftUI

struct RecordView: View {
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.dismiss) private var dismiss
    
    let recordType: RecordType
    
    @State private var timestamp = Date()
    @State private var duration: Double = 20
    @State private var amount: Double = 120
    @State private var feedingType: BabyRecord.FeedingType = .breast
    @State private var notes = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 25) {
                    // 頂部圖標和標題
                    recordHeader
                    
                    // 表單內容
                    VStack(spacing: 20) {
                        // 時間選擇
                        timeSection
                        
                        // 根據記錄類型顯示不同的表單
                        if recordType == .feeding {
                            feedingSpecificSections
                        } else if recordType == .sleeping {
                            durationSection
                        } else if recordType == .playing {
                            durationSection
                        }
                        
                        // 備注
                        notesSection
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("\(recordType.rawValue)記錄")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("取消") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("保存") {
                        saveRecord()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }
    
    private var recordHeader: some View {
        VStack(spacing: 15) {
            Text(recordType.icon)
                .font(.system(size: 64))
            
            Text("記錄\(recordType.rawValue)")
                .font(.title2)
                .fontWeight(.bold)
            
            Text(getRecordDescription())
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 20)
    }
    
    private var timeSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("開始時間")
                .font(.headline)
                .fontWeight(.semibold)
            
            HStack {
                Text("今天")
                    .foregroundColor(.secondary)
                
                Spacer()
                
                DatePicker("", selection: $timestamp, displayedComponents: .hourAndMinute)
                    .datePickerStyle(CompactDatePickerStyle())
                
                Image(systemName: "clock")
                    .foregroundColor(.blue)
            }
            .padding()
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding(.horizontal)
    }
    
    private var durationSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("持續時間")
                .font(.headline)
                .fontWeight(.semibold)
            
            VStack(spacing: 15) {
                Slider(value: $duration, in: 5...120, step: 5)
                    .accentColor(.blue)
                
                Text("\(Int(duration)) 分鐘")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)
            }
            .padding()
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding(.horizontal)
    }
    
    private var feedingSpecificSections: some View {
        Group {
            // 持續時間
            durationSection
            
            // 餵食方式
            VStack(alignment: .leading, spacing: 12) {
                Text("餵食方式")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                HStack(spacing: 12) {
                    ForEach(BabyRecord.FeedingType.allCases, id: \.self) { type in
                        Button(action: {
                            feedingType = type
                        }) {
                            VStack(spacing: 8) {
                                Text(getIconForFeedingType(type))
                                    .font(.title2)
                                
                                Text(type.rawValue)
                                    .font(.caption)
                                    .fontWeight(.medium)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 15)
                            .background(
                                feedingType == type ? 
                                Color.blue : Color(.secondarySystemGroupedBackground)
                            )
                            .foregroundColor(
                                feedingType == type ? .white : .primary
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            .padding(.horizontal)
            
            // 奶量
            VStack(alignment: .leading, spacing: 12) {
                Text("奶量 (ml)")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                HStack {
                    Text("估算奶量")
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text("\(Int(amount))ml")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                    
                    Image(systemName: "drop")
                        .foregroundColor(.blue)
                }
                .padding()
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
                Slider(value: $amount, in: 30...300, step: 10)
                    .accentColor(.blue)
                    .padding(.horizontal)
            }
            .padding(.horizontal)
        }
    }
    
    private var notesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("備注與心情")
                .font(.headline)
                .fontWeight(.semibold)
            
            TextField("記錄寶寶的反應和您的心情...\n例如：寶寶今天很乖，吃得很香 😊", text: $notes, axis: .vertical)
                .textFieldStyle(PlainTextFieldStyle())
                .padding()
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .frame(minHeight: 80)
        }
        .padding(.horizontal)
    }
    
    private func getRecordDescription() -> String {
        switch recordType {
        case .feeding:
            return "建立規律的餵奶習慣，讓寶寶更健康"
        case .sleeping:
            return "記錄睡眠時間，培養良好作息"
        case .diaper:
            return "記錄換尿布次數，關注寶寶健康"
        case .playing:
            return "記錄互動時間，促進寶寶發展"
        case .photo:
            return "記錄珍貴時刻，留下美好回憶"
        case .medical:
            return "記錄健康信息，關注寶寶成長"
        }
    }
    
    private func getIconForFeedingType(_ type: BabyRecord.FeedingType) -> String {
        switch type {
        case .breast:
            return "❤️"
        case .formula:
            return "🍼"
        case .mixed:
            return "➕"
        }
    }
    
    private func saveRecord() {
        let record = BabyRecord(
            type: recordType,
            timestamp: timestamp,
            duration: recordType == .feeding || recordType == .sleeping || recordType == .playing ? Int(duration) : nil,
            amount: recordType == .feeding ? amount : nil,
            feedingType: recordType == .feeding ? feedingType : nil,
            notes: notes,
            photoData: nil
        )
        
        dataManager.addRecord(record)
        dismiss()
    }
}

#Preview {
    RecordView(recordType: .feeding)
        .environmentObject(DataManager())
} 