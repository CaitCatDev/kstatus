# kstatus
A simple lua status line for nvim 

## How to install 

add a entry for your plugin manager or manually install it. 
For example you could place it `~/.config/nvim/lua/kstatus`

or e.g. using a plugin manager like packer
```lua
    use { "CaitCatDev/kstatus.git" }

    --Later in plugin setup
    require("kstatus").setup({})
```

## TODO: 
- [X] Currently user config is not supported
- [] add more style options
- [] scaling with window size?
- [] clean up code especially LSP code
