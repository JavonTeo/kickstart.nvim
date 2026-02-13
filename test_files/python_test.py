price = 5
print(f"this jacket is {price} dollars")


def japgraf(func):
    def wrapper(func):
        if 1 == 0:
            print('11')
        else:
            print('japgraf $$$$')
            return func()
    return wrapper

@japgraf
def hello():
    print('hello')

hello()

class DataProcessor:
    def __init__(self):
        self.data = []

    def process(self):
        # A long comment to make the fold visible
        # that spans multiple lines.
        for i in range(10):
            print(f"Processing {i}")
            if i % 2 == 0:
                print("Even")

def standalone_func():
    print("I am outside the class")
