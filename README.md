# checkmake-action

[![Code Quality](https://github.com/Uno-Takashi/checkmake-action/actions/workflows/code-quality.yml/badge.svg?branch=main)](https://github.com/Uno-Takashi/checkmake-action/actions/workflows/code-quality.yml)

checkmake-action is a third-party OSS Github Action for easy execution of [checkmake](https://github.com/mrtazz/checkmake).

- **Rapid Container**
  - The checkmake-action employs a lightweight container based on alpine. In most cases, preparation to begin analysis takes less than 30 seconds in github-hosted runner.
- **Easy-to-use variable specification**
  - Wrapping command line arguments allows for more intuitive execution.
- **Can be embedded in CI**
  - You can Keep beautiful your Makefile everytime.
