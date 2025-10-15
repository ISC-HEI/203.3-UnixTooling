def calculate_average(numbers):
    total = 0
    count = 0
    for num in numbers:
        total = total + num
        count = count + 1
    return total / count

def find_maximum(values):
    max_value = values[0]
    for value in values:
        if value > max_value:
            max_value = value
    return max_value

def process_data(data):
    result = []
    for item in data:
        if item > 0:
            result.append(item * 2)
        else:
            result.append(item)
    return result

name = "Alice"
age = 25
city = "Paris"
print("Name: " + name)
print("Age: " + str(age))
print("City: " + city)
