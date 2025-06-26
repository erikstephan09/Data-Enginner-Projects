Twitch is the world’s leading live streaming platform for gamers, with 15 million daily active users. Using data to understand its a
users and products is one of the main responsibilities of the Twitch Data Science Team.

In this project, you will be working with two tables that contain Twitch users stream viewing data and chat room user data.

Stream viewing data
stream table

Chat usage data
chat table

Parts of this project

Part 1: Analyze Twitch Gaming Data (Using SQL)
Part 2: Visualize Twitch Gaming Data (Using Matplotlib)

-------------------------------------------------Task part 1:-----------------------------------------------------
1.What are the unique games in the stream table?
2.What are the unique channels in the stream table?
3.What are the most popular games in the stream table?
4.Create a list of games and their number of viewers.
5.Where are these LoL stream viewers located?
6.The player column contains the source the user is using to view the stream (site, iphone, android, etc). Create a list of players and their number of streamers.
7.Create a new column named genre for each of the games using the following genrer:
	If League of Legends → MOBA
	Dota 2 → MOBA
	Heroes of the Storm → MOBA
	Counter-Strike: Global Offensive → FPS
	DayZ → Survival
	ARK: Survival Evolved → Survival
	Else → Other

9. Write a query that returns two columns: The hours of the time colum, the view count for each hour
join the stream table and the chat table.
-------------------------------------------------Task part 2:-----------------------------------------------------

In this part, you well visualize Twitch data using Python and Matplotlib
Bar Graph: Featured Games
Pie Chart: Stream Viewers’ Locations
Line Graph: Time Series Analysis

---Bar Graph: Featured Games----

1.Make a list of games and viewers from the part1-4 section
2.Genere a graphic suing plt.bar() of viewers and range(len(game)) and show it.
3.Make the graph more informative using de following:
	Add a title
	Add a legend
	Add axis labels
	Add ticks
	Add tick labels(rotate if necessary)

---Pie Chart: Stream Viewer's Location-----------
4.There are 1070 League of Legends viewers from this dataset. Where are they coming from?
	Write a Labels and countries list of the labels and countries using the information of Part1-5
5. Use plt.pie() to plot a pie chat.
	use the next code of the colors = colors = ['lightskyblue', 'gold', 'lightcoral', 'gainsboro', 'royalblue', 'lightpink', 'darkseagreen', 'sienna', 'khaki', 'gold', 'violet', 'yellowgreen']
6. Optional: Let's make it more visually appealing and more informative.
	First, let’s “explode”, or break out, the 1st slice (United States):
	explode = (0.1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)


	Then, inside plt.pie(), we are going to:
	Add the explode
	Add shadows
	Turn the pie 345 degrees
	Add percentages
	Configure the percentages’ placement
	
	so it lool something like:
	plt.pie(countries, explode=explode, colors=colors, shadow=True, startangle=345, autopct='%1.0f%%', pctdistance=1.15)
	ALSO, we can add a title: 
	plt.title("League of Legends Viewers' Whereabouts")
	And a legends:
	plt.legend(labels, loc="right")

---Line Graph: Time Series Analysis-----------

7. Using the information of Part1-9, create a list of hour and viewers_hour and use a plt.plot to plot a line graph
	






