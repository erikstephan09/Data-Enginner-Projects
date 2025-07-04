You just got hired as a Data Analyst at the Census Bureau, which collects census data and creates interesting visualizations and insights from it.

The person who had your job before you left you all the data they had for the most recent census. It is in multiple csv files. They didn’t use pandas, they would just look through these csv files manually whenever they wanted to find something. Sometimes they would copy and paste certain numbers into Excel to make charts.

The thought of it makes you shiver. This is not scalable or repeatable.

Your boss wants you to make some scatterplots and histograms by the end of the day. Can you get this data into pandas and into reasonable shape so that you can make these histograms?

The first visualization your boss wants you to make is a scatterplot that shows average income in a state vs proportion of women in that state.
	How are they named?
	What kind of information do they hold?
	Will they help us make this graph?



------------------------------------------Inspect the Data!-----------------------------------------------------------------

1. Using glob, loop through the census files avaiolable and load them into DataFrames. Then, concatenate all of those DataFrame. 
2. what is the dtype od the us_census? Are those daratypes going to hinder you as yoy try to make histograms?
3. Look at the .head() of the DataFrame so that you can understand why some of these dtypes are objects instead of integers or floats.

Start to make a plan for how to convert these columns into the right types for manipulation. 

-----------------------------------------Regex to the Rescue-----------------------------------------------------------------

4. Use regex to turn the Income column into a format that is ready for conversasion into a numerical type.
5. Look at the GenderPop column. We are going to want to separate this into two columns, the Men column, and the Women column.
    Split the column into those two new columns using str.split and separating out those results.

6. Convert both of the columns into numerical datatypes.
   There is still an M or an F character in each entry! We should remove those before we convert.

7. Now you should have the columns you need to make the graph and make sure your boss does not slam a ruler angrily on your desk because you’ve wasted your 
	whole day cleaning your data with no results to show! Use matplotlib to make a scatterplot!

8. You want to double check your work. You know from experience that these monstrous csv files probably have nan values in them! 
	Print out your column with the number of women per state to see.
	We can fill in those nans by using pandas’ .fillna() function.
	You have the TotalPop per state, and you have the Men per state. As an estimate for the nan values in the Women column, you could use the TotalPop 	of that state minus the Men for that state.
	Print out the Women column after filling the nan values to see if it worked!
9. We forgot to check for duplicates! Use .duplicated() on your census DataFrame to see if we have duplicate rows in there.
10. Drop those duplicates using the .drop_duplicates() function.
11. Make the scatterplot again. Now, it should be perfect! Your job is secure, for now.

------------------------------------------Histograms of Races -----------------------------------------------------------------

12. Now, your boss wants you to make a bunch of histograms out of the race data that you have. Look at the .columns again to see what the race categories are.
13. Try to make a histogram for each one!
	You will have to get the columns into numerical format, and those percentage signs will have to go.

	Don’t forget to fill the nan values with something that makes sense! You probably dropped the duplicate rows when making your last graph, 
	but it couldn’t hurt to check for duplicates again.

14. Phew. You’ve definitely impressed your boss on your first day of work.
But is there a way you really convey the power of pandas and Python over the drudgery of csv and Excel?
Try to make some more interesting graphs to show your boss, and the world! You may need to clean the data even more to do it, or the cleaning you have already done may give you the ease of manipulation you’ve been searching for.