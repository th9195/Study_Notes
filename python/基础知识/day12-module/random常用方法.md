``` python
import  random

# 随机小数 0-1
a = random.random()
print(a)

# 随机整数
a = random.randint(1,200)
print(a)

# 在列表中随机选择
a = random.choice([True,False])
print(a)

a = random.choice(['A','B','C'])
print(a)

# 打乱列表
list1 = [1,2,3,4,5]
random.shuffle(list1)
print(list1)


```

