🖌️ VGA Paint Tool in Assembly (x86, MS-DOS)
This project is a mouse-interactive paint tool written in x86 Assembly for real-mode DOS using BIOS and DOS interrupts. It allows users to draw pixels, change colors, save, load, and clear the canvas, as well as enter textual labels into a graphic area.

📁 Features
Mouse support (via INT 33h) for drawing and UI interaction

Pixel drawing in 320x200 VGA mode (mode 0Dh)

Color palette loader from external file inter/color.txt

Custom UI with buttons: Borrar (Clear), Cargar (Load), Guardar (Save)

Text input area with limited buffer and backspace support

File operations for saving and loading sketches as .txt files

Keyboard movement using WASD keys

Direct pixel manipulation via BIOS interrupt INT 10h

🛠️ How to Compile and Run
Use TASM/MASM or DOSBox with an assembler:

bash
Copiar
Editar
tasm paint.asm
tlink paint.obj
Ensure you have the file inter/color.txt with a color layout encoded as hex characters (0–F) separated by lines ending in @.

Run the executable in DOSBox:

bash
Copiar
Editar
paint.exe
🖱️ UI Controls
Mouse Buttons:
🟥 Borrar: Clears the paint canvas

🟦 Cargar: Loads a sketch from a file (name typed in text area)

🟩 Guardar: Saves the current drawing into a file (<name>.txt)

Keyboard:
W/A/S/D: Move the current drawing cursor

0–7: Set drawing color (uses color codes)

7 = color 0Fh (white)

Typing in the bottom text area shows live characters

Enter: Confirms text

Backspace: Deletes last character

🧠 Architecture Overview
main: Program loop handling drawing and interaction

interface: Draws the borders and UI components

buttons: Handles button clicks (clear, save, load)

textArea: Text input area with character buffering

colorsPalette: Loads the palette from color.txt

cleanPaint, chargePaint, safeSketch: File operations

switchColor, move, getMouse: Input utilities

📂 File System Notes
inter/color.txt: Must exist and follow format like:

kotlin
Copiar
Editar
0123456789ABCDEF@
FEDCBA9876543210@
...
Files are saved with .txt extension, one color char per pixel, rows delimited by @.

📌 Limitations
Text area supports up to 25 characters.

Drawing region is fixed within VGA resolution.

Only hexadecimal color codes (0–F) are used.

Requires real-mode or DOS emulation (e.g., DOSBox).

✍️ Author
Developed by Jhashua as a low-level graphics programming exercise using BIOS interrupts and mouse handling in assembly language.
