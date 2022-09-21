import argparse
import subprocess
import sys
import os

ls_file_name = os.listdir()

print(ls_file_name)

result = subprocess.run(
    "checkmake -h",
    shell=True,
    stdout=subprocess.PIPE,
    stderr=subprocess.PIPE,
    text=True,
)
print(result.stdout)
print(result.stderr)
