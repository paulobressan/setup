# Setup
My current development environment configuration.

![Screencast from 2024-08-10 16-37-32](https://github.com/user-attachments/assets/1ecb6a2c-2c16-41dd-8743-78f084180fc2)

-  [Fedora Linux](https://fedoraproject.org)

# Install
Make sure that you already have installed the tools below on your computer.

## Common tools
- [zsh](https://ohmyz.sh/#install)
- [nvim](https://github.com/neovim/neovim/blob/master/INSTALL.md) 
- [alacritty](https://github.com/alacritty/alacritty/blob/master/INSTALL.md)
- [zellij](https://zellij.dev/documentation/installation)
- [ripgrep](https://github.com/BurntSushi/ripgrep)
- [fd](https://github.com/sharkdp/fd)

Execute the configure script to create the symbolic links.

```sh
./configure
```

## Kubernetes tools
Some tools to help access and handle k8s environment.

- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux)
- [kubectx](https://github.com/ahmetb/kubectx)
- [k9s](https://k9scli.io)

# How to start 
Basic commands to start using the tools.

## nvim
The Lazy is being used to manage plugins and it will be installed automaticly. 

Install nvim plugins 
```
:Lazy install
```

Mason plugin is being used to manage the lsp servers configured in `lua/plugins/lsp.lua`.

Install lsp servers
```
:Mason
```

(Optional) Install a nerd font to have all icons supported.
