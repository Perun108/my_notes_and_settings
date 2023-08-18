# Pre-commit hooks

https://pre-commit.com/  
https://github.com/pre-commit/pre-commit-hooks  

1. Install pre-commit: 

`pip install pre-commit` or `poetry add pre-commit`

2. Create a file named `.pre-commit-config.yaml`

3. Add all the hook types you want

**NOTE:** Make sure that your `black`/`isort`/`flake8` settings are consistent across your `pre-commit` hooks and IDE (e.g. `line-length` in `black`, `flake8` in `pre-commit` hooks and your IDE should be the same – otherwise it will create an endless loop of fixing files!).

4. Run `pre-commit install` to set up the git hook scripts (now pre-commit will run automatically on git commit!)

5. (Optional) Run against all files: `pre-commit run –all-files`