#!/usr/bin/python

#import sys

#args = sys.argv

def importAndFormat(sfile):
	f = open(sfile, 'r')
	sudoku = []
	sudoku = f.readlines()
	
	#strip out \n and separate by commas
	for line in range(0, 9):
		sudoku[line] = sudoku[line].replace('\n', '')
		sudoku[line] = sudoku[line].split(",")
	
	return sudoku

