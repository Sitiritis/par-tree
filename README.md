# par-tree

The aim of the project is to implement the method from [The key to a data parallel compiler](https://dl.acm.org/doi/10.1145/2935323.2935331) in Haskell and research it. The expected result of the research is a library that enables one to implement a parallel compiler without bothering of parallelizing computations on AST by themselves.

# Dependencies

See the [Dependancies](https://github.com/AccelerateHS/accelerate-llvm/blob/b177f9234bca5e1b342c3a4e5c35be82f48ab744/README.md#dependencies) section.

> LLVM 9 must be installed

## Installing LLVM 9 on Mac

Accelerate has its own [brew formula to install LLVM 9 properly](https://github.com/llvm-hs/homebrew-llvm/tree/220f10152695ab67b3f87e76e5d8dbcada72eabf). It should be used to install llvm:

```bash
brew tap llvm-hs/llvm
brew install llvm-hs/llvm/llvm-9
```

It will take some time to build and install LLVM 9 this way.

## Pop OS

When using Pop OS [cuda can be installed](https://support.system76.com/articles/cuda/) with the following command:

```bash
sudo apt install system76-cuda-latest
# Or, even better, first install apt-fast which will speed up your download and use it
apt-fast -y install system76-cuda-latest
```

The installation might not set the links to the needed files, so the build of this project will fail. This can be fixed by:

1. Add `/use/lib/cuda/bin` to your `PATH` in your `.bashrc`/`.zshrc`/etc.:

```bash
export PATH=$PATH:/usr/lib/cuda/bin
```

2. Put symbolic link to libnvvm to the location where it can be found by a linker:

```bash
sudo ln -s /usr/lib/cuda/nvvm/lib64/libnvvm.so.4 /usr/lib/
sudo ldconfig
```

# Building the project and running it

The proejct can be built to run either using a CPU or GPU backend.

## Using CPU backend

1. Build the project without `gpu` flag:

    ```bash
    stack build --flag par-tree:-gpu
    # Or just
    stack build  # since gpu flag is set to false by default
    ```

2. Run the built executable:

    ```bash
    stack exec par-tree-exe
    ```

## Using GPU backend

1. Build the project with `gpu` flag:

    ```bash
    stack build --flag par-tree:gpu
    ```

2. Run the built executable:

    ```bash
    stack exec par-tree-exe
    ```
