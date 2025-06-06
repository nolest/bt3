import SwiftUI

struct ContentView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var selectedTab = 0
    @State private var showingSplash = true
    
    var body: some View {
        Group {
            if showingSplash {
                SplashView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation(.easeInOut(duration: 1)) {
                                showingSplash = false
                            }
                        }
                    }
            } else {
                TabView(selection: $selectedTab) {
                    HomeView()
                        .tabItem {
                            Image(systemName: "house.fill")
                            Text("首頁")
                        }
                        .tag(0)
                    
                    StatisticsView()
                        .tabItem {
                            Image(systemName: "chart.line.uptrend.xyaxis")
                            Text("統計")
                        }
                        .tag(1)
                    
                    MilestonesView()
                        .tabItem {
                            Image(systemName: "trophy.fill")
                            Text("里程碑")
                        }
                        .tag(2)
                    
                    FamilyView()
                        .tabItem {
                            Image(systemName: "person.3.fill")
                            Text("家庭")
                        }
                        .tag(3)
                    
                    SettingsView()
                        .tabItem {
                            Image(systemName: "gearshape.fill")
                            Text("設置")
                        }
                        .tag(4)
                }
                .accentColor(Color("PrimaryColor"))
            }
        }
        .sheet(isPresented: $dataManager.showingRecordSheet) {
            RecordView(recordType: dataManager.selectedRecordType)
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(DataManager())
} 