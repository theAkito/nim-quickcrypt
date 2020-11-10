from nimAES import
  initAES,
  setEncodeKey,
  setDecodeKey,
  encryptCBC,
  decryptCBC
from base64 import
  encode,
  decode
from neoid import
  generate
from streams import
  openFileStream,
  newStringStream,
  readStr,
  readChar,
  readAll,
  close,
  FileStream,
  StringStream,
  peekStr
from strutils import
  spaces,
  toHex,
  removePrefix,
  removeSuffix,
  parseInt,
  parseHexInt

const
  ivLen* = 16
  ivAlphabet* = "ABCDEF1234567890"

proc ensureKeyLen(key: string) =
  doAssert key.len == 32

proc generateIV*(ivAlphabet: string = ivAlphabet, ivLen: int = ivLen): string =
  ivAlphabet.generate(ivLen)

proc encrypt*(raw_string, key: string): string =
  ensureKeyLen(key)
  var
    aes = initAES()
    adjusted_raw_string: string
  if aes.setEncodeKey(key):
    let
      iv = generateIV()
      padding = (ivLen - (raw_string.len mod ivLen)) - 1
    var
      iv_t = iv
    adjusted_raw_string = padding.toHex()[^1] & raw_string & spaces(padding)
    result = (iv & aes.encryptCBC(iv_t.cstring, adjusted_raw_string)).encode(true)
  else:
    result = ""

proc decrypt*(raw_string, key: string): string =
  var
    aes = initAES()
    tailLen = 0
  if aes.setDecodeKey(key):
    let
      decoded_string = raw_string.decode()
      f_strm = decoded_string.newStringStream()
      iv = f_strm.readStr(16)
    var
      iv_t = iv
    let
      result_strm = aes.decryptCBC(iv_t.cstring, f_strm.readAll()).newStringStream()
    tailLen = result_strm.readStr(1).parseHexInt()
    result = result_strm.readAll()
    f_strm.close()
    result_strm.close()
    result.removeSuffix(spaces(tailLen))
  else:
    result = ""

proc readIV*(
  loc_file : string,
  ivLen    : int     = ivLen
): string =
  var
    stream: FileStream
  stream = openFileStream(loc_file)
  result = stream.readStr(ivLen)
  stream.close()

proc decryptFile*(
  loc_file : string,
  key : string,
  ivLen    : int     = ivLen
): string =
  ensureKeyLen(key)
  result = loc_file.readFile().decrypt(key)

proc writeCryptFile*(
  loc_file     : string,
  content      : string,
  key          : string
): bool {.discardable.} =
  let
    enc_content = content.encrypt(key)
  writeFile(loc_file, enc_content)

proc encryptFile*(
  loc_file     : string,
  key          : string
): bool {.discardable.} =
  let
    enc_content = loc_file.readFile().encrypt(key)
  writeFile(loc_file, enc_content)