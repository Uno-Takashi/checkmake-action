# checkmake-action

[![Test](https://github.com/Uno-Takashi/checkmake-action/actions/workflows/test-my-self.yml/badge.svg?branch=main)](https://github.com/Uno-Takashi/checkmake-action/actions/workflows/test-my-self.yml)
[![Code Quality](https://github.com/Uno-Takashi/checkmake-action/actions/workflows/code-quality.yml/badge.svg?branch=main)](https://github.com/Uno-Takashi/checkmake-action/actions/workflows/code-quality.yml)

checkmake-action is a third-party OSS Github Action for easy execution of [checkmake](https://github.com/mrtazz/checkmake).This action uses [cytopia/docker-checkmake](https://github.com/cytopia/docker-checkmake).

- **Rapid Container**
  - The checkmake-action employs a lightweight container based on [Alpile](https://hub.docker.com/r/cytopia/checkmake). In most cases, preparation to begin analysis takes less than 30 seconds in github-hosted runner.
- **Easy-to-use variable specification**
  - Wrapping command line arguments allows for more intuitive execution.
- **Can be embedded in CI**
  - You can Keep beautiful your Makefile every time.

## 🗞️ Introduction

linter can make codes beautiful.However, there are relatively few instances of running linter against Makefile.We believe the cause of this problem is probably the complexity of preparing to run the linter for Makefile.

For this reason, we have created a Github action that makes it easy to run checkmake!

## 📚 Usage

The following code is the minimum code to make checkmake-action work. In the following cases, checkmake is run with default settings.

```yaml
name: checkmake action
on:
  push:

jobs:
  checkmake:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: checkmake action
        uses: Uno-Takashi/checkmake-action@main
```

chackemake execution options can be passed as arguments. For example, to specify a file to be analyzed or to activate debug mode, do the following

```yaml
      - name: checkmake action
        uses: Uno-Takashi/checkmake-action@main
        with:
          makefile: "path/to/Makefile"
          config: "path/to/config"
          debug: true
```

See "Inputs" for a detailed description of all the arguments that can be set.

## 📥 Inputs

Most of the input is the same as in the chackmake, but some original input is required for chackemake-action.

All arguments are optional.

| Name            | Default                      | Description                                                                                                                                   |
|-----------------|------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------|
| `makefile`        | "./Makefile"                 | The path given to the command. The checkmake is executed against this path.                                                                   |
| `config`          | ""                           | Configuration file to read                                                                                                                    |
| `debug`           | false                        | If "true", the flag argument is specified in the checkmake execution.                                                                         |
| `cli_output_file` | "./checkmake_cli_output.txt" | Specify the name of the file in which to save the cli output results. If spaces are present, the file is treated as a file containing spaces. |

## 📤 Outputs

The paths to a file are output. The following outputs can be accessed via ${{ steps.{step_id}.outputs.{output_name} }} from this action

| Name            | Description                                                                      |
|-----------------|----------------------------------------------------------------------------------|
| `cli_output_file` | The path to the file where the output result of cli is saved when checkmake is run. |

### See outputs

If the outputs is referenced in a later Action, it will look like this

```yaml
      - uses: Uno-Takashi/checkmake-action@main
        id: checkmake
        with: 
          cli_output_file: "path/to/text.txt"
      - name: test:case2-path
        run: echo -e ${{ steps.checkmake.outputs.cli_output_file }}
```

```shell:output
>>> path/to/text.txt
```

## 🛒 How to Get

[checkmake action · Actions · GitHub Marketplace](https://github.com/marketplace/actions/checkmake-action)

## ⌨ Develop

You can test it using GitHub-Hosted Runner. However, if you prefer to run your tests in a local environment, you can do so using [act](https://github.com/nektos/act).

```shell
act -W ./.github/workflows/test-my-self.yml --rebuild
```
