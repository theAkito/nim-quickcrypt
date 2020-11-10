import
  quickcrypt

const
  key = r"-_=+(){}[]123456-_=+(){}[]123456"
  rawContent = """The quick brown fox jumps over the lazy dog.
THE QUICK BROWN FOX JUMPS OVER THE LAZY DOG.
123456890-_=+(){}[]:;'"<>,./\?!@#$%^&*"""

let
  iv = generateIV()
  encryptedContent = rawContent.encrypt(key, iv)

assert rawContent == encryptedContent.decrypt(key, iv)