#!/usr/bin/env python
# coding: utf-8

# In[4]:


import re

def check_password(password):
    if len(password) < 6 or len(password) > 12:
        return False
    if not re.search(r"[a-z]", password):
        return False
    if not re.search(r"[A-Z]", password):
        return False
    if not re.search(r"[0-9]", password):
        return False
    if not re.search(r"[$#@]", password):
        return False
    return True

# Example usage
password = input("Enter your password: ")
if check_password(password):
    print("Valid password")
else:
    print("Invalid password")


# In[ ]:




