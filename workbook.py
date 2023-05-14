#!/usr/bin/env python
# coding: utf-8

# ASSIGNMENT

# In[ ]:





# In[12]:


import random


# In[13]:


# Generate a random number between 1 and 100
number = random.randint(1, 100)

# Ask the user to guess the number
guess = int(input("Guess a number between 1 and 100: "))

# Keep asking the user to guess until they get the correct number
while guess != number:
    if guess < number:
        print("Too low. Guess again.")
    else:
        print("Too high. Guess again.")
    guess = int(input("Guess a number between 1 and 100: "))

# If the user guessed correctly, congratulate them
print("Congratulations! You guessed the correct number: ", number)


# In[ ]:




