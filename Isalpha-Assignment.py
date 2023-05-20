#!/usr/bin/env python
# coding: utf-8

# In[1]:


def count_letters_digits(sentence):
    letters = sum(1 for char in sentence if char.isalpha())
    digits = sum(1 for char in sentence if char.isdigit())
    return letters, digits


sentence = input("Enter a sentence: ")


letter_count, digit_count = count_letters_digits(sentence)

print("LETTERS", letter_count)
print("DIGITS", digit_count)


# In[ ]:




