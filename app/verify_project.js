#!/usr/bin/env node
/**
 * 項目文件驗證腳本 (Node.js版本)
 * 檢查所有必要的文件是否存在於正確的位置
 */

const fs = require('fs');
const path = require('path');

function checkFileExists(filePath, description) {
    try {
        if (fs.existsSync(filePath)) {
            console.log(`✅ ${description}: ${filePath}`);
            return true;
        } else {
            console.log(`❌ ${description}: ${filePath} - 文件不存在`);
            return false;
        }
    } catch (error) {
        console.log(`❌ ${description}: ${filePath} - 檢查時出錯: ${error.message}`);
        return false;
    }
}

function main() {
    console.log("🔍 正在驗證BabyTracker3項目文件...");
    console.log("=".repeat(50));
    
    let allFilesExist = true;
    
    // 檢查根目錄文件
    const rootFiles = [
        ["AppDelegate.swift", "應用程序代理"],
        ["SceneDelegate.swift", "場景代理"],
        ["Info.plist", "應用程序配置文件"]
    ];
    
    for (const [fileName, description] of rootFiles) {
        if (!checkFileExists(fileName, description)) {
            allFilesExist = false;
        }
    }
    
    // 檢查Utils文件夾
    console.log("\n📁 Utils文件夾:");
    const utilsFiles = [
        ["Utils/Constants.swift", "常量定義"],
        ["Utils/SampleDataGenerator.swift", "示例數據生成器"]
    ];
    
    for (const [filePath, description] of utilsFiles) {
        if (!checkFileExists(filePath, description)) {
            allFilesExist = false;
        }
    }
    
    // 檢查Models文件夾
    console.log("\n📁 Models文件夾:");
    const modelsFiles = [
        ["Models/BabyRecord.swift", "寶寶記錄數據模型"]
    ];
    
    for (const [filePath, description] of modelsFiles) {
        if (!checkFileExists(filePath, description)) {
            allFilesExist = false;
        }
    }
    
    // 檢查Managers文件夾
    console.log("\n📁 Managers文件夾:");
    const managersFiles = [
        ["Managers/DataManager.swift", "數據管理器"]
    ];
    
    for (const [filePath, description] of managersFiles) {
        if (!checkFileExists(filePath, description)) {
            allFilesExist = false;
        }
    }
    
    // 檢查Views文件夾
    console.log("\n📁 Views文件夾:");
    const viewsFiles = [
        ["Views/SplashViewController.swift", "啟動屏幕"],
        ["Views/LoginViewController.swift", "登錄界面"],
        ["Views/SignupViewController.swift", "註冊界面"],
        ["Views/MainTabBarController.swift", "主標籤欄控制器"],
        ["Views/HomeViewController.swift", "首頁"],
        ["Views/RecordsViewController.swift", "記錄頁面"],
        ["Views/StatisticsViewController.swift", "統計頁面"],
        ["Views/PhotosViewController.swift", "照片與影片頁面"],
        ["Views/AssistantViewController.swift", "智能助理頁面"],
        ["Views/CommunityViewController.swift", "社群頁面"],
        ["Views/SettingsViewController.swift", "設置頁面"],
        ["Views/NotificationsViewController.swift", "通知設置"],
        ["Views/DataExportViewController.swift", "數據導出"],
        ["Views/BackupRestoreViewController.swift", "備份與恢復"]
    ];
    
    for (const [filePath, description] of viewsFiles) {
        if (!checkFileExists(filePath, description)) {
            allFilesExist = false;
        }
    }
    
    // 檢查資源文件
    console.log("\n📁 資源文件:");
    const resourceFiles = [
        ["Assets.xcassets", "資源目錄"],
        ["Assets.xcassets/Contents.json", "資源目錄配置"],
        ["Assets.xcassets/AppIcon.appiconset", "應用圖標"],
        ["Assets.xcassets/AccentColor.colorset", "主題色"],
        ["Base.lproj/LaunchScreen.storyboard", "啟動屏幕故事板"]
    ];
    
    for (const [filePath, description] of resourceFiles) {
        if (!checkFileExists(filePath, description)) {
            allFilesExist = false;
        }
    }
    
    // 檢查項目文件
    console.log("\n📁 Xcode項目文件:");
    const projectFiles = [
        ["BabyTracker3.xcodeproj", "Xcode項目目錄"],
        ["BabyTracker3.xcodeproj/project.pbxproj", "Xcode項目文件"]
    ];
    
    for (const [filePath, description] of projectFiles) {
        if (!checkFileExists(filePath, description)) {
            allFilesExist = false;
        }
    }
    
    // 額外檢查：統計文件數量
    console.log("\n📊 文件統計:");
    try {
        const viewsDir = 'Views';
        if (fs.existsSync(viewsDir)) {
            const viewFiles = fs.readdirSync(viewsDir).filter(file => file.endsWith('.swift'));
            console.log(`📱 Views文件夾中有 ${viewFiles.length} 個Swift文件`);
        }
        
        const modelsDir = 'Models';
        if (fs.existsSync(modelsDir)) {
            const modelFiles = fs.readdirSync(modelsDir).filter(file => file.endsWith('.swift'));
            console.log(`🗂️ Models文件夾中有 ${modelFiles.length} 個Swift文件`);
        }
        
        const managersDir = 'Managers';
        if (fs.existsSync(managersDir)) {
            const managerFiles = fs.readdirSync(managersDir).filter(file => file.endsWith('.swift'));
            console.log(`⚙️ Managers文件夾中有 ${managerFiles.length} 個Swift文件`);
        }
    } catch (error) {
        console.log(`⚠️ 統計文件時出錯: ${error.message}`);
    }
    
    console.log("\n" + "=".repeat(50));
    if (allFilesExist) {
        console.log("🎉 所有文件都存在！項目結構完整。");
        console.log("📱 您可以在macOS上使用Xcode打開BabyTracker3.xcodeproj來編譯和運行應用程序。");
        console.log("\n💡 關於 'Indexing Paused' 問題的建議:");
        console.log("   1. 在Xcode中按 Cmd+Shift+K 清理構建");
        console.log("   2. 刪除 ~/Library/Developer/Xcode/DerivedData");
        console.log("   3. 重啟Xcode");
        console.log("   4. 檢查磁盤空間是否充足");
    } else {
        console.log("⚠️  有些文件缺失，請檢查上述錯誤信息。");
    }
    
    return allFilesExist ? 0 : 1;
}

// 運行主函數
if (require.main === module) {
    process.exit(main());
} 