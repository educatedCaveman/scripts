#!/usr/bin/python

class Slist:
	
	def __init__(self, num, x, y):
		if (num == '.'):
#			print('set poss list')
			self.value = '.'
			self.x = int(x)
			self.y = int(y)
			self.possibilities = set(range(1, 10))
#			self.possibilities = [1,2,3,4,5,6,7,8,9]
			self.isGuessed = False
		else:
			self.value = int(num)
			self.x = int(x)
			self.y = int(y)
			self.possibilities = set(range(self.value, self.value+1))
			self.isGuessed = False

	def printProperties(self):
		print('value:  ', self.value)
		print('possibilities:  ', self.possibilities)
		print('isGuessed',  self.isGuessed)

