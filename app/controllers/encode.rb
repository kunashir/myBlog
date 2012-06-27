# sahi
# stroyka.in
# encode.rb
# :< :< :< :< :< :< :< :< :< :< :< :< :< :< :< :< :< :< :< :< :< :< :< :< 
def encode_utf8(string)
  
encode_utf8 = {
0x80 => "\xD0\x82",        0x81 => "\xD0\x83",        0x82 => "\xE2\x80\x9A", 
0x83 => "\xD1\x93",        0x84 => "\xE2\x80\x9E", 0x85 => "\xE2\x80\xA6", 
0x86 => "\xE2\x80\xA0", 0x87 => "\xE2\x80\xA1", 0x88 => "\xE2\x82\xAC", 
0x89 => "\xE2\x80\xB0", 0x8A => "\xD0\x89",         0x8B => "\xE2\x80\xB9", 
0x8C => "\xD0\x8A",         0x8D => "\xD0\x8C",         0x8E => "\xD0\x8B", 
0x8F => "\xD0\x8F",          0x90 => "\xD1\x92",        0x91 => "\xE2\x80\x98", 
0x92 => "\xE2\x80\x99", 0x93 => "\xE2\x80\x9C", 0x94 => "\xE2\x80\x9D", 
0x95 => "\xE2\x80\xA2", 0x96 => "\xE2\x80\x93", 0x97 => "\xE2\x80\x94", 
0x99 => "\xE2\x84\xA2", 0x9A => "\xD1\x99",         0x9B => "\xE2\x80\xBA", 
0x9C => "\xD1\x9A",         0x9D => "\xD1\x9C",        0x9E => "\xD1\x9B", 
0x9F => "\xD1\x9F",          0xA0 => "\xC2\xA0",       0xA1 => "\xD0\x8E", 
0xA2 => "\xD1\x9E",         0xA3 => "\xD0\x88",       0xA4 => "\xC2\xA4", 
0xA5 => "\xD2\x90",         0xA6 => "\xC2\xA6",       0xA7 => "\xC2\xA7", 
0xA8 => "\xD0\x81", 0xA9 => "\xC2\xA9", 0xAA => "\xD0\x84", 
0xAB => "\xC2\xAB", 0xAC => "\xC2\xAC", 0xAD => "\xC2\xAD", 
0xAE => "\xC2\xAE", 0xAF => "\xD0\x87", 0xB0 => "\xC2\xB0", 
0xB1 => "\xC2\xB1", 0xB2 => "\xD0\x86", 0xB3 => "\xD1\x96", 
0xB4 => "\xD2\x91", 0xB5 => "\xC2\xB5", 0xB6 => "\xC2\xB6", 
0xB7 => "\xC2\xB7", 0xB8 => "\xD1\x91", 0xB9 => "\xE2\x84\x96", 
0xBA => "\xD1\x94", 0xBB => "\xC2\xBB", 0xBC => "\xD1\x98", 
0xBD => "\xD0\x85", 0xBE => "\xD1\x95", 0xBF => "\xD1\x97", 
0xC0 => "\xD0\x90", 0xC1 => "\xD0\x91", 0xC2 => "\xD0\x92", 
0xC3 => "\xD0\x93", 0xC4 => "\xD0\x94", 0xC5 => "\xD0\x95", 
0xC6 => "\xD0\x96", 0xC7 => "\xD0\x97", 0xC8 => "\xD0\x98", 
0xC9 => "\xD0\x99", 0xCA => "\xD0\x9A", 0xCB => "\xD0\x9B", 
0xCC => "\xD0\x9C", 0xCD => "\xD0\x9D", 0xCE => "\xD0\x9E", 
0xCF => "\xD0\x9F", 0xD0 => "\xD0\xA0", 0xD1 => "\xD0\xA1", 
0xD2 => "\xD0\xA2", 0xD3 => "\xD0\xA3", 0xD4 => "\xD0\xA4", 
0xD5 => "\xD0\xA5", 0xD6 => "\xD0\xA6", 0xD7 => "\xD0\xA7", 
0xD8 => "\xD0\xA8", 0xD9 => "\xD0\xA9", 0xDA => "\xD0\xAA", 
0xDB => "\xD0\xAB", 0xDC => "\xD0\xAC", 0xDD => "\xD0\xAD", 
0xDE => "\xD0\xAE", 0xDF => "\xD0\xAF", 0xE0 => "\xD0\xB0", 
0xE1 => "\xD0\xB1", 0xE2 => "\xD0\xB2", 0xE3 => "\xD0\xB3", 
0xE4 => "\xD0\xB4", 0xE5 => "\xD0\xB5", 0xE6 => "\xD0\xB6", 
0xE7 => "\xD0\xB7", 0xE8 => "\xD0\xB8", 0xE9 => "\xD0\xB9", 
0xEA => "\xD0\xBA", 0xEB => "\xD0\xBB", 0xEC => "\xD0\xBC", 
0xED => "\xD0\xBD", 0xEE => "\xD0\xBE", 0xEF => "\xD0\xBF", 
0xF0 => "\xD1\x80", 0xF1 => "\xD1\x81", 0xF2 => "\xD1\x82", 
0xF3 => "\xD1\x83", 0xF4 => "\xD1\x84", 0xF5 => "\xD1\x85", 
0xF6 => "\xD1\x86", 0xF7 => "\xD1\x87", 0xF8 => "\xD1\x88", 
0xF9 => "\xD1\x89", 0xFA => "\xD1\x8A", 0xFB => "\xD1\x8B", 
0xFC => "\xD1\x8C",0xFD => "\xD1\x8D", 0xFE => "\xD1\x8E",
0xFF => "\xD1\x8F"
} 
  begin
   string = string.unpack("U*").pack("U*")
	rescue Exception => e
  nents = []
  string.each_byte{|stg| 
  if(encode_utf8[stg])
   nents.push encode_utf8[stg]
   else
   nents.push stg.chr
   end
   } 
   string = nents.to_s
 end
  return string
end
# :< :< :< :< :< :< :< :< :< :< :< :< :< :< :< :< :< :< :< :< :< :< :< :< 
#
#