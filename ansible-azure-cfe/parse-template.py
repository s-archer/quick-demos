#!/usr/bin/env python3
#
# This script pulls the parameters from F5 cft/arm templates for use in Ansible playbook
#

import json
with open('./raw-template.json') as json_file:
    json_data = json.loads(json_file)
    for p in json_data['parameters']:
        #print (p + ": " + "\"\"")
        print (p)

    #  for p in json_data['parameters']:
    #      elements = json_data['parameters'][p]
    #      for e in elements:
    #              print (p + ':  "'  + e + '"')


# # Open the f5 CFT or ARM template file
# with open('./raw-template.json') as json_file:  
#     # Import the file as a JSON object
#     data = json.load(json_file)
#     # Loop through each parameter (p) in the parameters section
#     for p in data['parameters']:
#         elements = data['parameters'][p]
#         # For each parameter, loop through each element (e)
#         for e in elements:
#             # If the element name is equal to Default, AllowedValues, Description or ConstraintDescription then print it's value.  
#             # but if the value is a list, convert it to a string.  
#             # or if the value is an integer (int), also convert to a string. 
#             # then print the line.
#             if e in ('defaultValue', 'allowedValues', 'Description', 'ConstraintDescription'):
#                 print (p + ':  "'  + e + '"')


