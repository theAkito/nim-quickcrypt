[![nimble](https://raw.githubusercontent.com/yglukhov/nimble-tag/master/nimble.png)](https://nimble.directory/pkg/quickcrypt)

[![Language](https://img.shields.io/badge/language-Nim-orange.svg?style=plastic)](https://nim-lang.org/)

[![GitHub](https://img.shields.io/badge/license-GPL--3.0-informational?style=plastic)](https://www.gnu.org/licenses/gpl-3.0.txt)
[![Liberapay patrons](https://img.shields.io/liberapay/patrons/Akito?style=plastic)](https://liberapay.com/Akito/)

## What
This is a [Nim](https://nim-lang.org/) library for quickly and easily encrypting strings and Files.

## Why
Use this library, if you want to quickly, easily and comfortably encrypt objects of interest. You don't have to deal with [Initialization Vectors](https://en.wikipedia.org/wiki/Initialization_vector), [block padding](https://security.stackexchange.com/questions/52111/how-to-encrypt-more-than-16-bytes-using-aes) or anything else stealing your focus from the actual business logic in your application. This library gives you the benefits of advanced encryption, without needing you to fiddle around with the disadvantages.
That said, if you want absolute security, you should use an alternative, that lets you do the dirty work, but in turn makes the result more secure. However, this library covers probably 80% of use-cases out there: you need something secured from normal hackers, your colleagues at work or your security interested friend, but you don't expect real experts to be interested in your secrets.

## How
### Install
```
nimble install quickcrypt
```
### Develop
After cloning the repository for the first time:
```
nimble intro
```
When starting to develop after a break:
```
nimble configure
```
### Test
```
nimble test
```

### Use
```nim
import
  quickcrypt,
  os

const
  secretConfig = """{ "minchi": "punchi" }"""

let
  # Use your own key for increased security or
  # quickly generate a not so secure key for convenience.
  # The key length *must* equal 32 characters.
  key = generateKey()
  # Encrypt string.
  encryptedConfig = secretConfig.encrypt(key)
  # Decrypt string.
  decryptedConfig = encryptedConfig.decrypt(key)
  # Set path to config text file.
  configTextFile = getCurrentDir() / "conf.txt"
  # Set path to config binary file.
  configBinFile = getCurrentDir() / "conf.bin"

# Echo the content of the now decrypted config file.
echo decryptedConfig

# Encrypt string and write to text File.
writeCryptFile(configTextFile, secretConfig, key)

# Encrypt file.
encryptFile(configBinFile, key)

# Echo the encrypted file.
# All encrypted content is base64 encoded, so no weird characters
# or otherwise ugly and inconvenient representations.
echo configBinFile.readFile()

# Decrypt file and replace the encrypted file.
configBinFile.writeFile(decryptFile(configBinFile, key))
```

## Where
* Linux
* Windows

## Goals
* Ease of Use
* Quick Implementation
* Comfortability
* General Compatability

## Project Status
Stable

## TODO
* ~~Improve usage examples~~
* Add native Documentation

## License
Copyright (C) 2020  Akito <the@akito.ooo>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.