# USAFacts Hackathon

USA Facts organized a Hackathon to collect data on environmental legislation. I contributed by collecting and cleaning data on state environmental legislation. The final dataset is saved here: `all_state_leg_cleaned.csv`. It contains the following variables:

- `leg_id`: legislation id  (states can be identified using the state acronym) 
- `leg_title`: title of legislation
- `leg_author`: main author and additional authors
- `leg_status`: status of legislation
- `leg_summary`: summary of legislation
- `leg_topics`: topics of legislation
- `history`: steps taken by legislation (one row per step) --- they are ordered using the `history_seq` variable
- `history_seq`: step numbers for the `history` variable
- `year`

The R code used to clean the raw files is called `clean_up_script`. 