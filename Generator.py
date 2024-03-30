import cv2
import numpy as np


def extract_and_simplify_contours(image_path, threshold=100, epsilon_factor=0.005): # epsilon越大，简化程度越高
    # 读取图片
    image = cv2.imread(image_path)
    gray_image = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
    _, binary_image = cv2.threshold(gray_image, threshold, 255, cv2.THRESH_BINARY_INV)

    # 寻找轮廓
    contours, _ = cv2.findContours(binary_image, cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)

    simplified_contours = []

    # 轮廓简化
    for contour in contours:
        epsilon = epsilon_factor * cv2.arcLength(contour, True)
        simplified = cv2.approxPolyDP(contour, epsilon, True)
        simplified_contours.append(simplified)

    return simplified_contours, image.shape[0]


def generate_matlab_code(contours, image_height):
    matlab_code = ""
    for contour in contours:
        for i in range(len(contour) - 1):
            x1, y1 = contour[i][0]
            x2, y2 = contour[i + 1][0]
            # 调整y坐标
            y1 = image_height - y1
            y2 = image_height - y2
            matlab_code += f"draw_line({x1}, {y1}, {x2}, {y2}, 2, speed);\n"
        # 连接最后一个点和第一个点，并调整y坐标
        if len(contour) > 1:
            x1, y1 = contour[-1][0]
            x2, y2 = contour[0][0]
            y1 = image_height - y1
            y2 = image_height - y2
            matlab_code += f"draw_line({x1}, {y1}, {x2}, {y2}, 2, speed);\n"
    return matlab_code


def write_matlab_code_to_file(matlab_code, file_path):
    with open(file_path, 'w') as file:
        file.write(matlab_code)

# 使用示例
image_path = 'image.jpg'
contours, image_height = extract_and_simplify_contours(image_path)
matlab_code = generate_matlab_code(contours, image_height)
write_matlab_code_to_file(matlab_code, 'output.txt')
