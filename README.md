# Körmös - A Homebrew Operating System

## Overview

Körmös is a custom-built operating system developed from the ground up as a personal project. It serves as a platform for experimenting with various system-level concepts.

## Features

- **Interrupt Handling:** Körmös efficiently manages interrupts, allowing for seamless handling of hardware events and ensuring system stability.
- **Disk Management:** Körmös incorporates disk management functionality, utilizing the ATA controller for read and write operations to external storage devices, further expanding data storage capabilities.
- **Paging Management:** The OS employs advanced paging techniques, optimizing memory usage and facilitating smooth multitasking by efficiently managing memory resources.
- **Heap Management:** Körmös incorporates a dynamic memory allocation system, allowing programs to request and release memory blocks from a designated heap, enhancing flexibility and efficiency in memory usage.
tem.

## Getting Started
### Disclaimer

**Please Note: This project is intentionally left unfinished and is provided for educational and experimental purposes only. It is not intended for production use and may contain bugs or incomplete features.**


### Prerequisites

- **x86-compatible PC:** Körmös is designed to run on x86-based hardware. It is recommended to use an emulator or virtual machine for testing.
- **Development Environment:** Set up a development environment with a compatible toolchain, such as NASM for assembly and GCC for C code.

### Building and Running Körmös

1. Clone the repository to your local machine.

```bash
git clone https://github.com/ms0g/kormos.git
```
2. Navigate to the project directory.
```bash
cd kormos
```
3. Build the OS using
```bash
make
```
### Contribution

Contributions are welcome! Feel free to fork this repository, make improvements, and submit pull requests.

### License
Körmös is licensed under the MIT License.
