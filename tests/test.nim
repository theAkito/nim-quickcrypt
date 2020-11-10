import
  quickcrypt,
  os

const
  rawContent = """The quick brown fox jumps over the lazy dog.
THE QUICK BROWN FOX JUMPS OVER THE LAZY DOG.
123456890-_=+(){}[]:;'"<>,./\?!@#$%^&*"""

let
  key = generateKey()
  loc = getCurrentDir() / "testencryptedfile.txt"
  encryptedContent = rawContent.encrypt(key)

try:
  assert rawContent == encryptedContent.decrypt(key)
  loc.writeCryptFile(rawContent, key)
  assert rawContent == loc.decryptFile(key)
  let orig_content = loc.readFile()
  loc.encryptFile(key)
  assert orig_content == loc.decryptFile(key)
except:
  raise getCurrentException()
finally:
  loc.removeFile
  ("tests" / "test").removeFile