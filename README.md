# skx86 - A Homebrew x86 Kernel

## Overview

skx86 is a custom-built simple kernel developed from the ground up as a personal project. It serves as a platform for experimenting with various system-level concepts.
## Features

- Interrupt Handling
- Paging
- Heap
- Disk Management

## Getting Started
### Disclaimer

**Please Note: This project is unfinished and will never be completed.It is provided for educational and experimental purposes only. It may contain bugs or incomplete features.**


### Prerequisites

- **x86-compatible PC:** skx86 is designed to run on x86-based hardware. It is recommended to use an emulator or virtual machine for testing.
- **Development Environment:** Set up a development environment with a compatible toolchain, such as NASM for assembly and GCC for C code.

### Building and Running skx86

1. Clone the repository to your local machine.

```bash
git clone https://github.com/ms0g/skx86.git
```
2. Navigate to the project directory.
```bash
cd skx86
```
3. Build the OS using
```bash
make
```
4. Run on qemu
```bash
make run
```
## Contribution

Contributions are welcome! Feel free to fork this repository, make improvements, and submit pull requests.

## License
skx86 is licensed under the MIT License.
