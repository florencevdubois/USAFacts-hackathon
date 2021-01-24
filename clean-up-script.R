library(tidyverse)

tbl <-
  list.files(pattern = "*.csv") %>% 
  map_df(~read.csv(., sep="\n", header = F))

df <- tbl %>% 
  filter(!lead(str_detect(V1, "BILL TEXT LOOKUP"))==T, # remove unnecessary rows
         !str_detect(V1, "BILL TEXT LOOKUP")) %>% 
  mutate(year = ifelse(str_count(V1, "[0-9]")==4 & !str_detect(V1, "[aA-zZ]"), as.character(V1), NA), # detect rows with only four digits and no letters ---  years
         leg_id = ifelse(lead(is.na(year)==F)==T, as.character(V1), NA)) %>% # add legislative action id (detect rows that come before the year row)
  fill(leg_id) %>% 
  mutate(leg_title = ifelse(lag(is.na(year)==F)==T, as.character(V1), NA), # fill in other info
         leg_status = ifelse(str_detect(V1, "Status:"),  as.character(V1), NA),
         leg_author = ifelse(str_detect(V1, "Author:"),  as.character(V1), NA),
         leg_topics = ifelse(str_detect(V1, "Topics:"),  as.character(V1), NA),
         leg_summary = ifelse(str_detect(V1, "Summary:"),  as.character(V1), NA),
         history = ifelse(str_detect(V1, "[0-9]{2}[-|\\/]{1}[0-9]{2}[-|\\/]{1}[0-9]{4}") & !str_detect(V1, "Date of Last Action"), as.character(V1), NA)) %>% # fill in history column with observations that have the pattern dd/mm/yyyy
  fill(year) %>% 
  dplyr::select(-V1)

df_history <- df %>% # get history column and clean it up
  select(leg_id,year,history) %>% 
  drop_na() %>% 
  group_by(leg_id,year) %>% 
  mutate(history_seq = row_number()) 

df_meta <- df %>%  # get all other columns and remove NAs
  select(-history) %>% 
  group_by(leg_id,year) %>% 
  summarise_all(funs( na.omit(unique(.)) )) # remove NAs

df_all <- df_meta %>% # join together
  full_join(df_history)

ls(df_all)

# leg_id: legislation id  (includes state) State ok
# leg_title: title of legislation
# leg_author: main and additional authors
# leg_status: status of legislation
# leg_summary: summary of legislation
# leg_topics: topics of legislation
# history: steps taken by legislation (one row per step)
# history_seq: numbers for steps of the history

write_csv(df_all, "all_state_leg_cleaned.csv") # save






