# Setup
My current development environment configuration.

https://github.com/user-attachments/assets/0e384615-affc-442b-a602-b90f0e195ca1


-  [Fedora Linux](https://fedoraproject.org)

# Install
Make sure that you already have installed the tools below on your computer.

- [zsh](https://ohmyz.sh/#install)
- [nvim](https://github.com/neovim/neovim/blob/master/INSTALL.md) 
- [alacritty](https://github.com/alacritty/alacritty/blob/master/INSTALL.md)
- [zellij](https://zellij.dev/documentation/installation)

Execute the install script to create the symbolic links.

```sh
./configure
```

# How to start 

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
