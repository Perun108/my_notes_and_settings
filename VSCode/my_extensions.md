# A list of my VS Code extensions

### Create a list of your extensions + Sync extensions between installations

VS Code CLI has a built-in command to list all installed extensions:

`code --list-extensions`

You can use the following command to create a file with a list of your extensions along with installation commands that you then can paste into your terminal to do a batch install of all needed extensions:

`code --list-extensions | xargs -L 1 echo code --install-extension >> vscode_extensions`

### Used  
aaron-bond.better-comments  
alefragnani.Bookmarks  
artdiniz.quitcontrol-vscode  
bungcip.better-toml  
canadaduane.notes  
eamodio.gitlens  
formulahendry.code-runner  
Gruntfuggly.todo-tree  
mechatroner.rainbow-csv  
moshfeu.diff-merge  
ms-python.black-formatter  
ms-python.isort  
ms-python.pylint  
ms-python.python  
ms-python.vscode-pylance  
ms-vscode.sublime-keybindings  
mtxr.sqltools  
mtxr.sqltools-driver-pg  
njpwerner.autodocstring  
njqdev.vscode-python-typehint  
patbenatar.advanced-new-file  
patricklee.vsnotes  
phplasma.csv-to-table  
rafamel.subtle-brackets  
softwaredotcom.swdc-vscode  
streetsidesoftware.code-spell-checker  
stripe.vscode-stripe  
vscode-icons-team.vscode-icons  
wayou.vscode-todo-highlight  

### Enabled but not used much (if at all)  
Alexey-Strakh.stackoverflow-search  
almenon.arepl  
bigonesystems.django  
donjayamanne.githistory  
fabiospampinato.vscode-terminals  
GitHub.vscode-pull-request-github  
hbenl.vscode-test-explorer  
hediet.debug-visualizer  
hlrossato.vscode-drf  
joffreykern.markdown-toc  
littlefoxteam.vscode-python-test-adapter  
ms-azuretools.vscode-docker  
ms-dotnettools.vscode-dotnet-runtime // Needed by others  
ms-vscode.test-adapter-converter // Not sure about this one  
rangav.vscode-thunder-client  
RapidAPI.vscode-rapidapi-client  
ritwickdey.LiveServer  
shd101wyy.markdown-preview-enhanced  
sleistner.vscode-fileutils  
traBpUkciP.wolf  
uloco.theme-bluloco-light  
usernamehw.errorlens // Not sure. Should learn how to use it!  
vintharas.learn-vim  
VisualStudioExptTeam.intellicode-api-usage-examples  
VisualStudioExptTeam.vscodeintellicode  

### Disabled  
alexcvzz.vscode-sqlite  
atlassian.atlascode  
batisteo.vscode-django  
bmuskalla.vscode-tldr  
jsaulou.theme-by-language  
ms-toolsai.jupyter  
ms-toolsai.jupyter-keymap  
ms-toolsai.jupyter-renderers  
ms-toolsai.vscode-jupyter-cell-tags  
ms-toolsai.vscode-jupyter-slideshow  
ms-vscode-remote.remote-containers  
pnp.polacode  
redhat.vscode-yaml  
samuelcolvin.jinjahtml  
shamanu4.django-intellisense  
vscodevim.vim  
yzhang.markdown-all-in-one  
