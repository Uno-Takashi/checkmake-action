import os
import subprocess
from pathlib import Path


class CheckmakeBuilder(object):
    BASE_COMMAND = "checkmake"

    def __init__(
        self,
        makefile: str,
        debug: str,
        config: str,
    ) -> None:
        self.org_makefile: str = makefile
        self.org_debug: str = debug
        self.org_config: str = config

    def _validate(self) -> None:
        is_makefile = os.path.isfile(self.org_makefile)
        if not is_makefile:
            raise FileNotFoundError
        else:
            print("\033[32m" + "Check existence of Makefile" + "\033[0m")
        if self.org_debug.lower() == "false" or self.org_debug.lower() == "true":
            print("\033[32m" + "Check Debug Flag" + "\033[0m")
        else:
            raise ValueError
        is_config = os.path.isfile(self.org_config)
        if not is_config and self.org_config != "":
            raise FileNotFoundError
        else:
            print("\033[32m" + "Check existence of Config" + "\033[0m")

    def _prepare(self):
        self.makefile: Path = Path(self.org_makefile)
        self.debug: bool = self.org_debug.lower() == "true"
        if self.org_config != "":
            self.config: Path = Path(self.org_config)
        else:
            self.config = None

    def _surround_double_quotes(self, x: Path):
        return '"' + str(x) + '"'

    def _generate(self) -> str:
        command = [self.BASE_COMMAND]
        if self.debug:
            command.append("--debug")
        if self.config:
            command.append("--config=" + self._surround_double_quotes(self.config))
        command.append(self._surround_double_quotes(self.makefile))
        return " ".join(command)

    def run(self) -> str:
        print("::group::Validate")
        self._validate()
        print("::endgroup::")
        self._prepare()
        command = self._generate()
        print(command)
        result = subprocess.run(
            command,
            shell=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
        )
        return result
