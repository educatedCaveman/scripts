#!/usr/bin/python
import sys
from simport import importAndFormat
from slist import Slist
import determine

args = sys.argv

def printList(s):
	for x in range(0, 9):
		print s[x]

def printObj(s):
	for x in range(0, 9):
		if x in (0, 3, 6):
			print('+-------+-------+-------+')
			print('| {0} {1} {2} | {3} {4} {5} | {6} {7} {8} |'.format(s[x][0].value,s[x][1].value,s[x][2].value,s[x][3].value,s[x][4].value,s[x][5].value,s[x][6].value,s[x][7].value,s[x][8].value))

		else:
			print('| {0} {1} {2} | {3} {4} {5} | {6} {7} {8} |'.format(s[x][0].value,s[x][1].value,s[x][2].value,s[x][3].value,s[x][4].value,s[x][5].value,s[x][6].value,s[x][7].value,s[x][8].value))
	print('+-------+-------+-------+')
	print

def printObjPoss(s):
	for x in range(0, 9):
		if x in (0, 3, 6):
			print('+-------+-------+-------+')
			print('| {0} {1} {2} | {3} {4} {5} | {6} {7} {8} |'.format(len(s[x][0].possibilities),len(s[x][1].possibilities),len(s[x][2].possibilities),len(s[x][3].possibilities),len(s[x][4].possibilities),len(s[x][5].possibilities),len(s[x][6].possibilities),len(s[x][7].possibilities),len(s[x][8].possibilities)))

		else:
			print('| {0} {1} {2} | {3} {4} {5} | {6} {7} {8} |'.format(len(s[x][0].possibilities),len(s[x][1].possibilities),len(s[x][2].possibilities),len(s[x][3].possibilities),len(s[x][4].possibilities),len(s[x][5].possibilities),len(s[x][6].possibilities),len(s[x][7].possibilities),len(s[x][8].possibilities)))
	print('+-------+-------+-------+')
	print

def list2obj(s):
	for x in range(0, 9):
		for y in range(0, 9):
			s[x][y] = Slist(s[x][y], x, y)

def main(a):
	if (len(a) > 2):
		print('too many arguments\n')
		exit()
	sudoku = importAndFormat(args[1])
	list2obj(sudoku)
	print('starting puzzle:')
	printObj(sudoku)	
#	printObjPoss(sudoku)
	determine.bigLoop(sudoku)	
	print('ending puzzle:')
	printObj(sudoku)
	printObjPoss(sudoku)
	
	val = determine.checkCon(sudoku)
	if val == True:
		print('validated!')
	else:
		print('CONTRADICTION!')

main(args)
