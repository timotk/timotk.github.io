---
title: "A Terminal Spinner in Python"
date: 2022-06-25T12:30+02:00
draft: false
---
We are going to build a spinning status indicator that runs while other code is executing.

It will look like this:
![](/images/spinner.gif)

## Why?
You've got some code that takes a while to run.
```python
import time
import random


def slow_func():
    seconds = random.randint(2, 5)
    time.sleep(seconds)
    print("Done!")


if __name__ == '__main__':
    slow_func()
```

Now, when you execute this, you'll see the following:
![](/images/terminal-busy-block.png)

You'll wonder whether your code or your system is working correctly or frozen. Who knows?

## Introducing a spinner
Ideally, we'd like to show some sort of activity while our code is executing. 
We can do that with a spinner. To create a spinner, we can use:
```python
import time
import itertools


def spin():
    spinners = ["|", "/", "-", "\\"]
    for c in itertools.cycle(spinners):
        print(f"\r{c}", end="")
        time.sleep(0.1)
```

1. We introduce a list of spinners (`| / - \ `). The double backslash is used because of [escaping](https://www.freecodecamp.org/news/escape-sequences-python/).
2. Using `itertools.cycle`, we can create an endless _cycle_ of our spinner elements.
3. In each iteration, we print one of characters.
   1. By default, Python ends a print statement with a newline. We disable that by printing an empty string (`end=""`)
   2. By putting `\r` in front of our character, we move our cursor back to the start of the line. This is called a [carriage return](https://en.wikipedia.org/wiki/Carriage_return).
   4. We sleep for 100ms.

# Combine the spinner with the code
Now, combining them can be done like this:
```python
spin()
slow_func()
```
But obviously this does not work, since our code executes sequentially. 
First the spinner runs to completion, then `slow_func` will run.
Due to the endless nature of `itertools.cycle`, our code in `spin()` never stops.

To solve this, we can run our spinner in its own [thread](https://docs.python.org/3/library/threading.html), which allows us to run code in parallel:
```python
import threading

if __name__ == '__main__':
    thread = threading.Thread(target=spin)
    thread.daemon = True
    thread.start()
    slow_func()
```

1. We start a new thread, with the `spin` function as its target.
2. We set `thread.daemon` to True, to make the thread run in the background.
3. We start the thread.
4. We call our slow function

Here's what it looks like:
![](/images/spinner.gif)

# Making it awesome
If you want to reuse your code, it wouldn't be so nice. To fix that, we can introduce a [context manager](https://docs.python.org/3/reference/datamodel.html#context-managers).
This will make usage look like this:
```python
with Spinner():
    slow_func()
```

Here's how we write the context manager:
```python
class Spinner:
    def __init__(self):
        self.running = False
        self.thread = threading.Thread(target=self.spin)
        self.thread.daemon = True

    def spin(self):
        spinners = ["|", "/", "-", "\\"]
        for c in itertools.cycle(spinners):
            if not self.running:
                print("\r", end="")
                break

            print(f"\r{c}", end="")
            time.sleep(0.1)

    def __enter__(self):
        self.running = True
        self.thread.start()

    def __exit__(self, exc_type, exc_val, exc_tb):
        self.running = False
```

The logic is:
1. We initialize the instance with `Spinner()`. This calls `__init__()`, which sets running to `False` and creates the thread.
2. After the `with Spinner():` line, `Spinner.__enter__()` gets called. We now enter the context and the thread starts running.
3. Our slow function runs. Meanwhile, every 100ms, a spin character gets printed.
4. Our slow function ends and we exit the `with` block. Now, `Spinner.__exit__()` gets called. Running will be set to `False`, which means the `spin()` method will break out of its loop, once it detects `self.running` is `False`.

# Further improvements
We can make our code even more dynamic, by allowing you to set the spin timeout and the spinners during class initialization.
Here's the full code:

```python
import itertools
import threading
import time


class Spinner:
    def __init__(self, timeout: float = 0.1, spinners: list = ["|", "/", "-", "\\"]):
        self.timeout = timeout
        self.spinners = spinners
        self.running = False
        self.thread = threading.Thread(target=self.spin)
        self.thread.daemon = True
        
    def spin(self):
        for c in itertools.cycle(self.spinners):
            if not self.running:
                print("\r", end="")
                break

            print(f"\r{c}", end="")
            time.sleep(self.timeout)

    def __enter__(self):
        self.running = True
        self.thread.start()

    def __exit__(self, exc_type, exc_val, exc_tb):
        self.running = False
```

You could use any spinners you like, for example:
```python
["⢿", "⣻", "⣽", "⣾", "⣷", "⣯", "⣟", "⡿"]

["👆", "👉", "👇", "👈"]

["|   ", " |  ", "  | ", "   |"]
```
You can find many more examples online, or you can simply make your own.


# Final thoughts
I hoped you learned something about how we can indicate activity while you are running your program interactively.
If you need a more extensive approach, you can use a library like [rich](https://github.com/Textualize/rich).
