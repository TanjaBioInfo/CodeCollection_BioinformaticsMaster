#
# BIO 394 - Python Programming Lab
# Pandas
#

import pandas as pd
import matplotlib.pyplot as plt

# 1) Read the file biostats.csv. 
biostats_df = pd.read_csv("pandas/biostats.csv", quotechar='"')

# 2) Print the means.
print(biostats_df.mean())

# 3) Select people older than 30.
df_older = biostats_df[biostats_df['Age'] > 30]
print(df_older)

# 4) Select females heavier than 130 pounds.
df_heavier = biostats_df[(biostats_df['Sex'] == 'F') & (biostats_df['Weight_lbs'] > 130)]
print(df_heavier)                 

# 5) Convert to cm, kg.
biostats_df['Height_cm'] = biostats_df['Height_inch'].apply(lambda x: x * 2.54)
biostats_df['Weight_kg'] = biostats_df['Weight_lbs'].apply(lambda x: x * 0.45359237)

print(biostats_df)

# 6) Plot weight vs. height.
biostats_df.plot.scatter(x='Weight_kg', y='Height_cm')
plt.show()
