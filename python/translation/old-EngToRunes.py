#!/usr/bin/python
#coding=utf-8

import sys
import codecs
import copy

def importText(infile):
	
	text = []
	with codecs.open(infile, 'r', encoding='utf-8') as f:
		while True:
			char = f.read(1)
			if not char: break
			else: text.append(char)

	for i in range(len(text)):
		tmp = unicode(text[i]).encode('utf-8')
		text[i] = tmp

	return text

def combine(s):
	
	for x in range(len(s)):
		if s[x] == 'i' or s[x] == 'e':
			if s[x+1] == 'o' or s[x+1] == 'a':
				first = s[x]
				second = s[x+1]
				combo = first + second
				s[x] = combo
				s.pop(x+1)
				s.append('')

def convertToRunes(s, runeDict):
	
	for i in range(len(s)):
		if s[i] in runeDict:
			s[i] = runeDict[s[i]]	

def writeToFile(runes, outfile, mode):
	#open write to file:

	tmp = ''
	for i in range(len(runes)):
		tmp = tmp + runes[i]

	#write tmp to file
	f = open(outfile, mode)
	f.write(tmp)

	f.close()

def toLC(s):

	#not using a built-in function, because apparently they don't work for the special symbols
	
	lowCase = {'F':'f', 'U':'u', 'Þ':'þ', 'Ð':'ð', 'O':'o', 'R':'r', 'C':'c', 'G':'g',
	'W':'w', 'H':'h', 'N':'n', 'I':'i', 'J':'j', 'E':'e', 'P':'p', 'X':'x',
	'S':'s', 'T':'t', 'B':'b', 'M':'m', 'L':'l', 'Ŋ':'ŋ', 'Œ':'œ', 'D':'d',
	'A':'a', 'Æ':'æ', 'Y':'y'}
	
	for i in range(len(s)):
		if s[i] in lowCase:
			s[i] = lowCase[s[i]]

def main(args):
	
	if len(args) != 3:
		print('wrong number of arguments.')
		print('syntax:  ./old-EngToRunes.py	inputfile.txt	outputfile.txt')
		print('the transliterated text is appended to outpurfile.txt')
		sys.exit()

	toRunes = {'f':'\xe1\x9a\xa0', 'u':'\xe1\x9a\xa2', 'þ':'\xe1\x9a\xA6', 'ð':'\xe1\x9a\xA6', 
	'o':'\xe1\x9a\xA9', 'r':'\xe1\x9a\xb1', 'c':'\xe1\x9a\xb3', 'g':'\xe1\x9a\xb7', 
	'w':'\xe1\x9a\xb9', 'h':'\xe1\x9a\xbb', 'n':'\xe1\x9a\xbe', 'i':'\xe1\x9b\x81', 
	'j':'\xe1\x9b\x84', 'eo':'\xe1\x9b\x87', 'p':'\xe1\x9b\x88', 'x':'\xe1\x9b\x89',
	's':'\xe1\x9b\x8b', 't':'\xe1\x9b\x8f', 'b':'\xe1\x9b\x92', 'e':'\xe1\x9b\x96', 
	'm':'\xe1\x9b\x97', 'l':'\xe1\x9b\x9a', 'ŋ':'\xe1\x9b\x9d', 
	'œ':'\xe1\x9b\x9f', 'd':'\xe1\x9b\x9e', 'a':'\xe1\x9a\xAA', 'æ':'\xe1\x9a\xAb', 
	'y':'\xe1\x9a\xA3', 'ia':'\xe1\x9b\xa1', 'io':'\xe1\x9b\xa1', 'ea':'\xe1\x9b\xa0',
	' ':'\xc2\xb7'}
 

	raw = importText(args[1])

	tmp = ''
	for i in range(len(raw)):
		tmp = tmp + raw[i]

	toLC(raw)
	combine(raw)
	runes = copy.deepcopy(raw)
	convertToRunes(runes, toRunes)
	
	writeToFile(raw, args[2], 'w')
	writeToFile(runes, args[2], 'a')


main(sys.argv)
