lines = open('./resources/input-7').readlines()

def split(line):
	brackets = []
	non_brackets = []
	adding_brackets = False
	while len(line) > 0:
		if adding_brackets:
			val, line = line.split(']', 1)
			brackets.append(val)
		else:
			val = line.split('[', 1)

			
			non_brackets.append(val[0])

			if len(val) == 1:
				break

			line = val[1]

		adding_brackets = not adding_brackets

	return (brackets, non_brackets)

def abba_detector(section):
	for i, _ in enumerate(section[0:-3]):
		a, b, c, d = section[i:i+4]

		if a != b and a == d and b == c:
			return True
	
	return False

def aba_detector(section):
	answers = []
	for i, _ in enumerate(section[0:-3]):
		a, b, c = section[i:i+3]

		if a != b and a == c:
			answers.append(section[i:i+3])
	
	return answers

def aba_to_bab(aba):
	a, b, _ = aba
	return "{}{}{}".format(b,a,b)

def supports_tls(line):
	brackets, non_brackets = split(line)
	brackets_okay = all(map(lambda x: not abba_detector(x), brackets))

	return  brackets_okay and any(map(lambda x: abba_detector(x), non_brackets))

def supports_ssl(line):
	brackets, non_brackets = split(line)
	aba = False

	for section in non_brackets:
		aba = aba_detector(section)
		if len(aba) > 0:
			# TODO: Aba is now an array of possible abas. Loop over and make this stuff complex
			bab = aba_to_bab(aba)
			if any(map(lambda x: bab in x, brackets)):
				return True

	return False
	# return (aba != False and any(map(lambda x: aba_to_bab(aba) in x, brackets)))
	# if aba == False:
	# 	return False


	# return  brackets_okay and any(map(lambda x: abba_detector(x), non_brackets))

i = 0
j = 0

for line in lines:
	if supports_tls(line):
		i = i + 1
	if supports_ssl(line):
		j = j + 1

print(i)
print(j)
