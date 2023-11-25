from hashlib import md5

test = 'abc'
actual = 'cxdnnyjw'

def part_1(i, start = 0):
	num = start - 1

	ans = ''

	for _ in range(8):
		hash = ''
		while not hash.startswith('00000'):
			num = num + 1
			string = "{}{}".format(i, num)
			hash = md5(string.encode()).hexdigest()
		ans = '{}{}'.format(ans, hash[5])	
		
	return ans
# print(part_1(test, 3231800))
# print(part_1(actual))


def part_2(i, start = 0):
	num = start - 1

	ans = [-1] * 8

	while -1 in ans:
		while True:
			num = num + 1
			string = "{}{}".format(i, num)
			hash = md5(string.encode()).hexdigest()

			if hash.startswith('00000') and hash[5].isdigit() and int(hash[5]) < 8:
				idx = int(hash[5])
				if ans[idx] != -1:
					continue
				ans[idx] = hash[6]
				# print(hash)
				break
	return "".join(ans)

print(part_2(test))
print(part_2(actual))
