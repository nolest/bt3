#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
項目文件驗證腳本
檢查所有必要的文件是否存在於正確的位置
"""

import os
import sys

def check_file_exists(file_path, description):
    """檢查文件是否存在"""
    if os.path.exists(file_path):
        print(f"✅ {description}: {file_path}")
        return True
    else:
        print(f"❌ {description}: {file_path} - 文件不存在")
        return False

def main():
    """主函數"""
    print("🔍 正在驗證BabyTracker3項目文件...")
    print("=" * 50)
    
    all_files_exist = True
    
    # 檢查根目錄文件
    files_to_check = [
        ("AppDelegate.swift", "應用程序代理"),
        ("SceneDelegate.swift", "場景代理"),
        ("Info.plist", "應用程序配置文件"),
    ]
    
    for file_name, description in files_to_check:
        if not check_file_exists(file_name, description):
            all_files_exist = False
    
    # 檢查Utils文件夾
    print("\n📁 Utils文件夾:")
    utils_files = [
        ("Utils/Constants.swift", "常量定義"),
        ("Utils/SampleDataGenerator.swift", "示例數據生成器"),
    ]
    
    for file_path, description in utils_files:
        if not check_file_exists(file_path, description):
            all_files_exist = False
    
    # 檢查Models文件夾
    print("\n📁 Models文件夾:")
    models_files = [
        ("Models/BabyRecord.swift", "寶寶記錄數據模型"),
    ]
    
    for file_path, description in models_files:
        if not check_file_exists(file_path, description):
            all_files_exist = False
    
    # 檢查Managers文件夾
    print("\n📁 Managers文件夾:")
    managers_files = [
        ("Managers/DataManager.swift", "數據管理器"),
    ]
    
    for file_path, description in managers_files:
        if not check_file_exists(file_path, description):
            all_files_exist = False
    
    # 檢查Views文件夾
    print("\n📁 Views文件夾:")
    views_files = [
        ("Views/SplashViewController.swift", "啟動屏幕"),
        ("Views/LoginViewController.swift", "登錄界面"),
        ("Views/SignupViewController.swift", "註冊界面"),
        ("Views/MainTabBarController.swift", "主標籤欄控制器"),
        ("Views/HomeViewController.swift", "首頁"),
        ("Views/RecordsViewController.swift", "記錄頁面"),
        ("Views/StatisticsViewController.swift", "統計頁面"),
        ("Views/PhotosViewController.swift", "照片與影片頁面"),
        ("Views/AssistantViewController.swift", "智能助理頁面"),
        ("Views/CommunityViewController.swift", "社群頁面"),
        ("Views/SettingsViewController.swift", "設置頁面"),
        ("Views/NotificationsViewController.swift", "通知設置"),
        ("Views/DataExportViewController.swift", "數據導出"),
        ("Views/BackupRestoreViewController.swift", "備份與恢復"),
    ]
    
    for file_path, description in views_files:
        if not check_file_exists(file_path, description):
            all_files_exist = False
    
    # 檢查資源文件
    print("\n📁 資源文件:")
    resource_files = [
        ("Assets.xcassets", "資源目錄"),
        ("Assets.xcassets/Contents.json", "資源目錄配置"),
        ("Assets.xcassets/AppIcon.appiconset", "應用圖標"),
        ("Assets.xcassets/AccentColor.colorset", "主題色"),
        ("Base.lproj/LaunchScreen.storyboard", "啟動屏幕故事板"),
    ]
    
    for file_path, description in resource_files:
        if not check_file_exists(file_path, description):
            all_files_exist = False
    
    # 檢查項目文件
    print("\n📁 Xcode項目文件:")
    project_files = [
        ("BabyTracker3.xcodeproj", "Xcode項目目錄"),
        ("BabyTracker3.xcodeproj/project.pbxproj", "Xcode項目文件"),
    ]
    
    for file_path, description in project_files:
        if not check_file_exists(file_path, description):
            all_files_exist = False
    
    print("\n" + "=" * 50)
    if all_files_exist:
        print("🎉 所有文件都存在！項目結構完整。")
        print("📱 您可以在macOS上使用Xcode打開BabyTracker3.xcodeproj來編譯和運行應用程序。")
    else:
        print("⚠️  有些文件缺失，請檢查上述錯誤信息。")
    
    return 0 if all_files_exist else 1

if __name__ == "__main__":
    sys.exit(main()) 