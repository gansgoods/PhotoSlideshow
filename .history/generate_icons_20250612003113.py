#!/usr/bin/env python3
import os
from PIL import Image, ImageDraw, ImageFont
import math

def create_photo_slideshow_icon(size):
    """创建PhotoSlideshow app图标"""
    # 创建图像
    img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    
    # 计算尺寸比例
    scale = size / 1024.0
    
    # 背景渐变 (使用紫色调)
    bg_color = (102, 126, 234)  # 蓝紫色
    corner_radius = int(220 * scale)
    
    # 绘制圆角背景
    draw.rounded_rectangle([0, 0, size, size], corner_radius, fill=bg_color)
    
    # 照片参数
    photo_width = int(500 * scale)
    photo_height = int(380 * scale)
    frame_width = int(25 * scale)
    
    # 绘制三张叠放的照片
    photos = [
        {'x': int(200 * scale), 'y': int(180 * scale), 'angle': -8, 'color': (255, 234, 167)},  # 黄色
        {'x': int(250 * scale), 'y': int(220 * scale), 'angle': -3, 'color': (168, 230, 207)},  # 绿色
        {'x': int(300 * scale), 'y': int(260 * scale), 'angle': 5, 'color': (255, 217, 61)}     # 亮黄色
    ]
    
    for photo in photos:
        # 创建照片图像
        photo_img = Image.new('RGBA', (photo_width + frame_width*2, photo_height + frame_width*2), (0, 0, 0, 0))
        photo_draw = ImageDraw.Draw(photo_img)
        
        # 绘制白色相框
        photo_draw.rounded_rectangle([0, 0, photo_width + frame_width*2, photo_height + frame_width*2], 
                                   int(25 * scale), fill=(255, 255, 255))
        
        # 绘制彩色照片
        photo_draw.rounded_rectangle([frame_width, frame_width, photo_width + frame_width, photo_height + frame_width], 
                                   int(15 * scale), fill=photo['color'])
        
        # 旋转照片
        if photo['angle'] != 0:
            photo_img = photo_img.rotate(photo['angle'], expand=True, fillcolor=(0, 0, 0, 0))
        
        # 计算粘贴位置
        paste_x = photo['x'] - photo_img.width // 2 + photo_width // 2
        paste_y = photo['y'] - photo_img.height // 2 + photo_height // 2
        
        # 粘贴到主图像
        img.alpha_composite(photo_img, (paste_x, paste_y))
    
    # 绘制播放按钮
    center_x, center_y = size // 2, int(450 * scale)
    play_radius = int(80 * scale)
    
    # 白色圆形背景
    draw.ellipse([center_x - play_radius, center_y - play_radius, 
                 center_x + play_radius, center_y + play_radius], 
                fill=(255, 255, 255, 230))
    
    # 蓝色三角形播放按钮
    triangle_size = int(40 * scale)
    triangle_points = [
        (center_x - triangle_size//2, center_y - triangle_size//2),
        (center_x - triangle_size//2, center_y + triangle_size//2),
        (center_x + triangle_size//2, center_y)
    ]
    draw.polygon(triangle_points, fill=bg_color)
    
    # 添加光效
    light_x, light_y = int(300 * scale), int(250 * scale)
    light_radius1 = int(20 * scale)
    light_radius2 = int(8 * scale)
    
    draw.ellipse([light_x - light_radius1, light_y - light_radius1,
                 light_x + light_radius1, light_y + light_radius1],
                fill=(255, 255, 255, 100))
    
    draw.ellipse([light_x + int(10 * scale) - light_radius2, light_y - int(10 * scale) - light_radius2,
                 light_x + int(10 * scale) + light_radius2, light_y - int(10 * scale) + light_radius2],
                fill=(255, 255, 255, 150))
    
    return img

def main():
    """生成所有需要的图标尺寸"""
    # 检查PIL是否可用
    try:
        from PIL import Image, ImageDraw
    except ImportError:
        print("错误：需要安装Pillow库")
        print("请运行：pip3 install Pillow")
        return
    
    # 定义需要的图标尺寸
    icon_sizes = {
        'icon-20x20@2x.png': 40,
        'icon-20x20@3x.png': 60,
        'icon-29x29@2x.png': 58,
        'icon-29x29@3x.png': 87,
        'icon-40x40@2x.png': 80,
        'icon-40x40@3x.png': 120,
        'icon-60x60@2x.png': 120,
        'icon-60x60@3x.png': 180,
        'icon-1024x1024.png': 1024
    }
    
    # 输出目录
    output_dir = 'Sources/PhotoSlideshow.xcassets/AppIcon.appiconset'
    
    # 确保输出目录存在
    os.makedirs(output_dir, exist_ok=True)
    
    # 生成每个尺寸的图标
    for filename, size in icon_sizes.items():
        print(f"生成 {filename} (尺寸: {size}x{size})...")
        
        # 创建图标
        icon = create_photo_slideshow_icon(size)
        
        # 保存文件
        output_path = os.path.join(output_dir, filename)
        icon.save(output_path, 'PNG')
        
        print(f"已保存: {output_path}")
    
    print("\n所有图标生成完成！")

if __name__ == '__main__':
    main() 