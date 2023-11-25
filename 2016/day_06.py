lines = open('/resources/input-6').readlines()

def common(li,func=max):
	lists = [{}, {}, {}, {}, {}, {}, {}, {}]

	for line in li:
		line = line.strip()
		for i, char in enumerate(line):
			lists[i][char] = lists[i].get(char, 0) + 1
	
	final_list = [func(dict.items(), key=lambda x: x[1])[0] for dict in lists]

	return final_list
		

print("".join(common(lines)))
print("".join(common(lines, min)))
