# My zsh notes

- [Installation](#installation)
- [Configuration](#configuration)
- [Install oh-my-zsh](#install-oh-my-zsh)
- [My plugins](#my-plugins)
- [Customizations](#customizations)
  - [Hide your username and host from the prompt](#hide-your-username-and-host-from-the-prompt)
  - [Auto copy selected text from terminal to clipboard](#auto-copy-selected-text-from-terminal-to-clipboard)
- [Custom plugins](#custom-plugins)
  - [zsh-autosuggestions (Greyed out inline suggestions)](#zsh-autosuggestions-greyed-out-inline-suggestions)
    - [Customization of auto-suggestions plugin (my_patches.zsh)](#customization-of-auto-suggestions-plugin-my_patcheszsh)
  - [zsh-syntax-highlighting](#zsh-syntax-highlighting)
  - [Autoupdate custom plugins](#autoupdate-custom-plugins)
  - [zsh-z](#zsh-z)
  - [zsh-completions](#zsh-completions)
- [My aliases](#my-aliases)
- [My .zshrc file](#my-zshrc-file)
- [Useful bash/zsh commands](#useful-bashzsh-commands)
  - [Commands (additional keybindings to the default zsh ones below)](#commands-additional-keybindings-to-the-default-zsh-ones-below)
  - [Add timestamps to history](#add-timestamps-to-history)
  - [setopt correct](#setopt-correct)
  - [Remove duplicates in zsh $PATH](#remove-duplicates-in-zsh-path)
  - [dirs -v](#dirs--v)
- [Useful cli applications](#useful-cli-applications)
  - [lf](#lf)
  - [pls](#pls)
  - [tldr for man pages](#tldr-for-man-pages)
  - [fzf](#fzf)
- [Zsh hotkeys (keybindings)](#zsh-hotkeys-keybindings)
- [Keys combinations in bash/zsh/csh](#keys-combinations-in-bashzshcsh)

## **Installation**

Nice guide: <https://medium.com/wearetheledger/oh-my-zsh-made-for-cli-lovers-installation-guide-3131ca5491fb>

1. Install zsh:
Arch: `sudo pacman -S zsh`
Ubuntu: `sudo apt install zsh`

2. Change shell: `chsh -s $(which zsh)`

3. Log out and log back in again to use your new default shell.

4. Test that it worked: `echo $SHELL`  
Expected result: `/bin/zsh` or similar.  

## **Configuration**

First run and configuration:

```
This is the Z Shell configuration function for new users,
zsh-newuser-install.

You are seeing this message because you have no zsh startup files
(the files .zshenv, .zprofile, .zshrc, .zlogin in the directory
~).  This function can help you with a few settings that should
make your use of the shell easier.

You can:

(q)  Quit and do nothing.  The function will be run again next time.

(0)  Exit, creating the file ~/.zshrc containing just a comment.
     That will prevent this function being run again.

(1)  Continue to the main menu.

--- Type one of the keys in parentheses --- 

Please pick one of the following options:

(1)  Configure settings for history, i.e. command lines remembered
     and saved by the shell.  (Recommended.)

(2)  Configure the new completion system.  (Recommended.)

(3)  Configure how keys behave when editing command lines.  (Recommended.)

(4)  Pick some of the more common shell options.  These are simple "on"
     or "off" switches controlling the shell's features.  

(0)  Exit, creating a blank ~/.zshrc file.

(a)  Abort all settings and start from scratch.  Note this will overwrite
     any settings from zsh-newuser-install already in the startup file.
     It will not alter any of your other settings, however.

(q)  Quit and do nothing else.  The function will be run again next time.
--- Type one of the keys in parentheses --- 
```

1→

```
History configuration
=====================

# (1) Number of lines of history kept within the shell.
HISTSIZE=1000                                                         (not yet saved)
# (2) File where history is saved.
HISTFILE=~/.histfile                                                  (not yet saved)
# (3) Number of lines of history to save to $HISTFILE.
SAVEHIST=1000                                                         (not yet saved)

# (0)  Remember edits and return to main menu (does not save file yet)
# (q)  Abandon edits and return to main menu

--- Type one of the keys in parentheses --- 
```

0→

```
The new completion system (compsys) allows you to complete
commands, arguments and special shell syntax such as variables.  It provides
completions for a wide range of commonly used commands in most cases simply
by typing the TAB key.  Documentation is in the zshcompsys manual page.
If it is not turned on, only a few simple completions such as filenames
are available but the time to start the shell is slightly shorter.

You can:
  (1)  Turn on completion with the default options.

  (2)  Run the configuration tool (compinstall).  You can also run
       this from the command line with the following commands:
        autoload -Uz compinstall
        compinstall
       if you don't want to configure completion now.

  (0)  Don't turn on completion.

--- Type one of the keys in parentheses --- 
```

```
The function will not be run in future, but you can run
it yourself as follows:
  autoload -Uz zsh-newuser-install
  zsh-newuser-install -f
```

```
The code added to ~/.zshrc is marked by the lines
# Lines configured by zsh-newuser-install
# End of lines configured by zsh-newuser-install
You should not edit anything between these lines if you intend to
run zsh-newuser-install again.  You may, however, edit any other part
of the file.
```

## **Install oh-my-zsh**

`sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"`

Change theme to `agnoster` in `~/.zshrc`

## **My plugins**

`~/.zshrc`:

```plugins=(aliases dirhistory dircycle web-search zsh-z copybuffer copypath colored-man-pages extract autoupdate)```

**aliases**  
<https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/aliases>  
• acs: show all aliases by group.  
• acs <keyword>: filter aliases by <keyword> and highlight.  

**autoupdate**  

**colored-man-pages**  
This plugin adds colors to man pages.

**copybuffer**  
This plugin adds the `ctrl-o` keyboard shortcut to copy the current text in the command line to the system clipboard.

**copypath**  
copies the absolute path of the current directory.  
`copypath <file_or_directory>`: copies the absolute path of the given file.

**dircycle**  
<https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/dircycle>  
Plugin for cycling through the directory stack  

This plugin enables directory navigation similar to using back and forward on browsers or common file explorers like `Finder` or `Nautilus`. It uses a small `zle` trick that lets you cycle through your directory stack left or right using `Ctrl + Shift + Left / Right` . This is useful when moving back and forth between directories in development environments, and can be thought of as kind of a nondestructive `pushd`/`popd`.  

**NOTE:** For this plugin to work in VS Code you have to specify the following setting in `settings.json`: `"terminal.integrated.sendKeybindingsToShell": true,` otherwise it will not work (due to the `Alt` key integrated terminal bindings).

**dirhistory**  
<https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/dirhistory>  
This plugin allows you to navigate the history of previous working directories using `Alt + Left` and `Alt + Right`. `Alt + Left` moves to past directories, and `Alt + Right` goes back to recent directories.

**NOTE:** Does not work well in VSCode integrated terminal (due to `Alt` keybindings), but works well in other terminals.

**extract**  
This plugin defines a function called extract that extracts the archive file you pass it, and it supports a wide variety of archive filetypes.

This way you don't have to know what specific command extracts a file, you just do extract `<filename>` and the function takes care of the rest.

**web-search**  
This plugin adds aliases for searching with Google, Wiki, Bing, YouTube and other popular services.

### **Fix Alt key behavior for some zsh plugins**

For some `zsh` plugins (like `dircycle`, `dirhistory`) to work you have to specify the following setting in `settings.json`:

```json
"terminal.integrated.sendKeybindingsToShell": true // otherwise it will not work (due to the Alt key integrated terminal bindings).
```

## **Customizations**  

Follow documentation for customizing plugins and themes: <https://github.com/ohmyzsh/ohmyzsh/wiki/Customization>  

```
Remember that customizations always take precedence over built-ins. If you happen to enjoy a particular theme that comes packaged with oh-my-zsh, but would like to change just a little detail inside of it – let's say you love the agnoster theme, it will be the easiest to copy the agnoster.zsh-theme file to your custom/themes directory and customize it. If you don't change its filename, your .zshrc file can stay the same: ZSH_THEME="agnoster" will be perfect and still take your changes into account.
```

Therefore, before doing what follows below I copied `~/.oh-my-zsh/themes/agnoster.zsh-theme` to `~/.oh-my-zsh/custom/themes/agnoster.zsh-theme` and worked with that custom theme (specifically, commented out the line with `prompt_context` as is described below). Otherwise you'll have problems updating zsh because the oh-my-zsh directory is a git repository and you shouldn't change it without committing and merging. Whereas `custom` directory is ignored by git ("By default git is set to ignore the custom directory, so that oh-my-zsh's update process does not interfere with your customizations.")

### Fonts

I like the following fonts:
<https://www.nerdfonts.com/font-downloads>

- `SourceCodePro (10)` - there is a Nerd variant at the link above
- `Ubuntu Mono Nerd` from the same link is also good
- `Monaco` font for MacOSX

### **Hide your username and host from the prompt**  

The following is taken from some online forums:

```
I don’t like it that the theme shows my username and host. To get rid of this, we change the directory to  
$ cd ~/.oh-my-zsh/themes  
1. Next we open the theme file for ‘agnoster’ in the editor 
$ nano agnoster.zsh-theme
2. Now we can change the ‘Main prompt’. We don’t need to prompt_context in the function build_prompt(). Just comment out this line or remove it. At last, change the PROMPT variable to $(build_prompt).
       
To actually see the theme, you have to source your .zshrc file like this: source ~/.zshrc. If everything worked out fine, you should see something like the cover image!
```

I did as follows:

1. Copied the theme that I use to `custom/themes/`
2. Commented out the line `prompt_context`
3. `PROMPT` looks like this `PROMPT='%{%f%b%k%}$(build_prompt) '`
4. Added timestamp at the right side:  
`RPROMPT='%{$fg[yellow]%}[%*] '`

### **Auto copy selected text from terminal to clipboard**

Add `"terminal.integrated.copyOnSelection": true`, to be able have the selected text automatically copied to the clipboard.

### **Custom plugins**  

**Important!** Do not add custom plugins to the plugin list in `.zshrc`! Otherwise you risk breaking some other settings, like for example my hotkeys from `/custom/my_patches.zsh` were ignored!

All custom plugins should go (git cloned) into `~/.oh-my-zsh/custom/plugins/`

#### **zsh-autosuggestions (Greyed out inline suggestions)**  
<https://github.com/zsh-users/zsh-autosuggestions>

A very cool plugin that I customized a bit.

Docs:

```
Installation:
Manual (Git Clone):
    1. Clone this repository somewhere on your machine. This guide will assume ~/.zsh/zsh-autosuggestions.
       
    2. git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
       
    3. Add the following to your .zshrc:
       source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
       
    4. Start a new terminal session.
```

My command:  
`git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions/`

##### **Customization of auto-suggestions plugin (my_patches.zsh)**  

A very cool plugin but requires setting up and getting used to it. Some default settings are not very useful:

• Right arrow key `→` and `End` select the proposed options and do not move cursor one symbol to the right or to the end, as would be intuitive.  
• No `clear` method – you have to go to the beginning of the line and delete everything after cursor `Ctrl+k`.  
• `Shift + Right/Left Arrows` do not select text (cursor doesn't move at all).

This can be fixed by customizing `ZLE` widgets.  
<https://github.com/zsh-users/zsh-autosuggestions#configuration>

Here you can find the global values for variables:  
<https://github.com/zsh-users/zsh-autosuggestions/blob/master/src/config.zsh>

And here you can get all keys combinations:  
<https://stackoverflow.com/questions/18042685/list-of-zsh-bindkey-commands/38950418> и <https://zsh.sourceforge.io/Doc/Release/Zsh-Line-Editor.html#Standard-Widgets>

Create a new file in `custom` directory:  
`nano ~/.oh-my-zsh/custom/my_patches.zsh`

I named it exactly like in their examples at <https://github.com/ohmyzsh/ohmyzsh/wiki/Customization#overriding-internals> :

```
oh-my-zsh's internals are defined in its lib directory. To change them, just create a file inside the custom directory (its name doesn't matter, as long as it has a .zsh ending) and start customizing whatever you want. Unsatisfied with the way git_prompt_info() works? Write your own implementation!
$ZSH_CUSTOM/my_patches.zsh 
function git_prompt_info() {
  # prove that you can do better
}
Such customization files will be loaded the last, after the built-in lib/*.zsh internals and plugins.
```

I pasted my modified blocks from the default settings (from global values)

```bash
# Strategies to use to fetch a suggestion 
# Will try each strategy in order until a suggestion is returned 
(( ! ${+ZSH_AUTOSUGGEST_STRATEGY} )) && { 
       typeset -ga ZSH_AUTOSUGGEST_STRATEGY 
       ZSH_AUTOSUGGEST_STRATEGY=(history completion) 
} 
```

I added only `completion`. The initial setting was `ZSH_AUTOSUGGEST_STRATEGY=(history)`

```bash
# Widgets that accept the entire suggestion 
(( ! ${+ZSH_AUTOSUGGEST_ACCEPT_WIDGETS} )) && { 
       typeset -ga ZSH_AUTOSUGGEST_ACCEPT_WIDGETS 
       ZSH_AUTOSUGGEST_ACCEPT_WIDGETS=( 
               end-of-line
               vi-end-of-line 
               vi-add-eol 
       ) 
} 
```

Here I deleted `forward-char` before `end-of-line`. `forward-char` is exactly `Right Arrow` in `ZLE`. Now when you press right arrow the proposed command will not be selected, but only when you press `End` (`end-of-line`).

```bash
# Widgets that accept the suggestion as far as the cursor moves 
(( ! ${+ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS} )) && { 
       typeset -ga ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS 
       ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS=( 
               forward-char 
               emacs-forward-word 
               vi-forward-word 
               vi-forward-word-end 
               vi-forward-blank-word 
               vi-forward-blank-word-end 
               vi-find-next-char 
               vi-find-next-char-skip 
       ) 
} 
```

Here I changed the default `forward-word` to `forward-char`. Now when pressing right arrow the proposed command will be selected only to cursor.

**Important!** Do not add custom plugins to the plugin list in `.zshrc`! Otherwise you risk breaking some other settings, like for example my hotkeys from `/custom/my_patches.zsh` were ignored!

#### **zsh-syntax-highlighting**  
<https://github.com/zsh-users/zsh-syntax-highlighting>

Docs:

```
Simply clone this repository and source the script:

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git

echo "source ${(q-)PWD}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ${ZDOTDIR:-$HOME}/.zshrc

Then, enable syntax highlighting in the current interactive shell:
source ./zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

Note the source command must be at the end of ~/.zshrc.
```

My commands:

`git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/`

`source ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh`

`zsh-syntax-highlighting.zsh` must be sourced at the end of the `.zshrc` file.

#### **Autoupdate custom plugins**  
<https://github.com/TamCore/autoupdate-oh-my-zsh-plugins>

Docs:

```
Create a new directory in $ZSH_CUSTOM/plugins called autoupdate and clone this repo into that directory. Note: it must be named autoupdate or oh-my-zsh won't recognize that it is a valid plugin directory.

git clone https://github.com/TamCore/autoupdate-oh-my-zsh-plugins $ZSH_CUSTOM/plugins/autoupdate

Usage
Add autoupdate to the plugins=() list in your ~/.zshrc file and you're done. The updates will be executed automatically as soon as the oh-my-zsh updater is started. Note that this will autoupdate both plugins and also themes found in the $ZSH_CUSTOM folder.
```

#### **zsh-z**  

`z` — change directories in the most frequently visited recently order ("frecent").

Trying to figure out what is better – `rupa/z` (<https://github.com/rupa/z>) or `zsh-z` (<https://github.com/agkozak/zsh-z/>), but apparently the latter is specifically for `zsh` ("ZSH-z is a native ZSH port of rupa/z, a tool written for bash"). So, I ended up using `zsh-z`.

Docs from <https://github.com/agkozak/zsh-z>:

```
Zsh-z is a native Zsh port of rupa/z, a tool written for bash and Zsh that uses embedded awk scripts to do the heavy lifting. It was quite possibly my most used command line tool for a couple of years. I decided to translate it, awk parts and all, into pure Zsh script, to see if by eliminating calls to external tools (awk, sort, date, sed, mv, rm, and chown) and reducing forking through subshells I could make it faster. The performance increase is impressive, particularly on systems where forking is slow, such as Cygwin, MSYS2, and WSL. I have found that, in those environments, switching directories using Zsh-z can be over 100% faster than it is using rupa/z.
There is a noteworthy stability increase as well. Race conditions have always been a problem with rupa/z, and users of that utility will occasionally lose their .z databases. By having Zsh-z only use Zsh (rupa/z uses a hybrid shell code that works on bash as well), I have been able to implement a zsh/system-based file-locking mechanism similar to the one @mafredri once proposed for rupa/z. It is now nearly impossible to crash the database, even through extreme testing.
There are other, smaller improvements which I try to document in Improvements and Fixes. These include the new default behavior of sorting your tab completions by frecency rather than just letting Zsh sort the raw results alphabetically (a behavior which can be restored if you like it -- see below).
Zsh-z is a drop-in replacement for rupa/z and will, by default, use the same database (~/.z), so you can go on using rupa/z when you launch bash.
```

*****
Here is a man for `rupa/z`:  
<https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/z/README>

```
DESCRIPTION
Tracks your most used directories, based on 'frecency'.

After a short learning phase, z will take you to the most 'frecent'
directory that matches ALL of the regexes given on the command line, in
order.

For example, z foo bar would match /foo/bar but not /bar/foo.

OPTIONS
-c restrict matches to subdirectories of the current directory
-e echo the best match, don't cd
-h show a brief help message
-l list only
-r match by rank only
-t match by recent access only
-x remove the current directory from the datafile

EXAMPLES
z foo cd to most frecent dir matching foo
z foo bar cd to most frecent dir matching foo, then bar
z -r foo cd to highest ranked dir matching foo
z -t foo cd to most recently accessed dir matching foo
z -l foo list all dirs matching foo (by frecency)
```

**Important!** Directories **must be visited first before** they can be jumped to!
Say, you visited Dropbox/Research. Then you can just type `z` and press Tab and it will get you to the Dropbox/Research directory.

#### **zsh-completions**  

Install `zsh-completions`: `sudo pacman -S zsh-completions`

## **My aliases**  

To see all aliases use `alias` command or install `aliases` plugin and use the `acs` command.

```bash

# Git aliases
alias ga="git add"
alias gaa="git add --all"
alias gc="git commit -m"
alias pull="git pull"
alias push="git push"
alias ch="git checkout"
alias gb="git branch"
alias gd="git difftool"
alias gl="git log"
alias rf="git reflog"
alias gs="git status"
alias gr="git restore"
alias gsl="git stash list"
alias gss="git stash save"
alias gsa="git stash apply"
alias gsp="git stash pop"
alias gcv="git cherry -v"
alias grs="git reset"
alias gm="git merge"

# alias to show a timestamp next to commands in history
alias h="history -i"
alias hg="history -i | grep"
alias hs="history -i | grep"

# Alias for uptime
alias up="uptime"
# alias for reboot
alias rb="sudo reboot"

### Python and Django aliases
alias python='python3'
alias ps='poetry shell'
alias de='deactivate'
alias py='ipython'
alias pm='manage'
alias mm='manage makemigrations'
alias mg='manage migrate'
alias rs='manage runserver'

# Alias for Ubuntu's apt
alias ud='sudo apt update'
alias ug='sudo apt upgrade'
alias inst='sudo apt install'
alias auto='sudo apt autoremove'

# Alias for web-search plugin 
alias goo='web_search google'
alias yt='web_search duckduckgo \!yt'
alias so='web_search stackoverflow'
```

## **My .zshrc file**  

```bash
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="agnoster"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(aliases dirhistory dircycle web-search zsh-z copybuffer copypath colored-man-pages extract autoupdate)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Git aliases
alias ga="git add"
alias gaa="git add --all"
alias gc="git commit -m"
alias pull="git pull"
alias push="git push"
alias ch="git checkout"
alias gb="git branch"
alias gd="git difftool"
alias gl="git log"
alias rf="git reflog"
alias gs="git status"
alias gr="git restore"
alias gsl="git stash list"
alias gss="git stash save"
alias gsa="git stash apply"
alias gsp="git stash pop"
alias gcv="git cherry -v"
alias grs="git reset"
alias gm="git merge"

# alias to show a timestamp next to commands in history
alias h="history -i"
alias hg="history -i | grep"
alias hs="history -i | grep"

# Alias for uptime
alias up="uptime"
# alias for reboot
alias rb="sudo reboot"

### Python and Django aliases
alias python='python3'
alias ps='poetry shell'
alias de='deactivate'
alias py='ipython'
alias pm='manage'
alias mm='manage makemigrations'
alias mg='manage migrate'
alias rs='manage runserver'
### Poetry PATH
# Add poetry directory to PATH to invoke it as 'poetry'
export PATH="$HOME/.local/bin:$PATH"
# export PATH="$HOME/.poetry/bin:$PATH"
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# Alias for Ubuntu's apt
alias ud='sudo apt update'
alias ug='sudo apt upgrade'
alias inst='sudo apt install'
alias auto='sudo apt autoremove'

# Alias for web-search plugin 
alias goo='web_search google'
alias yt='web_search duckduckgo \!yt'
alias so='web_search stackoverflow'

# # Changing the default f**k word to something more pleasant
# eval $(thefuck --alias)
# # You can use whatever you want as an alias, like for Mondays:
# eval $(thefuck --alias omg)

# For zsh-z
zstyle ':completion:*' menu select

# For fzf
source /usr/share/doc/fzf/examples/key-bindings.zsh
source /usr/share/doc/fzf/examples/completion.zsh

autoload -U compinit && compinit

# stripe completion
fpath=(~/.stripe $fpath)
autoload -Uz compinit && compinit -i

source ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
source ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
```

## **Useful bash/zsh commands**  

### **Commands (additional keybindings to the default zsh ones below)**  

`..` - `cd` to the parent directory  
`...` - cd to grand-parent directory, etc.  
`Ctrl+P` / `Alt+P` – same as `UpArrow` (previous command)  
`Ctrl+Shift+Left/Right` – `cd` to previous/next directory in the `dircycle` plugin.  
`Ctrl+o` – copy text from the terminal in `copybuffer` plugin.  

### **Add timestamps to history**  

Add to `~/.zsshrc`:

```bash
# alias to show a timestamp next to commands in history
alias h="history -i"
alias hg="history | grep -i"
```

### **setopt correct**  

`setopt correct` (in the command line prompt) corrects commands (`sl` → `ls`, etc.). To stop this execute `unsetopt correct` (doesn't seem to work)

### **Remove duplicates in zsh $PATH**  

```bash
typeset -aU path
```

### **dirs -v**  

View all visited directories  

## **Useful cli applications**  

### **lf**  

Command-line file manager

### **pls**  

Installed a prettier `ls` which shows icons and has very beautiful colors:
<https://dhruvkb.github.io/pls/get_started/installation.html>  
I installed `pipx`, added `~/.local/bin` to `PATH`.  
In order for it to work you have to install a `Nerd` font that will support icons. I chose Hack Nerd Font Mono – see <https://www.nerdfonts.com/>  
Then I had to change my VS Code terminal font to `Hack Nerd Font Mono`.  

### **tldr for man pages**  

I tried using this Python client, but it was rather slow: <https://github.com/tldr-pages/tldr-python-client>  
`sudo pacman -S tldr`  
I then found `tealdeer` and switched to it (python `tldr` needs to be removed to use this Rust client):
<https://github.com/dbrgn/tealdeer>
<https://dbrgn.github.io/tealdeer/>  
`yay -S tealdeer`  
It is larger than python client, because it installs rust (526 Mb) as dependency. `tealdeer` keeps all cache offline (thus it does not need network to work).  
Then `$ tldr --seed-config` to create a config file which can be looked at `$ tldr –config-path`. In my case it was at `~/.config/tealdeer/config.toml`. I changed some default colors. Here is my custom `config.toml`:

```toml
[style.description]
underline = false
bold = false

[style.command_name]
foreground = "red"
underline = false
bold = false

[style.example_text]
foreground = "green"
underline = false
bold = false

[style.example_code]
foreground = "red"
underline = false
bold = false

[style.example_variable]
foreground = "white"
underline = true
bold = false

[display]
compact = false
use_pager = false

[updates]
auto_update = false
auto_update_interval_hours = 720
```

### **fzf**  

`sudo pacman -S fzf`  
add these lines to `~/.zshrc`:  

```bash
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh
```

Using the `fzf` finder:
• `CTRL-J` / `CTRL-K` (or `CTRL-N` / `CTRL-P`) to move cursor up and down
• `Enter` key to select the item, `CTRL-C` / `CTRL-G` / `ESC` to exit
• In multi-select mode (`-m`), `TAB` and `Shift-TAB` to mark multiple items
• Emacs style key bindings
• Mouse: scroll, click, double-click; shift-click and shift-scroll on multi-select mode

### **Zsh hotkeys (keybindings)**  

**DELETE**  
Delete from the cursor to the end of the line: `Ctrl + K`  
Delete a word backwards: `Ctrl + W` (or `ESC + [backspace]`)  
Delete the word after the cursor: `Alt + D`  
Delete entire line (`zsh` only): `Ctrl + U` (in `bash` this deletes all from beginning to cursor)  
Clear screen: `Ctrl + L`  

**MOVE**  
Move to the beginning of the line: `Ctrl + A`  
Move to the end of the line: `Ctrl + M`  
Move one word backward: `Ctrl + ←` or `Alt + B`  
Move one word forward: `Ctrl + →` or `Alt + F`  

**Undo** the last change: `Ctrl + Shift + minus` i.e. `Ctrl + _`  

**History Search**  
Press `Ctrl + R` to search through the history.  
Continue pressing `Ctrl + R` until you find the entry you're looking for.  
Press `[ENTER]` to execute the current expression.  
Press `[Right Arrow]` to modify the current expression.  
Press `Ctrl + G` to escape from search mode.  

**Command Action**  
`!!` - Execute last command in history  
`!abc` - Execute last command in history beginning with `abc`  
`!abc:p` - Print last command in history beginning with `abc`  

Finally, typing double bangs (`!!`) brings back the last command anywhere in the line. This is useful, for instance, if you forgot to type `sudo` to execute commands that require elevated privileges:

```bash
$ less /var/log/dnf.log
/var/log/dnf.log: Permission denied
$ sudo !! 
$ sudo less /var/log/dnf.log
```

Stop output to screen: `Ctrl + S`  
Re-enable screen output: `Ctrl + Q`  
Terminate/kill current foreground process: `Ctrl + C`  
Suspend/stop current foreground process: `Ctrl + Z`  

Shortcuts can be used to change the case of words as well. To make the current word after the cursor uppercase, use `[Alt][U]`. To make it lowercase, use `[Alt][L]`. Note that cursor position here is important, if the cursor is midway in the word, only the part of the word after the cursor will have the case changed. To capitalize a word, use `[Alt][C]` (this is also cursor-position-dependent; if the cursor is midway in a word, that letter will be capitalized).

### **Keys combinations in bash/zsh/csh**  

**Ctrl**  
`Ctrl + a` — go to start of the line (cisco, csh, zsh)  
`Ctrl + b` — go one character back (cisco, csh, zsh)  
`Ctrl + c` — send SIGINT and usually aborts the current task (csh, zsh)  
`Ctrl + d` — delete a symbol (same as delete) (cisco, csh, zsh)  
`Ctrl + e` — go to the end of the line (cisco, csh, zsh)  
`Ctrl + f` — go one symbol forward (cisco, csh, zsh)  
`Ctrl + k` — delete all characters till the end of the line (cisco, csh, zsh)  
`Ctrl + l` — clear the screen. Same as clear. (csh, zsh)  
`Ctrl + r` — search in history and repeat the search (incremental listing of the search results). (zsh)  
`Ctrl + j` — stop the search and edit the found command. Without search same as `return` (or execute the command in zsh)  
`Ctrl + t` — change the current symbol for the previous one. (cisco, csh, zsh)  
`Ctrl + u` — delete all symbols to the left from cursor till the start of the line(cisco) or delete entire line (csh, zsh)  
`Ctrl + w` — delete symbols to the left from cursor to the beginning of the word. (cisco, csh, zsh)  
`Ctrl + xx` — move from the current sursor position to the beginning of the line and back (csh). Same as `ctrl + u` (cisco).
`Ctrl + x @` — show possible host name completions taken from `/etc/hosts`.  
`Ctrl + z` — suspend current task (csh, zsh)  
`Ctrl + x`; `Ctrl + e` — open `$EDITOR` to modify the entered line. After save the command is sent for execution. If the variable is not set then the system editor is opened.  

**Alt**  
`Alt + <` — go to the first command in history (zsh)  
`Alt + >` — go to the last command in history
`Alt + ?` — show all possible completions (same as `tab-tab`) (same as `which string` in csh, zsh)  
`Alt + *` — paste all possible completions of the command into the prompt  
`Alt + /` — try to complete the file name (same as `tab`)  
`Alt + .` — paste the last command's last argument (same as `!$` without `:p` to check it)
`Alt + b` — move cursor one word to the left (cisco, csh, zsh)  
`Alt + c` — convert the current letter to UPPERCASE and all others to lowercase (cisco, csh, zsh)  
`Alt + d` — delete all symbols from cursor to the end of the word (cisco, csh, zsh)  
`Alt + f` — move cursor one word forward (cisco, csh, zsh)  
`Alt + l` — convert all letters from current cursor position to the end of the word to lowercase (cisco, csh, zsh)  
`Alt + t` — swap current word with the previous one (zsh)
`Alt + u` — convert all letters from the current cursor position to the end of the word to UPPERCASE (cisco, csh, zsh)  
`Alt + back-space` — delete all symbols from cursor to the beginning of the word (cisco, csh, zsh)  

**Tab**  
`tab-tab` — commad completion. If pressed on an empty line will show the list of all available commands  
`(string)tab-tab` — list all possible completions
`(dir)tab-tab` — show dir's subdirectories
`*tab-tab` — show subdirectries including hidden (with .)  
`~tab-tab` — show all users rfom `/etc/passwd`. By completing user's name you can `cd` into their home directory.  
`$tab-tab` — show the list of completions for system variables  
`@tab-tab` — completions for host names from `/etc/hosts`  
`=tab-tab` — list current directory (same as `ls`).  
