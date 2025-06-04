#!/usr/bin/env python3
import os

def diagnose_ios_project():
    print("=== iOS项目黑屏问题诊断 ===")
    
    # 检查AppDelegate.swift
    print("\n1. 检查AppDelegate.swift:")
    if os.path.exists('AppDelegate.swift'):
        with open('AppDelegate.swift', 'r', encoding='utf-8') as f:
            content = f.read()
        
        if '@main' in content:
            print("  ✅ 找到@main标记")
        else:
            print("  ❌ 缺少@main标记")
        
        if 'var window: UIWindow?' in content:
            print("  ✅ 找到window属性")
        else:
            print("  ❌ 缺少window属性")
        
        if 'makeKeyAndVisible' in content:
            print("  ✅ 找到makeKeyAndVisible调用")
        else:
            print("  ❌ 缺少makeKeyAndVisible调用")
    else:
        print("  ❌ AppDelegate.swift文件不存在")
    
    # 检查Info.plist
    print("\n2. 检查Info.plist:")
    if os.path.exists('Info.plist'):
        with open('Info.plist', 'r', encoding='utf-8') as f:
            content = f.read()
        
        if 'UIApplicationSceneManifest' in content:
            print("  ⚠️  仍然包含Scene配置")
        else:
            print("  ✅ 没有Scene配置")
    else:
        print("  ❌ Info.plist文件不存在")
    
    print("\n=== 建议的解决方案 ===")
    print("1. 重启iOS模拟器")
    print("2. 清理Xcode构建缓存")
    print("3. 尝试不同的模拟器")
    print("4. 检查Xcode控制台输出")

if __name__ == '__main__':
    diagnose_ios_project() 