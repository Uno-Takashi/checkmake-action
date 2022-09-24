from unittest import expectedFailure
from CheckmakeBuilder import CheckmakeBuilder
import argparse
import sys

parser = argparse.ArgumentParser(description="Validate the argument of lizard")
parser.add_argument("makefile", type=str)
parser.add_argument("debug", type=str)
parser.add_argument("config", type=str)
parser.add_argument("cli_output_file", type=str)

args = parser.parse_args()

cmb = CheckmakeBuilder(args.makefile, args.debug, args.config)

result = cmb.run()

print(result.stdout)
print(result.stderr)

if args.cli_output_file != "":
    with open(args.cli_output_file, mode="w") as f:
        f.write(result.stdout)

sys.exit(result.returncode)
