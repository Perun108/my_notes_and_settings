# **Linters/formatters (pylint, black, isort, flake8, etc.)**
- [General notes regarding formatters (!)](#general-notes-regarding-formatters)
- [Pylint](#pylint)
  - [Checking your code in terminal](#checking-your-code-in-terminal)
    - [My additions to disabled warnings](#my-additions-to-disabled-warnings)
  - [Ignore a line or block of code in Pylint](#ignore-a-line-or-block-of-code-in-pylint)
- [Black](#black)
  - [Skip/disable black for parts of code](#skipdisable-black-for-parts-of-code)
  - [Black's compatibility with other formatting tools (isort, etc.)](#blacks-compatibility-with-other-formatting-tools-isort-etc)
  - [Black settings](#black-settings)
- [isort](#isort)
  - [isort settings](#isort-settings)
- [Flake8](#flake8)
  - [flake8 settings](#flake8-settings)
  - [Ignore entire files in flake8](#ignore-entire-files-in-flake8)

## **General notes regarding formatters (!)**

- You can have settings for these tools per-project (`pyproject.toml` for all of them or individual `.cfg` files for each tool) or per-IDE (`VSCode settings`). Don't forget to set the same settings in `pre-commit` if you use one.
- Make settings for all formatters consistent everywhere (like `line-length`, in all places - `pyproject.toml`, `.cfg` files, `VSCode settings`, etc)!
- Be aware of the incompatibility between black and other formatters on many settings (see below). Black seems to be very oppressive of other tool's settings.


## **Pylint**

### **Checking your code in terminal**

VSCode has a built-in `pylint` support configurable in settings. However, if you want to check your code in your terminal (not just the file that you are working currently), first generate the `pylintrc` file:

`pylint --generate-rcfile`

then add all the needed settings (mainly to ignore specific warnings, etc.)

#### **My additions to disabled warnings**
I usually add the following to the disable section in [MESSAGES CONTROL]:
R0201, C0115, C0114, C0301, C0116, W0707, R0913 (I prefer to use actual titles for these command code - they are descriptive!)

In addition to the default settings in the `disable` section (`disable=raw-checker-failed,bad-inline-option...`) I also add these:

```
too-many-arguments, # Sometimes I comment this out to actually check against it
too-few-public-methods,
abstract-method, # I get too many of these warnings in Serializers.
invalid-name, # Strangely it warns about DRF's 'pk' arguments.
```

and then run this command:

```bash
pylint <your_project> --load-plugins=pylint_django,perflint --django-settings-module=path.to.your.settings > pylint_report
```

**NOTE:** `path.to.your.settings` should be just like in `import` statements - with dots and without `.py` at the end and without `/`!

### **Ignore a line or block of code in Pylint**  
To ignore a single line or a block of code - put `# pylint: disable=line-too-long,etc...`

## **Black**

### **Skip/disable black for parts of code**

```python
# fmt: off
you code
# fmt: on
```

or you can use inline comment `# fmt: skip` for a disabling a single line.

### **Black's compatibility with other formatting tools (isort, etc.)**

Black is not always compatible with other tools (see https://github.com/psf/black/blob/main/docs/guides/using_black_with_other_tools.md). For example, it is not compatible with isort multli-line-output options (supports only the 3rd option) - if you have pre-commit hooks for black and isort and isort comes after black and has a different option for multi-line-output, it will always reformat what black formatted and then if you have Format On Save set to True, black will again reformat that file back, back and forth. 

### **Black settings**

Black basically has a single setting `--line-length=99` (I set it to 99).

In `VSCode settings`:
```json
"black-formatter.args": [
        "--line-length=99",
    ],
```

In `pyproject.toml`:
```toml
[tool.black]
line_length=99
```

In `pre-commit`:
```yaml
  - repo: https://github.com/psf/black
    rev: 22.12.0
    hooks:
      - id: black
        args: ["--line-length=99"]
```

## **isort**

isort supports many types of multi-line-output (https://pycqa.github.io/isort/docs/configuration/multi_line_output_modes.html), but black only supports one of them (3) - see above. 

### **isort settings**

In `pyproject.toml`:
```toml
[tool.isort]
profile = "black"
line_length = 99
include_trailing_comma = "true"
multi_line_output = 3
force_grid_wrap=0
use_parentheses="true"
```

In `VSCode settings`:
```json
"isort.args": [
        "--profile",
        "black",
        "--line-length=99",
        "--trailing-comma",
        "--multi-line=3",
        "--force-grid-wrap=0",
        "--use-parentheses=True"
    ],
```

In `pre-commit`:
```yaml
- repo: https://github.com/timothycrosley/isort
    rev: v5.11.3
    hooks:
      - id: isort
        args: ["--profile", "black", "--line-length=99", "--trailing-comma", "--multi-line=3"]
```

## **Flake8**

### **flake8 settings**

flake8 does not support (yet) `pyproject.toml` settings. I usually add settings to `.flake8` file:
```
[flake8]
max-line-length = 99
exclude = .tox,.git,*/migrations/*,*/static/CACHE/*,docs,node_modules,venv
ignore = I001, I005, W503, E203
```

In `pre-commit`:
```yaml
- repo: https://github.com/pycqa/flake8
    rev: 6.0.0
    hooks:
      - id: flake8
        args: ["--config=src/.flake8"]
        additional_dependencies: [flake8-isort]
```

Useful plugin for django - <https://github.com/rocioar/flake8-django>:

`pip install flake8-django`

then just execute `flake8` as usual.

### **Ignore entire files in flake8**

Imagine a situation where we are adding Flake8 to a codebase. Let’s further imagine that with the exception of a few particularly bad files, we can add Flake8 easily and move on with our lives. There are two ways to ignore the file:

- By explicitly adding it to our list of excluded paths (see: `flake8 --exclude`)
- By adding `# flake8: noqa` to the file

The former is the recommended way of ignoring entire files. By using our exclude list, we can include it in our configuration file and have one central place to find what files aren’t included in Flake8 checks. The latter has the benefit that when we run Flake8 with `flake8 --disable-noqa` all of the errors in that file will show up without having to modify our configuration. Both exist so we can choose which is better for us.
