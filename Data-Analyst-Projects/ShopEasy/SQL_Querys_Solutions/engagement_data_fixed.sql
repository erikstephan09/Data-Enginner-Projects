SELECT * FROM engagement_data;

-- Duplicate rows (No duplicate rows)

WITH dce AS (
	SELECT *,
	ROW_NUMBER() OVER (PARTITION BY EngagementID, 
						ContentID, CampaignID, ProductID 
						ORDER BY EngagementID) AS 'DC'
	FROM engagement_data
	)
	SELECT * FROM dce
	WHERE DC = 2;

-- Divide ViewsClicksCombined into 2 differents columns 

SELECT ViewsClicksCombined,
	LEFT(ViewsClicksCombined, CHARINDEX('-', ViewsClicksCombined) -1 ) AS 'Views',
	RIGHT(ViewsClicksCombined, LEN(ViewsClicksCombined) - CHARINDEX('-', ViewsClicksCombined)) AS 'Clicks'
	FROM engagement_data;

-- Fix ContentType
SELECT ContentType,
	REPLACE(ContentType, 'SocialMedia', 'Social Media') AS 'nct'
	FROM engagement_data;

-- Final Engagement table 

WITH fet AS (
	SELECT EngagementID,
		ContentID,
		REPLACE(ContentType, 'SocialMedia', 'Social Media') AS 'ContentType',
		Likes,
		EngagementDate,
		CampaignID,
		ProductID,
		LEFT(ViewsClicksCombined, CHARINDEX('-', ViewsClicksCombined) -1 ) AS 'Views',
		RIGHT(ViewsClicksCombined, LEN(ViewsClicksCombined) - CHARINDEX('-', ViewsClicksCombined)) AS 'Clicks'
	FROM engagement_data
	)

	SELECT EngagementID,
		ContentID,
		LOWER(ContentType) AS 'ContentType',
		Likes,
		EngagementDate,
		CampaignID,
		ProductID,
		Views,
		Clicks
	FROM fet
	WHERE ContentType != 'newsletter';

/*Customer Engagement Rate*/
--Level of interaction with marketing content(clicks, likes, comments)