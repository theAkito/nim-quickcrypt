import
  quickcrypt,
  os

const
  rawContent = """The quick brown fox jumps over the lazy dog.
THE QUICK BROWN FOX JUMPS OVER THE LAZY DOG.
123456890-_=+(){}[]:;'"<>,./\?!@#$%^&*"""

let
  key = generateKey()
  loc_file_text = getCurrentDir() / "tests" / "testencryptedfile.txt"
  loc_file_bin  = getCurrentDir() / "tests" / "testencryptedfile.bin"
  encryptedContent = rawContent.encrypt(key)

try:
  assert rawContent == encryptedContent.decrypt(key)
  loc_file_text.writeCryptFile(rawContent, key)
  assert rawContent == loc_file_text.decryptFile(key)
  let orig_loc_file_text = loc_file_text.readFile()
  loc_file_text.encryptFile(key)
  assert orig_loc_file_text == loc_file_text.decryptFile(key)
  let orig_loc_file_bin = loc_file_bin.readFile()
  encryptFile(loc_file_bin, key)
  assert orig_loc_file_bin == loc_file_bin.decryptFile(key)
  loc_file_bin.writeFile(orig_loc_file_bin)
except:
  raise getCurrentException()
finally:
  loc_file_text.removeFile
  ("tests" / "test").removeFile