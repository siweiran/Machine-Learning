#!/usr/bin/env python
# coding: utf-8

# In[1]:


import pandas as pd
import numpy as np
import matplotlib.pyplot as plt


# In[2]:


drink = pd.read_csv("drinking.csv")
new_drink = drink.dropna()
under_age = new_drink[(new_drink.age < 21)]
above_age = new_drink[(new_drink.age > 21)]
mean_others_under = under_age['others'].mean()
mean_suicide_under = under_age['suicide'].mean()
mean_accident_under = under_age['accident'].mean()
mean_others_above = above_age['others'].mean()
mean_suicide_above = above_age['suicide'].mean()
mean_accident_above = above_age['accident'].mean()
# Calculate mean difference
diff_mean_others = mean_others_above - mean_others_under
diff_mean_suicide = mean_suicide_above - mean_suicide_under
diff_mean_accident = mean_accident_above - mean_accident_under
diff_mean_accident


plt.figure(figsize=(8,8))
ax = plt.subplot(3,1,1)
drink.plot.scatter(x="age", y="others", ax=ax)
plt.title("Death Cause by Age (Centered at 0)")
plt.axvline(x = 20, color = 'r', label = 'axvline - full height')
plt.axvline(x = 22, color = 'r', label = 'axvline - full height')


ax = plt.subplot(3,1,2, sharex=ax)
drink.plot.scatter(x="age", y="accident", ax=ax)
plt.axvline(x = 20, color = 'r', label = 'axvline - full height')
plt.axvline(x = 22, color = 'r', label = 'axvline - full height')


ax = plt.subplot(3,1,3, sharex=ax)
drink.plot.scatter(x="age", y="suicide", ax=ax)
plt.axvline(x = 20, color = 'r', label = 'axvline - full height')
plt.axvline(x = 22, color = 'r', label = 'axvline - full height')

