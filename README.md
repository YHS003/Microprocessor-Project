# x86 Assembly Calculator

![Assembly Language](https://img.shields.io/badge/Assembly-x86-red)
![DOSBox](https://img.shields.io/badge/Runs%20on-DOSBox-blue)

A complete 16-bit calculator program written in x86 assembly language, developed for a Microprocessor course. This program performs basic arithmetic operations (addition, subtraction, multiplication, and division) on two 16-bit numbers.

## Features

- 🧮 **Four Basic Operations**: Supports +, -, *, / with proper error handling
- 🔢 **16-bit Integer Arithmetic**: Handles numbers from -32,768 to 32,767
- 🚨 **Error Handling**: Detects division by zero and invalid operations
- ⌨️ **User-Friendly Interface**: Interactive prompts and clear result display
- 📟 **DOS Compatible**: Designed to run in real-mode DOS environments

## Technical Specifications

- **Language**: x86 Assembly (MASM/TASM compatible syntax)
- **Memory Model**: Small model (code + data ≤ 64KB)
- **Stack Size**: 256 bytes (100h)
- **Input Method**: Console input with digit validation
- **Output**: Formatted decimal display with sign handling

## Course Context

Developed as part of our Microprocessor Systems course (CS/EE 3XX) at [Your College Name], this project demonstrates:
- Low-level programming concepts
- x86 architecture fundamentals
- DOS interrupt usage (INT 21h)
- Register manipulation techniques
- Procedure-oriented assembly programming

## Requirements

- DOSBox or similar x86 emulator
- MASM/TASM assembler
- 16-bit Windows/DOS environment

## How to Use

1. Assemble with: `masm calculator.asm;`
2. Link with: `link calculator;`
3. Run in DOSBox: `calculator.exe`

## Sample Output
Enter first number: 125
Enter second number: 25
Choose operation (+ - * /): *
Result: 3125


## Project Structure

- `calculator.asm`: Main assembly source file
- `README.md`: This documentation file
- (Optional) `Makefile`: Build automation
