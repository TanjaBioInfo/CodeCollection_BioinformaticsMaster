#
# BIO 394 - Python Programming Lab
# Basics 2
#
# 2. Countries.
#

# Reads the file (assumes it to be in the same directory as the script)
input_file = open("countries.csv")
lines = input_file.readlines()
input_file.close()

country_dict = dict()	
summary = dict() 

# Iterate through the lines (task a).
for line in lines:
    
    # Extract the information in each line in a separate variable.	
    line_list = line.split(',')		
    country = line_list[0].strip()
    continent = line_list[1].strip()
    population_size = int(line_list[2].strip())
    
    # Create for the country a dictionary entry (task b).
    country_dict[country] = {'continent' : continent, 'population_size' : population_size}
    
    # Update the summary informaiton (task c)
    if continent not in summary:
        summary[continent] = 0
    summary[continent] += population_size


# Print the country dictionary.
for country in country_dict:
   print(country, country_dict[country])

# Write summary to file
output_file = open("summary.txt", 'w') 
for continent in summary:
    output_file.write(continent + ": " + str(summary[continent]) + "\n")

output_file.close()