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
  readAll,
  close,
  FileStream,
  StringStream
from strutils import
  spaces,
  toHex,
  removeSuffix,
  parseHexInt

const
  ivLen*  = 16
  keyLen* = 32

proc ensureKeyLen(key: string) =
  doAssert key.len == keyLen

proc generateKey*(keyLen: int = keyLen): string {.gcsafe.} =
  generate(size = keyLen)

proc generateIV*(ivLen: int = ivLen): string {.gcsafe.} =
  generate(size = ivLen)

proc encrypt*(raw_string, key: string): string {.gcsafe.} =
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

proc decrypt*(raw_string, key: string): string {.gcsafe.} =
  var
    aes = initAES()
    tailLen = 0
  if aes.setDecodeKey(key):
    let
      decoded_string = raw_string.decode()
      strm_decoded_string = decoded_string.newStringStream()
      iv = strm_decoded_string.readStr(16)
      result_strm = aes.decryptCBC(iv.cstring, strm_decoded_string.readAll()).newStringStream()
    tailLen = result_strm.readStr(1).parseHexInt()
    result = result_strm.readAll()
    strm_decoded_string.close()
    result_strm.close()
    result.removeSuffix(spaces(tailLen))
  else:
    result = ""

proc readIV*(
  loc_file : string,
  ivLen    : int     = ivLen
): string {.gcsafe.} =
  var
    stream: FileStream
  stream = openFileStream(loc_file)
  result = stream.readStr(ivLen)
  stream.close()

proc decryptFile*(
  loc_file : string,
  key      : string,
  ivLen    : int     = ivLen
): string {.gcsafe.} =
  ensureKeyLen(key)
  result = loc_file.readFile().decrypt(key)

proc writeCryptFile*(
  loc_file     : string,
  content      : string,
  key          : string
): bool {.discardable, gcsafe.} =
  ensureKeyLen(key)
  let
    enc_content = content.encrypt(key)
  writeFile(loc_file, enc_content)

proc encryptFile*(
  loc_file     : string,
  key          : string
): bool {.discardable, gcsafe.} =
  ensureKeyLen(key)
  let
    enc_content = loc_file.readFile().encrypt(key)
  writeFile(loc_file, enc_content)