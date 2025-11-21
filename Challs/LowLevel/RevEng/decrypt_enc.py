with open("enc", "r") as f:
    data = f.read()

print(data)

encoded = data
decoded_chars = []

for ch in encoded:
    v = ord(ch)

    high = v >> 8
    low = v & 0xff

    decoded_chars.append(chr(high))
    decoded_chars.append(chr(low))

    decoded = "".join(decoded_chars)
    print(decoded)
