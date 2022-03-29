################################################################################
# RUN the script to create data subsets for testing purposes
# Resulting data are under "data-test"
# Resulting data can be uploaded to public RShiny server for demo purposes
# Full data should be handled after consulting with Sema4 legal
################################################################################

library(tidyverse)
phenotype_rank_all_by_year <- read_csv('data/longitudinal/observed_phenotype_rank_all_by_year.csv')
tested_phenotype_rank_all_by_year <- read_csv('data/longitudinal/tested_phenotype_rank_all_by_year.csv')
tested_patient_count_by_year <- read_csv('data/longitudinal/tested_patient_count_by_year.csv')
racial_abnormality_fisher <- read_csv('data/racial_difference/racial_abnormality_fisher.csv')
racial_tested_abnormality_fisher <- read_csv('data/racial_difference/racial_tested_abnormality_fisher.csv')

terms_for_testing_data <- c("HP:0000119", "HP:0000707", "HP:0000818", "HP:0001197", "HP:0001626", 'HP:0001901', 'HP:0500267', 'HP:0000118', 'HP:0001880', 'HP:0005407')

phenotype_rank_all_by_year %>% 
  filter(termid %in% terms_for_testing_data) %>% 
  write.csv("data-test/longitudinal/observed_phenotype_rank_all_by_year.csv", row.names = FALSE)

tested_phenotype_rank_all_by_year %>% 
  filter(termid %in% terms_for_testing_data) %>% 
  write.csv("data-test/longitudinal/tested_phenotype_rank_all_by_year.csv", row.names = FALSE)

racial_abnormality_fisher %>% 
  filter(termid %in% terms_for_testing_data) %>% 
  write.csv("data-test/racial_difference/racial_abnormality_fisher.csv", row.names = FALSE)

racial_tested_abnormality_fisher %>% 
  filter(termid %in% terms_for_testing_data) %>% 
  write.csv("data-test/racial_difference/racial_tested_abnormality_fisher.csv", row.names = FALSE)
