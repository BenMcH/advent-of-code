dirs = "L1, L5, R1, R3, L4, L5, R5, R1, L2, L2, L3, R4, L2, R3, R1, L2, R5, R3, L4, R4, L3, R3, R3, L2, R1, L3, R2, L1, R4, L2, R4, L4, R5, L3, R1, R1, L1, L3, L2, R1, R3, R2, L1, R4, L4, R2, L189, L4, R5, R3, L1, R47, R4, R1, R3, L3, L3, L2, R70, L1, R4, R185, R5, L4, L5, R4, L1, L4, R5, L3, R2, R3, L5, L3, R5, L1, R5, L4, R1, R2, L2, L5, L2, R4, L3, R5, R1, L5, L4, L3, R4, L3, L4, L1, L5, L5, R5, L5, L2, L1, L2, L4, L1, L2, R3, R1, R1, L2, L5, R2, L3, L5, L4, L2, L1, L2, R3, L1, L4, R3, R3, L2, R5, L1, L3, L3, L3, L5, R5, R1, R2, L3, L2, R4, R1, R1, R3, R4, R3, L3, R3, L5, R2, L2, R4, R5, L4, L3, L1, L5, L1, R1, R2, L1, R3, R4, R5, R2, R3, L2, L1, L5".split(", ")

loc = (0, 0)
dir = 0
part_2 = True
visited = set()


for d in dirs:
    num = int(d[1:])
    if d[0] == 'L':
        dir = 3 if dir == 0 else dir - 1
    else:
        dir = 0 if dir == 3 else dir + 1
        
    while num > 0:
        num = num - 1
        if dir == 0:
            loc = (loc[0]+1, loc[1])
        elif dir == 1:
            loc = (loc[0], loc[1]+1)
        elif dir == 2:
            loc = (loc[0] - 1, loc[1])
        elif dir == 3:
            loc = (loc[0], loc[1]-1)
        
        if part_2:
            if loc in visited and part_2:
                part_2 = False
                ans = abs(loc[0]) + abs(loc[1])
                print("Part 2: {}".format(ans))
            else:
                visited.add(loc)
print(abs(loc[0]) + abs(loc[1]))


