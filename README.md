# prompt-changer

The **prompt-changer** provides a command line tool for changing **zsh prompt**.

[![asciicast](https://asciinema.org/a/187883.png)](https://asciinema.org/a/187883)

## Installation

```
$ git clone https://github.com/alice1017/prompt-changer.git
$ cd prompt-changer
$ sudo install -v -m 755 bin/prompt-changer /usr/local/bin/
```

## Prepare for use

```
$ mkdir -p ~/.zsh
$ echo "source ~/.zsh/prompt.zsh" >> ~/.zshrc
```

The prompt-changer can't change the prompt **without** `~/.zsh` directory.
Because the prompt-changer creates a **symlink** to zsh script at `~/.zsh/prompt.zsh`

And, you need to **insert the 'source' sentence** to`.zshrc` for loading `~/.zsh/prompt.zsh`

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


