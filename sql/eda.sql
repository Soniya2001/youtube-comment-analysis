SELECT 
   PublishedAt FROM `data-analysis-youtube-comment.youtube_comment.youtube_comments`
  WHERE (EXTRACT(YEAR FROM PublishedAt)) > 2024
  ORDER BY PublishedAt DESC;


SELECT 
  COUNT(*) AS TotalComments,
  COUNT(DISTINCT VideoId) AS total_videos,
  COUNT(DISTINCT AuthorChannelId) AS total_authors,
  COUNTIF(Sentiment = 'Positive') AS positive_count,
  COUNTIF(Sentiment = 'Neutral') AS neutral_count,
  COUNTIF(Sentiment = 'Negative') AS negative_count,
  ROUND(COUNTIF(Sentiment = 'Positive') * 100.0 / COUNT(*), 2) AS pct_positive,
  ROUND(COUNTIF(Sentiment = 'Negative') * 100.0 / COUNT(*), 2) AS pct_negative
FROM `data-analysis-youtube-comment.youtube_comment.youtube_comments`;


SELECT 
  Sentiment, 
  COUNT(*) AS TotalComments
FROM `data-analysis-youtube-comment.youtube_comment.youtube_comments`
GROUP BY Sentiment
ORDER BY TotalComments DESC;

SELECT 
  VideoTitle,
  VideoId,
  COUNT(*) AS TotalComments
FROM `data-analysis-youtube-comment.youtube_comment.youtube_comments`
GROUP BY VideoTitle, VideoId
ORDER BY TotalComments DESC
LIMIT 10;


SELECT 
  Sentiment,
  ROUND(AVG(Likes), 2) AS avg_likes,
  ROUND(AVG(Replies), 2) AS avg_replies,
  COUNT(*) AS TotalComments
FROM `data-analysis-youtube-comment.youtube_comment.youtube_comments`
GROUP BY Sentiment
ORDER BY avg_likes DESC;

SELECT 
  DATE(PublishedAt) AS DatePosted,
  COUNT(*) AS TotalComments,
  COUNTIF(Sentiment = 'Negative') AS negative_comments,
  ROUND(COUNTIF(Sentiment = 'Negative') * 100.0 / COUNT(*), 2) AS pct_negative
FROM `data-analysis-youtube-comment.youtube_comment.youtube_comments`
GROUP BY DatePosted
ORDER BY DatePosted;


SELECT 
  CountryCode,
  COUNT(*) AS TotalComments,
  ROUND(COUNTIF(Sentiment = 'Negative') * 100.0 / COUNT(*), 2) AS negative_ratio
FROM `data-analysis-youtube-comment.youtube_comment.youtube_comments`
WHERE CountryCode IS NOT NULL
GROUP BY CountryCode
HAVING TotalComments > 500
ORDER BY negative_ratio DESC;


SELECT 
  AuthorName,
  COUNT(*) AS TotalComments,
  COUNTIF(Sentiment = 'Negative') AS negative_comments,
  ROUND(COUNTIF(Sentiment = 'Negative') * 100.0 / COUNT(*), 2) AS pct_negative
FROM `data-analysis-youtube-comment.youtube_comment.youtube_comments`
GROUP BY AuthorName
HAVING TotalComments > 20
ORDER BY pct_negative DESC
LIMIT 15;


SELECT 
  VideoTitle,
  COUNT(*) AS TotalComments,
  ROUND(COUNTIF(Sentiment = 'Negative') * 100.0 / COUNT(*), 2) AS pct_negative
FROM `data-analysis-youtube-comment.youtube_comment.youtube_comments`
GROUP BY VideoTitle
HAVING TotalComments > 50
ORDER BY pct_negative DESC
LIMIT 10;



SELECT
  CASE
    WHEN REGEXP_CONTAINS(LOWER(VideoTitle), r'#shorts')
      OR LENGTH(VideoTitle) < 50
      THEN 'Shorts'
    ELSE 'Long-form'
  END AS VideoType,
  COUNT(*) AS total_comments,
  ROUND(COUNTIF(Sentiment = 'Negative')*100.0 / COUNT(*), 2) AS pct_negative
FROM `data-analysis-youtube-comment.youtube_comment.youtube_comments`
GROUP BY VideoType
ORDER BY pct_negative DESC;



SELECT
  CASE
    WHEN REGEXP_CONTAINS(LOWER(VideoTitle),
         r'(news|report|police|president|bbc|cnn)')
      THEN 'News'
    WHEN REGEXP_CONTAINS(LOWER(VideoTitle),
         r'(saved|rescued|love|cry|cute|shock|crazy|amazing)')
      THEN 'Emotional'
    WHEN REGEXP_CONTAINS(LOWER(VideoTitle),
         r'(challenge|prank|funny|viral|meme|dance|music)')
      THEN 'Entertainment'
    ELSE 'Other'
  END AS VideoCategory,
  COUNT(*) AS total_comments,
  ROUND(COUNTIF(Sentiment = 'Negative')*100.0 / COUNT(*), 2) AS pct_negative
FROM `data-analysis-youtube-comment.youtube_comment.youtube_comments`
GROUP BY VideoCategory
ORDER BY total_comments DESC;



SELECT
  FORMAT_DATE('%Y-%m', DATE(PublishedAt)) AS Month,
  CASE
    WHEN LENGTH(VideoTitle) < 50 THEN 'Shorts'
    ELSE 'Long-form'
  END AS VideoType,
  COUNT(*) AS total_comments
FROM `data-analysis-youtube-comment.youtube_comment.youtube_comments`
GROUP BY Month, VideoType
ORDER BY Month, VideoType;



