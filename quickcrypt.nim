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
  StringStream
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

proc generateIV*(ivAlphabet: string = ivAlphabet, ivLen: int = ivLen): string =
  ivAlphabet.generate(ivLen)

proc encrypt*(raw_string, key, iv: string): string =
  doAssert key.len == 32
  var
    aes = initAES()
    iv_t = iv
    adjusted_raw_string: string
  if aes.setEncodeKey(key):
    let
      padding = (ivLen - (raw_string.len mod ivLen)) - 1
    adjusted_raw_string = padding.toHex()[^1] & raw_string & spaces(padding)
    result = aes.encryptCBC(iv_t.cstring, adjusted_raw_string)
  else:
    result = ""

proc decrypt*(raw_string, key, iv: string): string =
  var
    aes = initAES()
    iv_t = iv
    tailLen = 0
  if aes.setDecodeKey(key):
    let
      result_raw = aes.decryptCBC(iv_t.cstring, raw_string)
    tailLen = result_raw[0..0].parseHexInt()
    result = result_raw[1..^1]
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

proc decrypt*(
  loc_file : string,
  key_file : string,
  ivLen    : int     = ivLen
): string =
  var
    strm_enc_conf: StringStream
    strm_enc_conf_file: FileStream
    tmp: string
    iv: string
    enc_conf: string
  strm_enc_conf_file = openFileStream(loc_file)
  tmp = strm_enc_conf_file.readAll().decode()
  strm_enc_conf_file.close()
  strm_enc_conf = tmp.newStringStream()
  for c in 1..ivLen:
    iv = iv & strm_enc_conf.readChar()
  enc_conf = strm_enc_conf.readAll()
  strm_enc_conf.close()
  result = enc_conf.decrypt(key_file, iv)

proc writeCryptFile*(
  conf         : string,
  iv           : string,
  loc_file     : string
): bool {.discardable.} =
  writeFile(loc_file, encode(iv & conf, true))