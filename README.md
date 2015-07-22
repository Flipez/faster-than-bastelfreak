#faster-than-bastelfreak

### Introduction

ftb is a small script that calculates how many times the given website is faster than bastelfreaks blog
Currently under development. Please help improving this app and contribute or open issues!

![Testing Screenshot](http://fs1.directupload.net/images/150717/pgmoxvho.png "Testing Screenshot")

### Installation

```bash
git clone https://github.com/Flipez/faster-than-bastelfreak.git
```

### Usage

#### Command line
You can simple use the command line to compare with bastelfreaks blog

```bash
ruby ftb.rb https://flipez.de
```

#### Webapplication

Adjust the unicorn.rb and config.ru at your needs, then run

```bash
bundle
puma -C puma.rb
```
### Thanks to

bastelfreak for not being mad at me ;)
https://blog.bastelfreak.de
