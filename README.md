# VimHDL

Vim functions for VHDL.

## Functions

### Indent
Indent the right side of VHDL lines, whether they are delimited by __:__, __<=__ or __=>__.

#### Example
```VHDL
signal sig0        : std_logic;
signal signal1 : std_logic;
signal signaltwo : std_logic_vector(1 downto 0);
```
Into
```VHDL
signal sig0       : std_logic;
signal signal1    : std_logic;
signal signaltwo  : std_logic_vector(1 downto 0);
```
#### Mapping
```VimScript
vmap YourMap <plug>(VimHDLIndent)
```

## Installation
Clone into `~/.vim/pack/*/start/`
