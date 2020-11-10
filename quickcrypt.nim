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
  repeat

const
  ivLen* = 16
  ivAlphabet* = "ABCDEF1234567890"

proc generateIV*(ivAlphabet: string = ivAlphabet, ivLen: int = ivLen): string =
  ivAlphabet.generate(ivLen)

proc encrypt*(raw_string, key, iv: string): string =
  var
    aes = initAES()
    conf: string
  if aes.setEncodeKey(key):
    conf = raw_string & repeat(' ', ivLen - (raw_string.len mod ivLen))
    result = aes.encryptCBC(iv.cstring, conf)
  else:
    result = ""

proc decrypt*(conf, key, iv: string): string =
  var
    aes = initAES()
  if aes.setDecodeKey(key):
    result = aes.decryptCBC(iv.cstring, conf)
  else:
    result = ""

proc readIV*(
  loc_file : string,
  ivLen    : int     = ivLen
): string =
  var
    strm_enc_conf: FileStream
  strm_enc_conf = openFileStream(loc_file)
  result        = strm_enc_conf.readStr(ivLen)
  strm_enc_conf.close()

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