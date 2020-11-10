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
  iv = generateIV()
  encryptedContent = rawContent.encrypt(key, iv)

assert rawContent == encryptedContent.decrypt(key, iv)

encryptedContent.writeCryptFile(iv, loc)

assert rawContent == loc.decrypt(key)
loc.removeFile