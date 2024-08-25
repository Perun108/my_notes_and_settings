# Using SyncThing to sync notes, folders (Obsidian, etc.)

Follow official guide: <https://docs.syncthing.net/intro/getting-started.html>

## What I did

- Install syncthing on all machines that you want to sync (Linux, Android, Mac, etc.) and run it on all of them (Run `syncthing` from the terminal on Linux or Mac and it will open a Web UI in browser)
- On the first machine (laptop):
  - Create a folder where you want to keep all your data to be synced (`mkdir ~/Documents/MyObsidianNotesBackUp/`)
  - Add this folder to SyncThing Web UI (on the right, where the local folders are)
  - Give it a name (`MyNotes-Ubuntu`)
  - Click `Add remote device`
  - If you have syncthing open on another machine it will suggest its ID under `Device ID` (` You can also select one of these nearby devices: `)
  - Select suggested device ID or enter its ID from the other machine
  - Give it a name (`MyNotes-Android`)
  - Go to `Sharing` tab and check your local folder name (`MyNotes-Ubuntu`)
  - Click on `Identification` to display the first device's QR code. Scan it with the second device (if it's your phone) or enter the ID into the second device.
  - Create a similar folder on the other device
  - Open syncthing on the other device and go to `Folders` and add the path to that new folder there.
  - Go to `Devices` and open QR scanner to add the first device.

# IMPORTANT! Sync won't start for mobile devices at this point - you have to open Web UI on your phone from the syncthing Android client-> Settings and `Add new folder` in the prompt that you'll see there and then enter the path to your sync folder on your phone

You can also set up git version control system for the synced notes for backup and automate it with cron:

- Create a repo on Github
- Initialize a git repo inside your synced folder (add `.obsidian/` and `.stfolder/` to `.gitignore`)
- Set up remove url and origin branch as usual
- Create a `sh` file inside the folder:

```bash
#!/bin/bash

# Add all changes to the staging area
git add .

# Check if there are any changes to be committed
if ! git diff-index --quiet HEAD --; then
  # Commit and push changes if there are any
  git commit -m "Auto-commit $(date)"
  git push origin main
else
  echo "No changes to commit."
fi
```

- Make it executable: `chmod +x ~/Documents/MyObsidianSync/cron_push_script.sh`
- Open cron: `crontab -e`
- Add cron job into the cron file (I added it to run at noon every sunday):
`0 12 * * 6 ~/Documents/MyObsidianSync/cron_push_script.sh`
- Check that it was added to the schedule: `crontab -l`

# Syncing dotfiles

## Using `meld`

1. Machine 1. Compare changes between local config and git repo with `meld`: `meld ~/.config/nvim/ ~/dotfiles/nvim/` and copy the necessary lines into git repo directory directly in `meld`.
2. Machine 1. Review changes: `cd ~/dotfiles && git difftool`. Add, commit, push.
3. Machine 2. Pull all changes: `cd ~/dotfiles && git pull`.
4. Machine 2. Compare changes with `meld`: `meld ~/.config/nvim/ ~/dotfiles/nvim/` and copy needed lines into local config directory directly in `meld`.

How to install `meld` on MacOS <https://gitlab.com/dehesselle/meld_macos>
See also discussion <https://gitlab.gnome.org/GNOME/meld/-/issues/804>

## Sync dotfiles with a special git bare repo and alias

I tried this setup and didn't like it. It sounds promising but I found it hard to maintain and potentially prone to issues.

I followed this setup:
<https://www.anand-iyer.com/blog/2018/a-simpler-way-to-manage-your-dotfiles/>

which is a version of this original post:
<https://news.ycombinator.com/item?id=11070797>

I also utilized this post written on its basis:
<https://www.atlassian.com/git/tutorials/dotfiles>

---

Here's what I did:

```
mkdir $HOME/.dotfiles
git init --bare $HOME/.dotfiles
alias dotfiles='/usr/local/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
dotfiles config --local status.showUntrackedFiles no
dotfiles remote add origin git@github.com:Perun108/dotfiles.git
echo "alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'" >> $HOME/.zshrc
```

You can now use regular git commands with dotfiles command (add, commit, push, status, etc.)

Another machine:

