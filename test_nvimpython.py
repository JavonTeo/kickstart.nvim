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
