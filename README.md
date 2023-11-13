# Convert model output to table

R function to convert a lmer model output to an APA formatted table

## Overview

This function creates an APA formatted table from a growth curve analysis or mixed effects model, including 95% confidence intervals. The table output from this function is by no means perfect--You'll still have to go through and fix some of the formatting. This function is primarily to avoid any copying errors made when manual entering estimates, SE, *t*, and *p*-values by hand from R to word doc. 

## How to use
1. Copy this function script to a place in your local computer. 

2. In your R script that contains the model, enter the following:
   
   `source('path_to_function/convert_table.R')`

    Where `path_to_function` is the pathway on your computer to the folder containing the function.

4. Then, before using the function define the following variables:

   `caption`: the title for your table. Example: 'Table 1. Model output.'

   `outname`: filepath and filename for where to save the table and the name of the document in .docx format.

6. convert the model to a table as follows:

   `convert_table(model,caption,outname)`