```
git clone --separate-git-dir=$HOME/.dotfiles https://github.com/Perun108/.dotfiles.git
alias dotfiles='/usr/local/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME' # For MacOS it's `alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'`
dotfiles config --local status.showUntrackedFiles no
```

Here's the version I used in case the post is deleted:

A simpler way to manage your dotfiles
May 5, 2018
2018 · Tips  
Like most folks, I use git to manage my dotfiles. This lets me have a versioned backup for my configurations, and if something breaks (and it does often for me) I can revert to a working configuration fairly easily. For a long time, I’ve followed the normal path of having a dotfiles folder and a script that symlinks into the files in it from my $HOME. Recently, I came across this thread in HackerNews and it literally blew my mind. In this post, I would like to share this very elegant solution that avoids the need for any symlinking.

The key idea is really simple: make $HOME the git work-tree. The normal way of doing this would be to do a git init in your $HOME, but that would totally mess up git commands if you have other repositories in your $HOME (also, you probably don’t want your entire $HOME in a git repo). So, instead, we will create a dummy folder and initialize a bare repository (essentially a git repo with no working directory) in there. All git commands will be run with our dummy as the git directory, but $HOME as the work directory.
First Time Setup

Setting this method up the first time is really easy. First, let’s create our bare repository. I chose to name my placeholder .dotfiles (duh!)

mkdir $HOME/.dotfiles
git init --bare $HOME/.dotfiles

Now for the fun part. We will make an alias for running git commands in our .dotfiles repository. I’m calling my alias dotfiles:

alias dotfiles='/usr/local/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

Add this alias to your .bashrc or .zshrc. From now on, any git operation you would like to do in the .dotfiles repository can be done by the dotfiles alias. The cool thing is that you can run dotfiles from anywhere.

Let’s add a remote, and also set status not to show untracked files:

dotfiles config --local status.showUntrackedFiles no
dotfiles remote add origin <git@github.com>:anandpiyer/.dotfiles.git

You’ll need to change the remote URL to your git repo. Now, you can easily add the config files you want to be in version control from where they are supposed to be, commit and push. For example, to add tmux config files, I’ll do:

cd $HOME
dotfiles add .tmux.conf
dotfiles commit -m "Add .tmux.conf"
dotfiles push

Setting Up a New Machine

To set up a new machine to use your version controlled config files, all you need to do is to clone the repository on your new machine telling git that it is a bare repository:

git clone --separate-git-dir=$HOME/.dotfiles <https://github.com/anandpiyer/.dotfiles.git> ~

However, some programs create default config files, so this might fail if git finds an existing config file in your $HOME. In that case, a simple solution is to clone to a temporary directory, and then delete it once you are done:

git clone --separate-git-dir=$HOME/.dotfiles https://github.com/anandpiyer/.dotfiles.git tmpdotfiles
rsync --recursive --verbose --exclude '.git' tmpdotfiles/ $HOME/
rm -r tmpdotfiles

There you go. No symlink mess.

## Here's the atlassian post

Dotfiles: Best way to store in a bare git repository

Disclaimer: the title is slightly hyperbolic, there are other proven solutions to the problem. I do think the technique below is very elegant though.

Recently I read about this amazing technique in an Hacker News thread on people's solutions to store their dotfiles. User StreakyCobra showed his elegant setup and ... It made so much sense! I am in the process of switching my own system to the same technique. The only pre-requisite is to install Git.

In his words the technique below requires:

No extra tooling, no symlinks, files are tracked on a version control system, you can use different branches for different computers, you can replicate you configuration easily on new installation.

The technique consists in storing a Git bare repository in a "side" folder (like $HOME/.cfg or $HOME/.myconfig) using a specially crafted alias so that commands are run against that repository and not the usual .git local folder, which would interfere with any other Git repositories around.
Starting from scratch

If you haven't been tracking your configurations in a Git repository before, you can start using this technique easily with these lines:

git init --bare $HOME/.cfg
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
config config --local status.showUntrackedFiles no
echo "alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'" >> $HOME/.bashrc

    The first line creates a folder ~/.cfg which is a Git bare repository that will track our files.
    Then we create an alias config which we will use instead of the regular git when we want to interact with our configuration repository.
    We set a flag - local to the repository - to hide files we are not explicitly tracking yet. This is so that when you type config status and other commands later, files you are not interested in tracking will not show up as untracked.
    Also you can add the alias definition by hand to your .bashrc or use the the fourth line provided for convenience.

I packaged the above lines into a snippet up on Bitbucket and linked it from a short-url. So that you can set things up with:

curl -Lks <http://bit.do/cfg-init> | /bin/bash

After you've executed the setup any file within the $HOME folder can be versioned with normal commands, replacing git with your newly created config alias, like:

config status
config add .vimrc
config commit -m "Add vimrc"
config add .bashrc
config commit -m "Add bashrc"
config push

Installing your dotfiles onto a new system (or migrate to this setup)

If you already store your configuration/dotfiles in a Git repository, on a new system you can migrate to this setup with the following steps:

    Prior to the installation make sure you have committed the alias to your .bashrc or .zsh:

alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

    And that your source repository ignores the folder where you'll clone it, so that you don't create weird recursion problems:

echo ".cfg" >> .gitignore

    Now clone your dotfiles into a bare repository in a "dot" folder of your $HOME:

git clone --bare <git-repo-url> $HOME/.cfg

    Define the alias in the current shell scope:

alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

    Checkout the actual content from the bare repository to your $HOME:

config checkout

    The step above might fail with a message like:

error: The following untracked working tree files would be overwritten by checkout:
.bashrc
.gitignore
Please move or remove them before you can switch branches.
Aborting

This is because your $HOME folder might already have some stock configuration files which would be overwritten by Git. The solution is simple: back up the files if you care about them, remove them if you don't care. I provide you with a possible rough shortcut to move all the offending files automatically to a backup folder:

mkdir -p .config-backup && \
config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | \
xargs -I{} mv {} .config-backup/{}

    Re-run the check out if you had problems:

config checkout

    Set the flag showUntrackedFiles to no on this specific (local) repository:

config config --local status.showUntrackedFiles no

    You're done, from now on you can now type config commands to add and update your dotfiles:

config status
config add .vimrc
config commit -m "Add vimrc"
config add .bashrc
config commit -m "Add bashrc"
config push

Again as a shortcut not to have to remember all these steps on any new machine you want to setup, you can create a simple script, store it as Bitbucket snippet like I did, create a short url for it and call it like this:

curl -Lks <http://bit.do/cfg-install> | /bin/bash

For completeness this is what I ended up with (tested on many freshly minted Alpine Linux containers to test it out):

git clone --bare <https://bitbucket.org/durdn/cfg.git> $HOME/.cfg
function config {
   /usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME $@
}
mkdir -p .config-backup
config checkout
if [ $? = 0 ]; then
echo "Checked out config.";
else
echo "Backing up pre-existing dot files.";
config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} .config-backup/{}
fi;
config checkout
config config status.showUntrackedFiles no

## Here's the original post if case the page is deleted

StreakyCobra on Feb 10, 2016 | next [–]

I use:

    git init --bare $HOME/.myconf
    alias config='/usr/bin/git --git-dir=$HOME/.myconf/ --work-tree=$HOME'
    config config status.showUntrackedFiles no

where my ~/.myconf directory is a git bare repository. Then any file within the home folder can be versioned with normal commands like:

    config status
    config add .vimrc
    config commit -m "Add vimrc"
    config add .config/redshift.conf
    config commit -m "Add redshift config"
    config push

And so one…

No extra tooling, no symlinks, files are tracked on a version control system, you can use different branches for different computers, you can replicate you configuration easily on new installation.
seliopou on Feb 10, 2016 | parent | next [–]
To complete the description of the workflow (for others), you can replicate your home directory on a new machine using the following command:

git clone --separate-git-dir=~/.myconf /path/to/repo ~

This is the best solution I've seen so far, and I may adopt it next time I get the itch to reconfigure my environment.
telotortium on Feb 11, 2016 | root | parent | next [–]
For posterity, note that this will fail if your home directory isn't empty. To get around that, clone the repo's working directory into a temporary directory first and then delete that directory,

    git clone --separate-git-dir=$HOME/.myconf /path/to/repo $HOME/myconf-tmp
    cp ~/myconf-tmp/.gitmodules ~  # If you use Git submodules
    rm -r ~/myconf-tmp/
    alias config='/usr/bin/git --git-dir=$HOME/.myconf/ --work-tree=$HOME'

and then proceed as before.

durdn on Feb 17, 2016 | root | parent | next [–]
I found out exactly the same problem :)
durdn on Feb 17, 2016 | parent | prev | next [–]
As promised I wrote a post about your setup. Thanks a lot for bringing the technique to my attention: <https://developer.atlassian.com/blog/2016/02/best-way-to-sto>...

StreakyCobra on Feb 22, 2016 | root | parent | next [–]
Really nice, well explained. I'll know where to point people to when I need to present this techique. Thanks!

aprdm on Feb 10, 2016 | parent | prev | next [–]
Can you write a blog post on your workflow? I would love to learn more on how you to use it :P

StreakyCobra on Feb 10, 2016 | root | parent | next [–]
There are probably already posts about this: I didn't invented it, I read it somewhere… but it was long time ago, I don't remember where.

durdn on Feb 10, 2016 | root | parent | prev | next [–]
I'm trying to reproduce it and documenting it as I go... ok I got it working now and I have notes. Stay tuned.

StreakyCobra on Feb 10, 2016 | root | parent | next [–]
It's probably better if you do it then :-) I would probably skip some important parts trying to explain because I'm too much used to it already.

Siilwyn on Feb 13, 2016 | root | parent | next [–]
Finally got mine working, it does need some figuring out especially the replication part. I documented the needed commands here: <https://github.com/Siilwyn/my-dotfiles/tree/master/.my-dotfi>...

durdn on Feb 17, 2016 | root | parent | next [–]
I'll check how you did it. I wrote my notes and a couple of scripts down in a post: <https://developer.atlassian.com/blog/2016/02/best-way-to-sto>...
durdn on Feb 10, 2016 | root | parent | prev | next [–]
Working on it! I'll give you full credit for it and link to this thread for reference. Also let me know if you have a Twitter account you'd like me to reference.

StreakyCobra on Feb 10, 2016 | root | parent | next [–]
Nice thanks. I don't have twitter. Also don't present me as the inventor of this technique because I'm not. I've read this long time ago on some dark corners of the internet :-) I'm just pointing it out.

durdn on Feb 10, 2016 | root | parent | next [–]
Alright I'll be careful in my wording ;).
wooptoo on Feb 10, 2016 | parent | prev | next [–]
Why is this a bare repo as opposed to a normal one?
StreakyCobra on Feb 10, 2016 | root | parent | next [–]
Because the working tree is already your home folder, you don't need to also have a copy of these files in ".myconf/".
idle_zealot on Feb 11, 2016 | root | parent | next [–]
So why use .myconf/ at all? What is it doing?
telotortium on Feb 11, 2016 | root | parent | next [–]
It contains the files that would normally be in .git (run `git help gitrepository-layout` for more details on the contents).

durdn on Feb 10, 2016 | parent | prev | next [–]
Honestly this is genius! I hadn't thought of doing it like that, thank you! I had resorted to the usual .cfg folder and a helper script to link/update everything.

shabda on Feb 10, 2016 | root | parent | next [–]
Could you explain how this works? Won't this be putting the .bashrc in $HOME/.myconf/.bashrc, which won't get picked up by bash? (And similar for other dotfiles)

unwind on Feb 10, 2016 | root | parent | next [–]
No, since the config alias runs git with the option "--work-tree=$HOME", which tells it that the working directory is your home directory root, i.e. where config files (used to) live.

Anyway it's the proper root for config files, since if you use a .config directory (as seems to be the modern choice) that needs to live in your home directory of course.

nindalf on Feb 10, 2016 | root | parent | prev | next [–]
You could add a symlink in your $HOME folder
qznc on Feb 10, 2016 | parent | prev | next [–]
"branches for different computers" sounds tedious if most changes are for every computer.

StreakyCobra on Feb 10, 2016 | root | parent | next [–]
I have a "master" branch, and some "computer" branches. When changes are required for all computer, I do it in "master", and then update each branch by doing a "git merge master".

kavehmz on Feb 10, 2016 | parent | prev | next [–]
You mean, you are also adding pushing your .ssh dir to a remote repo?
durdn on Feb 10, 2016 | root | parent | next [–]
Not at all. You can 'git add' (or in the case of the technique above 'config add') only the files and folders that are safely stored in a repository. Because of the 'ShowUntrackedFiles' flag, git/config won't always show folders you don't want to track, which would be annoying.

kavehmz on Feb 10, 2016 | root | parent | next [–]
Perfect then,
abricot on Feb 10, 2016 | parent | prev | next [–]
I'm confused - you can add files that are in a parent directory?
StreakyCobra on Feb 10, 2016 | root | parent | next [–]
It's because we specify to git that the working tree is the home folder. For it the versionning doesn't happen in ".myconf", but directly in the home folder
