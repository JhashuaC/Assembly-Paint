import tkinter as tk
from tkinter import filedialog
from PIL import Image
import numpy as np

color_map = {
    (0, 0, 255): 1,    
    (0, 255, 0): 2,  
    (0, 255, 255): 3,
    (255, 0, 0): 4,   
    (255, 0, 255): 5, 
    (139, 69, 19): 6,
    (255, 255, 255): 7,
    (128, 128, 128): 8, 
    (173, 216, 230): 9,
    (0, 0, 0): 0      
}

def closest_color(pixel):
    min_distance = float('inf')
    closest_val = 0
    for color, val in color_map.items():
        distance = np.sqrt(sum((p - c) ** 2 for p, c in zip(pixel, color)))
        if distance < min_distance:
            min_distance = distance
            closest_val = val
    return closest_val

def load_and_convert_image(image_path, output_path):
    img = Image.open(image_path).resize((199, 119))
    img = img.convert('RGB')  
    img_array = np.array(img)
    
    result_matrix = np.zeros((120, 200), dtype=int)
    for i in range(img_array.shape[0]):
        for j in range(img_array.shape[1]):
            pixel = tuple(img_array[i, j][:3])
            result_matrix[i, j] = closest_color(pixel)
    
    with open(output_path, 'w') as f:
        for row in result_matrix:
            row_text = ''.join(map(str, row)) + '@' 
            f.write(row_text + '\n')
    
    print(f"Matriz de colores guardada en {output_path}")

def open_image():
    file_path = filedialog.askopenfilename(filetypes=[("Image Files", "*.png *.jpg *.jpeg *.bmp")])
    if file_path:
        image_name = file_path.split('/')[-1].split('.')[0]
        output_path = f"{image_name}.txt"
        load_and_convert_image(file_path, output_path)
        label_result.config(text=f"Output guardado en: {output_path}")


root = tk.Tk()
root.title("Convertir Imagen a Matriz de Colores")

label_instruction = tk.Label(root, text="Selecciona una imagen para convertir:")
label_instruction.pack(pady=10)

button_open = tk.Button(root, text="Abrir Imagen", command=open_image)
button_open.pack(pady=5)

label_result = tk.Label(root, text="")
label_result.pack(pady=10)

root.mainloop()
