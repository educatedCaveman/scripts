#!/usr/bin/python
from slist import Slist

def sector(cell):
	return int(cell.x/3)+3*int(cell.y/3)

#define all functions needed to reduce possibilities:
def square1(puzz, cell):
	
	rc = int(0)

	sec = sector(cell)
	for i in range(9):
		for j in range(9):
			if (sector(puzz[i][j]) == sec) and (i != cell.x or j != cell.y):
#				print('{0},{1} causes reduction of {2},{3}'.format(cell.x, cell.y, i, j))
				l1 = len(puzz[i][j].possibilities)
				puzz[i][j].possibilities.discard(cell.value)
				l2 = len(puzz[i][j].possibilities)
				if l1 > l2:
					rc = rc + 1
		
	return rc

#if a cell in a square is the only cell in the square that can have that value, set that cell to that value
def square2(puzz, cell):

	rc = int(0)
	sec = sector(cell)
	tmpSet = cell.possibilities.copy()
	
	if len(tmpSet) > 1:
		for num in tmpSet:
			single = True
			for i in range(9):
				for j in range(9):
					if ((sector(puzz[i][j]) == sec) and (i != cell.x or j != cell.y) and (single == True) and (num in puzz[i][j].possibilities)):
						single = False
			if single == True:
				print('{0} only found in {1}, {2}'.format(num, cell.x, cell.y))
				rc = rc + 1
				cell.value = num
				cell.possibilities.clear()
				cell.possibilities.add(num)
			
	return rc

#when all possibilities are in a single row/column of a square, can use to eliminate posibilities in other squares
	#maybe.  doesn't reveal a whole lot.

def row(puzz, cell):
	
	x = cell.x
	y = cell.y
	
	#modify found value:
	cell.value = next(iter(cell.possibilities))
	rc = int(0)
	#modify those in row:
	for i in range(0, 9):
		if (i != y):	
			l1 = len(puzz[x][i].possibilities)	
			puzz[x][i].possibilities.discard(cell.value)
			l2 = len(puzz[x][i].possibilities)			
			if l1 > l2:
				rc = rc + 1

	return rc

def col(puzz, cell):
	
	x = cell.x
	y = cell.y
	
	#modify found value:
	cell.value = next(iter(cell.possibilities))
	rc = int(0)
	#modify those in column:
	for i in range(0, 9):
		if (i != x):
			l1 = len(puzz[i][y].possibilities)
			puzz[i][y].possibilities.discard(cell.value)
			l2 = len(puzz[i][y].possibilities)
			if l1 > l2:
				rc = rc + 1

	return rc


def checkRow(s, x):

	for i in range(9):
		for j in range(i+1, 9):
			if s[x][i].value == s[x][j].value and s[x][i].value != '0' and s[x][i].value != '.':
				return False

def checkCol(s, y):

	for i in range(9):
		for j in range(i+1, 9):
			if s[i][y].value == s[j][y].value and s[i][y].value != '0' and s[i][y].value != '.':
				return False

def checkSqr(s, n):

	secList = []
	secSet = set ()
	for i in range(9):
		for j in range(9):
			if sector(s[i][j]) == n and s[i][j].value != '0' and s[i][j].value != '.':
				secList.append(s[i][j].value)
				secSet.add(s[i][j].value)

	if len(secList) != len(secSet):
		return False

	return True

def checkCon(s):
	
	#run row, col, and sec validation
	for i in range(9):
		if (checkRow(s, i) == False):
			return False

	for i in range(9):
		if (checkCol(s, i) == False):
			return False

	for i in range(9):
		if (checkSqr(s, i) == False):
			return False

	return True


#big function to loop through all functions as long as 1 made a change.

def bigLoop(s):
	#filler for now

	itr = int(1)
	while (itr > int(0)):
		itr = int(0)	#set to 0 so when it loops, >0 means a change was made

		#for every cell, if it is known, remove the value from row, column, and square
		for x in range(0, 9):
			for y in range(0, 9):
				if (len(s[x][y].possibilities) == 1):
					itr = itr + (square1(s, s[x][y]))
#					itr = itr + (square2(s, s[x][y]))
					itr = itr + (row(s, s[x][y]))
					itr = itr + (col(s, s[x][y]))
				itr = itr + (square2(s, s[x][y]))
