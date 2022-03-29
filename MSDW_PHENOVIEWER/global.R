library(tidyverse)



my_plot_theme <- function(){
  theme_bw() +
  theme(panel.grid = element_blank(), legend.position = 'right',
          axis.title = element_text(size = 14), axis.text = element_text(size = 14), 
          legend.text = element_text(size = 14), legend.title = element_text(size = 16))
}



################################################################################
# Longitudinal changes
# This section is for visualizing longitudinal changes of being tested/observed 
# for a particular phenotype
################################################################################

## Load data
phenotype_rank_all_by_year <- read_csv('data/longitudinal/observed_phenotype_rank_all_by_year.csv')
tested_phenotype_rank_all_by_year <- read_csv('data/longitudinal/tested_phenotype_rank_all_by_year.csv')
tested_patient_count_by_year <- read_csv('data/longitudinal/tested_patient_count_by_year.csv')

## Define Plotting Methods
plot_phenotypes_of_interest_by_year <- function(terms_of_interest, df, normalize=TRUE){
  hpo_terms_selected <- df %>% filter(termid %in% terms_of_interest) %>% select(termid, label) %>% distinct()
  
  y_str = ifelse(normalize, 'n_patient/n_tested', 'n_patient')
  y_label = ifelse(normalize, 'patient fraction normalized to database size', 'patient count')
  
  p <- df %>% 
    ggplot(aes(x = lab_year, y = eval(parse(text=y_str)), group = termid, color = termid)) + 
    geom_point() +
    geom_line() +
    scale_color_discrete(breaks = hpo_terms_selected$termid, labels = str_c(hpo_terms_selected$termid, hpo_terms_selected$label, sep = " ")) +
    xlab('Year') +
    ylab(y_label) +
    my_plot_theme()
  
  return (p)
}

table_phenotype_been_observed_longitudinal <- function(termids){
  df <- phenotype_rank_all_by_year %>%
    left_join(tested_patient_count_by_year %>% rename(n_tested = n_patient), by = 'lab_year') %>% 
    filter(termid %in% termids) %>% 
    filter(lab_year <= 2019 & lab_year > 2000)
  return (df)
}

plot_phenotype_been_observed_longitudinal <- function(termids){
  df <- table_phenotype_been_observed_longitudinal(termids)
  plot_phenotypes_of_interest_by_year(terms_of_interest = termids, df = df , normalize = TRUE)
}



table_phenotype_been_tested_longitudinal <- function(termids){
  df <- tested_phenotype_rank_all_by_year %>% 
    left_join(tested_patient_count_by_year %>% 
                rename(n_tested = n_patient), by = 'lab_year')  %>% 
    filter(termid %in% termids) %>% 
    filter(lab_year <= 2019 & lab_year > 2000)
  return (df)
}

plot_phenotype_been_tested_longitudinal <- function(termids){
  df <- table_phenotype_been_tested_longitudinal(termids)
  plot_phenotypes_of_interest_by_year(terms_of_interest = termids, df = df, normalize = TRUE)
}





################################################################################
# Racial differences
# This section is for visualizing racial difference of being tested/observed 
# for a particular phenotype
################################################################################

## Load data
racial_abnormality_fisher <- read_csv('data/racial_difference/racial_abnormality_fisher.csv')
racial_tested_abnormality_fisher <- read_csv('data/racial_difference/racial_tested_abnormality_fisher.csv')


## define data subsetting and plotting methods
table_phenotype_been_observed_racial_difference_by_phenotype <- function(termids){
  racial_abnormality_fisher %>% filter(between(lab_year, 2003, 2019)) %>% 
    filter(race %in% c('White', 'Black or African American', 'Asian')) %>% 
    filter(termid %in% termids)
}

plot_phenotype_been_observed_racial_difference_by_phenotype <- function(termids){
  df <- table_phenotype_been_observed_racial_difference_by_phenotype(termids)
  df %>% 
    {
      ggplot(., aes(x = lab_year, y = estimate, group = termid, color = termid)) + 
        geom_point() +
        geom_line() +
        scale_color_discrete(breaks = .$termid, labels = str_c(.$termid, .$label, sep = " ")) +
        #geom_hline(yintercept = c(0.8, 1.2), color = 'red', linetype = 'dotted') +
        annotate(geom='rect', ymin = 0.8, ymax = 1.2, xmin = -Inf, xmax = Inf, fill = 'magenta', alpha = 0.2) +
        geom_hline(yintercept = 1, color = 'black') +
        xlab('Year') +
        ylab('odds ratio') +
        my_plot_theme() +
        facet_wrap(~race, ncol = 1)
    }
}


table_phenotype_been_tested_racial_difference_by_phenotype <- function(termids){
  racial_tested_abnormality_fisher %>% filter(between(lab_year, 2003, 2019)) %>%
    filter(race %in% c('White', 'Black or African American', 'Asian')) %>%
    filter(termid %in% termids)
}

plot_phenotype_been_tested_racial_difference_by_phenotype <- function(termids){
  df <- table_phenotype_been_tested_racial_difference_by_phenotype(termids)
  df %>%
    {
      ggplot(., aes(x = lab_year, y = estimate, group = termid, color = termid)) +
        geom_point() +
        geom_line() +
        scale_color_discrete(breaks = .$termid, labels = str_c(.$termid, .$label, sep = " ")) +
        #geom_hline(yintercept = c(0.8, 1.2), color = 'red', linetype = 'dotted') +
        annotate(geom='rect', ymin = 0.8, ymax = 1.2, xmin = -Inf, xmax = Inf, fill = 'magenta', alpha = 0.2) +
        geom_hline(yintercept = 1, color = 'black') +
        xlab('Year') +
        ylab('odds ratio') +
        my_plot_theme() +
        facet_wrap(~race, ncol = 1)
    }
}


################################################################################
# Human Phenotype Ontology
# This section is for parsing HPO into a tree structure
################################################################################
hp_term_list_path <- '/Users/xingminzhang/git/s4-pd-dmsdw/pd-dmsdw-loinc2hpo-app/src/main/resources/hp_term_list.csv'
hp_is_a_pairs_path <- '/Users/xingminzhang/git/s4-pd-dmsdw/pd-dmsdw-loinc2hpo-app/src/main/resources/hp_is_a_pairs.csv'
hp_term_list <- read_csv(hp_term_list_path, col_names = c('termid', 'distance_to_root', 'label'))
hp_is_a_pairs <- read_csv(hp_is_a_pairs_path)

parse_hpo_to_tree <- function(hp_term_list_path, hp_is_a_pairs_path){
  # TODO: parse HPO to return a tree structure
  hp_tree <- list()
  return (hp_tree)
}



