from CheckmakeBuilder import CheckmakeBuilder
import argparse
import sys

parser = argparse.ArgumentParser(description="Validate the argument of lizard")
parser.add_argument("makefile", type=str)
parser.add_argument("debug", type=str)
parser.add_argument("config", type=str)

args = parser.parse_args()

cmb = CheckmakeBuilder(args.makefile, args.debug, args.config)

result = cmb.run()

print(result.stdout)
print(result.stderr)

sys.exit(result.returncode)
