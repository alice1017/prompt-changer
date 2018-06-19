# prompt-changer

The **prompt-changer** provides a command line tool for changing **zsh prompt**.

## Usage

```
usage: prompt-changer [-h] [-l] [-c] [-t STYLE] [style]

The prompt-changer provides a command line tool for changing zsh prompt.

positional arguments:
  style          The prompt style name.

optional arguments:
  -h, --help      show this help message and exit
  -l, --list      Display the prompt styles list
  -c, --current   Output the current prompt style
  -t STYLE, --try STYLE
                  You can try a prompt style in new shell process
```

## Workflow for use

### 1. Directory structure

The prompt-changer can't change the prompt style ***without the following directory tree***.

```
~
└──  .zsh/
```

Because the prompt-changer creates a **symlink** to `.zsh` script at `~/.zsh/prompt.zsh`.

### 2. Insert a sentence to zshrc

For use prompt-chenger, you need to ***insert the following sentence*** to your `zshrc`.

```
source ~/.zsh/prompt.zsh
```

## Installation

```
$ git clone https://github.com/alice1017/prompt-changer.git
$ cd prompt-changer
$ sudo install -v -m 755 bin/prompt-changer /usr/local/bin/
```

