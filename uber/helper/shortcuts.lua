require("bit")
bnot = bit.bnot
band, bor, bxor = bit.band, bit.bor, bit.bxor
lshift, rshift, rol = bit.lshift, bit.rshift, bit.rol

BIT = function(b)
	return lshift(1,b)
end