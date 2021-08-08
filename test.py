import io
import re
import random
import string


def is_binary_patched(executable_path=None):
        """simple check if executable is patched.

        :return: False if not patched, else True
        """
        with io.open('chromedriver', "rb") as fh:
            for line in iter(lambda: fh.readline(), b""):
                if b"cdc_" in line:
                    return False
            else:
                return True

def gen_random_cdc():
        cdc = random.choices(string.ascii_lowercase, k=26)
        cdc[-6:-4] = map(str.upper, cdc[-6:-4])
        cdc[2] = cdc[0]
        cdc[3] = "_"
        return "".join(cdc).encode()                

def patch_exe():
        """
        Patches the ChromeDriver binary

        :return: False on failure, binary name on success
        """
        linect = 0
        replacement = gen_random_cdc()
        with io.open('chromedriver', "r+b") as fh:
            for line in iter(lambda: fh.readline(), b""):
                print(type(line))
                if b"cdc_" in line:
                    print(line)
                    fh.seek(-len(line), 1)
                    newline = re.sub(b"cdc_.{22}", replacement, line)
                    # fh.write(newline)
                    linect += 1
            return linect

print(is_binary_patched('chromedriver'))
patch_exe()
# print(is_binary_patched('chromedriver'))
