from CheckmakeBuilder import CheckmakeBuilder
import argparse
import subprocess
import sys
import os
from pathlib import Path


def surround_double_quotes(x: str):
    return '"' + str(x) + '"'


parser = argparse.ArgumentParser(description="Validate the argument of lizard")
parser.add_argument("makefile", type=str)
parser.add_argument("debug", type=str)
parser.add_argument("config", type=str)

args = parser.parse_args()

CheckmakeBuilder(args.makefile, args.debug, args.config)

commands = ["checkmake"]


result = subprocess.run(
    "checkmake -h",
    shell=True,
    stdout=subprocess.PIPE,
    stderr=subprocess.PIPE,
    text=True,
)
print(result.stdout)
print(result.stderr)
