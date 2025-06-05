#!/usr/bin/env python3
"""
BabyTracker3 启动调试脚本
用于诊断黑屏问题
"""

import os
import sys
import json
import re

def check_project_structure():
    """检查项目结构"""
    print("🔍 检查项目结构...")
    
    required_files = [
        "AppDelegate.swift",
        "SceneDelegate.swift", 
        "Info.plist",
        "Base.lproj/LaunchScreen.storyboard"
    ]
    
    missing_files = []
    for file in required_files:
        if not os.path.exists(file):
            missing_files.append(file)
    
    if missing_files:
        print(f"❌ 缺少文件: {missing_files}")
        return False
    else:
        print("✅ 项目文件结构完整")
        return True

def check_info_plist():
    """检查Info.plist配置"""
    print("\n🔍 检查Info.plist配置...")
    
    try:
        with open("Info.plist", "r") as f:
            content = f.read()
            
        # 检查Scene配置是否被正确注释掉
        if "UIApplicationSceneManifest" in content and "<!--" in content:
            print("✅ Scene系统已被正确禁用")
        elif "UIApplicationSceneManifest" not in content:
            print("✅ 没有Scene配置（正常）")
        else:
            print("⚠️ Scene系统可能仍然启用")
            
        # 检查Launch Screen
        if "UILaunchStoryboardName" in content:
            print("✅ LaunchScreen配置存在")
        else:
            print("❌ 缺少LaunchScreen配置")
            
    except Exception as e:
        print(f"❌ 读取Info.plist失败: {e}")

def check_app_delegate():
    """检查AppDelegate配置"""
    print("\n🔍 检查AppDelegate.swift...")
    
    try:
        with open("AppDelegate.swift", "r") as f:
            content = f.read()
            
        checks = [
            ("@main", "主类标记"),
            ("var window: UIWindow?", "Window属性"),
            ("didFinishLaunchingWithOptions", "启动方法"),
            ("setupLegacyWindow", "Window设置方法"),
            ("makeKeyAndVisible", "Window显示调用")
        ]
        
        for check, desc in checks:
            if check in content:
                print(f"✅ {desc}: 存在")
            else:
                print(f"❌ {desc}: 缺失")
                
    except Exception as e:
        print(f"❌ 读取AppDelegate.swift失败: {e}")

def generate_fix_suggestions():
    """生成修复建议"""
    print("\n💡 修复建议:")
    print("1. 完全清理Xcode缓存：")
    print("   - 关闭Xcode")
    print("   - 删除 ~/Library/Developer/Xcode/DerivedData")
    print("   - 重启Xcode")
    
    print("\n2. 模拟器重置：")
    print("   - Device -> Erase All Content and Settings")
    print("   - 重启模拟器")
    
    print("\n3. 项目清理：")
    print("   - Product -> Clean Build Folder (Shift+Cmd+K)")
    print("   - 删除项目的build文件夹")
    
    print("\n4. 检查Build Settings：")
    print("   - iOS Deployment Target 应该设置为合适的版本")
    print("   - Bundle Identifier 应该唯一")
    
    print("\n5. 尝试创建新的空白项目：")
    print("   - 如果空白项目也黑屏，可能是Xcode或模拟器问题")
    
    print("\n6. 控制台调试：")
    print("   - 查看Xcode控制台输出")
    print("   - 查看设备日志")

def main():
    """主函数"""
    print("BabyTracker3 启动调试工具")
    print("=" * 50)
    
    # 检查是否在正确的目录
    if not os.path.exists("AppDelegate.swift"):
        print("❌ 请在app目录中运行此脚本")
        return
    
    # 执行检查
    check_project_structure()
    check_info_plist()
    check_app_delegate()
    generate_fix_suggestions()
    
    print("\n" + "=" * 50)
    print("调试完成!")

if __name__ == "__main__":
    main() 