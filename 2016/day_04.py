import os

def is_valid(line):
	checksum = line[-6:-1]
	letters = line[0:-11]
	sector = int(line[-10:-7])

	_map = {}
	for letter in letters:
		if letter == '-':
			continue
		if letter in _map:
			_map[letter] = _map[letter] + 1
		else:
			_map[letter] = 1

	obj = {
		"checksum": checksum,
		"letters":  letters,
		"sector": sector
	}
	last_num = 99
	last_char = '{'
	for i, val in enumerate(checksum):
		if val not in _map or last_num < _map[val] or (last_num == _map[val] and last_char > val):
			obj['sector'] = 0
			break
		last_num = _map[val]
		last_char = val
	
	return obj

sum = 0

l = open('/resources/input-4').readlines()

for a in l:
	sum = sum + is_valid(a.strip())['sector']

print(sum)

letters = list(map(chr, range(97, 123)))

def rotate(str, num):
	new_str = ""

	for letter in str:
		if letter == '-':
			new_str = new_str + ' '
		else:
			idx = letters.index(letter) + num
			idx = idx % len(letters)
			new_str = new_str + letters[idx]
	return new_str


for a in l:
	result = is_valid(a.strip())

	if result["sector"] > 0:
		print(rotate(result['letters'], result['sector']), result['sector'])

