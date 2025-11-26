-- SELECT * FROM `data-analysis-youtube-comment.youtube_comment.youtube_comments` LIMIT 1000


-- SELECT
--   COUNT(*) AS total_rows,
--   SUM(CASE WHEN CommentId IS NULL THEN 1 ELSE 0 END) AS null_comment_id,
--   SUM(CASE WHEN CommentText IS NULL OR TRIM(CommentText) = '' THEN 1 ELSE 0 END) AS null_or_empty_comment_text,
--   SUM(CASE WHEN Sentiment IS NULL THEN 1 ELSE 0 END) AS null_sentiment,
--   SUM(CASE WHEN Likes IS NULL THEN 1 ELSE 0 END) AS null_likes,
--   SUM(CASE WHEN PublishedAt IS NULL THEN 1 ELSE 0 END) AS null_published_at
-- FROM `data-analysis-youtube-comment.youtube_comment.youtube_comments`;


-- SELECT 
--   CommentId, 
--   COUNT(*) AS duplicate_count
-- FROM `data-analysis-youtube-comment.youtube_comment.youtube_comments`
-- GROUP BY CommentId
-- HAVING COUNT(*) > 1;


CREATE OR REPLACE TABLE 
  `data-analysis-youtube-comment.youtube_comment.youtube_comments` AS
SELECT
  -- remove exact duplicates
  DISTINCT *
FROM (
  SELECT
    CommentId,
    VideoId,
    VideoTitle,
    AuthorName,
    AuthorChannelId,
    -- Clean comment text
    REGEXP_REPLACE(TRIM(CommentText), r'\s+', ' ') AS CommentText,
    -- Standardize sentiment values
    CASE
      WHEN LOWER(Sentiment) LIKE '%pos%' THEN 'Positive'
      WHEN LOWER(Sentiment) LIKE '%neg%' THEN 'Negative'
      WHEN LOWER(Sentiment) LIKE '%neu%' THEN 'Neutral'
      ELSE Sentiment
    END AS Sentiment,
    -- Convert likes + replies to safe integers
    SAFE_CAST(Likes AS INT64) AS Likes,
    SAFE_CAST(Replies AS INT64) AS Replies,
    -- Convert timestamp
    TIMESTAMP(PublishedAt) AS PublishedAt,

    CountryCode,
    CategoryId
  FROM `data-analysis-youtube-comment.youtube_comment.youtube_comments`
  WHERE CommentText IS NOT NULL
    AND TRIM(CommentText) <> ''   -- remove empty comments
);



CREATE OR REPLACE TABLE 
`data-analysis-youtube-comment.youtube_comment.youtube_comments` AS
SELECT
  *,
  DATE(PublishedAt) AS DatePosted,
  FORMAT_DATE('%Y-%m', DATE(PublishedAt)) AS MonthPosted,
  EXTRACT(YEAR FROM PublishedAt) AS YearPosted
FROM `data-analysis-youtube-comment.youtube_comment.youtube_comments`;

