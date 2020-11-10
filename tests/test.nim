import
  quickcrypt,
  os

const
  key = r"-_=+(){}[]123456-_=+(){}[]123456"
  rawContent = """The quick brown fox jumps over the lazy dog.
THE QUICK BROWN FOX JUMPS OVER THE LAZY DOG.
123456890-_=+(){}[]:;'"<>,./\?!@#$%^&*"""

let
  loc = getCurrentDir() / "testencryptedfile.txt"
  encryptedContent = rawContent.encrypt(key)

try:
  assert rawContent == encryptedContent.decrypt(key)
  loc.writeCryptFile(encryptedContent, key)
  assert rawContent == loc.decryptFile(key)
except:
  raise getCurrentException()
finally:
  loc.removeFile
  ("src" / "test").removeFile