#!/usr/bin/env python
# coding: utf-8

# In[5]:


import pandas as pd
import matplotlib.pyplot as plt


# In[6]:


# read the dataset
df= pd.read_csv('telecom_churn.csv')


# In[7]:


df.T


# In[8]:


# check the dimensinality of the dataframe by printing the shape of the dataframe
df.shape


# In[9]:


# check the information of the dataset
df.info()


# In[10]:


# check the descriptive statistics of the dataset
df.describe()


# In[11]:


# change the data type of the churn column from boolean to int64 and check the dataframe again
df['Churn'] = df['Churn'].astype('int64')


# In[12]:


column_data = df['Churn']
print(column_data)


# In[13]:


# get the distribution of the churn by counting how many churned and how many did not
churn_distribution = df['Churn'].value_counts()


# In[14]:


# plot the count from the result above
df['Churn'].plot(kind='hist')


# In[15]:


# what is the proportion of churned users in the dataframe
df['Churn'].mean()*100


# In[16]:


# How much time (on average) do churned users spend on the phone during daytime?

churned_users = df[df['Churn'] == 1]  # Filter churned users

average_time = churned_users['Total day minutes'].mean()  # Calculate mean of Total day minutes

print("Average time spent on the phone during daytime by churned users:", average_time)


# In[17]:


# What is the maximum length of international calls among loyal users (Churn == 0) who do not have an international plan?
max_intl_call_length = df.loc[(df['Churn']== 0) & (df['International plan'] == 'No'), 'Total intl minutes'].max()
max_intl_call_length


# In[18]:


# give the values of the first five rows in the first three columns
df.iloc[0:5, 0:4]


# In[19]:


# select all the states that starts with W
mask = df['State'].str.startswith('W')
selected_states = df[mask]

print(selected_states)


# In[20]:


# using the map function, replace Yes and No in the International plan column to True and False
df['International plan'] = df['International plan'].map({'Yes': True, 'No': False})
df


# In[21]:


# we want to understand the total calls that have been made by customers. Total_calls is calculated as
# the sum of Total dat calls, Total eve calls, Total night calls, Total intl calls.
df['Total_calls'] = df['Total day calls'] + df['Total eve calls'] + df['Total night calls'] + df['Total intl calls']

df


# In[25]:


pip install seaborn matplotlib


# In[26]:


import matplotlib.pyplot as plt
import seaborn as sns


# In[32]:


# create a count plot to understand the churn of the international plan
import seaborn as sns
import matplotlib.pyplot as plt

# Assuming your dataframe is named 'df' and the column containing the international plan information is named 'international_plan'

sns.countplot(data=df, x='International plan', hue='Churn')
plt.title('Churn of International Plan')
plt.xlabel('International Plan')
plt.ylabel('Count')
plt.show()


# In[ ]:




