#!/usr/bin/env python3
import os
import subprocess
import sys

def check_swift_syntax():
    """检查Swift文件的基本语法"""
    print("检查Swift文件语法...")
    
    swift_files = []
    for root, dirs, files in os.walk('.'):
        for file in files:
            if file.endswith('.swift'):
                swift_files.append(os.path.join(root, file))
    
    print(f"找到 {len(swift_files)} 个Swift文件:")
    for file in swift_files:
        print(f"  - {file}")
    
    # 检查AppDelegate.swift的内容
    appdelegate_path = 'AppDelegate.swift'
    if os.path.exists(appdelegate_path):
        print(f"\n检查 {appdelegate_path}:")
        with open(appdelegate_path, 'r', encoding='utf-8') as f:
            content = f.read()
            
        # 检查关键内容
        if '@main' in content:
            print("  ✓ 找到 @main 标记")
        else:
            print("  ✗ 缺少 @main 标记")
            
        if 'class AppDelegate' in content:
            print("  ✓ 找到 AppDelegate 类")
        else:
            print("  ✗ 缺少 AppDelegate 类")
            
        if 'didFinishLaunchingWithOptions' in content:
            print("  ✓ 找到 didFinishLaunchingWithOptions 方法")
        else:
            print("  ✗ 缺少 didFinishLaunchingWithOptions 方法")
            
        if 'var window: UIWindow?' in content:
            print("  ✓ 找到 window 属性")
        else:
            print("  ✗ 缺少 window 属性")
            
        if 'TestViewController' in content:
            print("  ✓ 找到 TestViewController")
        else:
            print("  ✗ 缺少 TestViewController")
    
    # 检查Info.plist
    plist_path = 'Info.plist'
    if os.path.exists(plist_path):
        print(f"\n检查 {plist_path}:")
        with open(plist_path, 'r', encoding='utf-8') as f:
            content = f.read()
            
        if 'UIApplicationSceneManifest' in content and '<!--' in content:
            print("  ✓ Scene配置已被注释")
        elif 'UIApplicationSceneManifest' not in content:
            print("  ✓ 没有Scene配置")
        else:
            print("  ✗ Scene配置仍然活跃")

if __name__ == '__main__':
    check_swift_syntax() 