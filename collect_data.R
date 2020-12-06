# set up: ---------------------------------------------------------------------
library(seqinr)
library(stringr)
library(lubridate)
library(data.table)


path = '~/Desktop/Math_Courses/Umich/701/701project'

# read in metadata: -----------------------------------------------------------
file = sprintf('%s/msa_1123/metadata.tsv', path)
msa = fread(file, sep = '\t', header = TRUE)

exclude_dates = c('2019', '2020', '2020-01', '2020-02', '2020-03',
                     '2020-04', '2020-05', '2020-06', '2020-07', '2020-08', '2020-09', '2020-10',
                     '2020-01-XX', '2020-02-XX', '2020-03-XX',
                     '2020-04-XX')
msa = msa[!(date %in% exclude_dates)]

manhattan = msa[location == 'Manhattan']

# summary statistics
summary(as_date(manhattan$date))
manhattan[, date:=as_date(date)]
manhattan[date >= ymd("2020-03-20"), .N]

summary(as.numeric(manhattan$age))
manhattan[, .N, sex]

non_manhattan = msa[location != 'Manhattan' & as_date(date) < as_date('2020-05-31') &
                      as_date(date) > as_date('2019-12-01')]
summary(as_date(non_manhattan$date))

manhattan_meta = manhattan[sample(nrow(manhattan), 100)]
summary(as_date(manhattan_meta$date))
manhattan_meta[date >= ymd("2020-03-22"), .N] #22/94

non_manhattan_eu = non_manhattan[region=="Europe"]

non_manhattan_na = non_manhattan[region=="North America"]

eu_fasta = non_manhattan_eu[sample(nrow(non_manhattan_eu), 30)]

summary(as_date(eu_fasta$date)) #30

na_fasta = non_manhattan_na_start[sample(nrow(non_manhattan_na_start), 20)]

summary(as_date(na_fasta$date)) #20

non_manhattan_meta = rbind(eu_fasta, na_fasta)
# save metadata for manhattan
file = sprintf('%s/msa_1123/manhattan_meta.csv', path)
fwrite(manhattan_meta, file=file)
file = sprintf('%s/msa_1123/non_manhattan_meta.csv', path)
fwrite(non_manhattan_meta, file=file)
rm(msa)

# read in fasta data: ---------------------------------------------------------
file = sprintf("%s/msa_1123/Archive/msa_1123.fasta", path)

msa_fasta = read.fasta(file = file, as.string = TRUE, strip.desc = TRUE)
manhattan_fasta = msa_fasta[sapply(msa_fasta, function(x) 
                             str_replace_all(str_extract(attr(x, "name"), "\\|\\w*\\|" ), '\\|', '' ) %in% 
                               manhattan_meta$gisaid_epi_isl
                             )]

non_manhattan_fasta = msa_fasta[sapply(msa_fasta, function(x) 
  str_replace_all(str_extract(attr(x, "name"), "\\|\\w*\\|" ), '\\|', '' ) %in% 
    non_manhattan_meta$gisaid_epi_isl
)]
#48

rm(msa_fasta)



# save fasta file
file = sprintf("%s/msa_1123/manhattan_2.fasta", path)

write.fasta(manhattan_fasta, names = names(manhattan_fasta), file.out = file)

file = sprintf("%s/msa_1123/non_manhattan_2.fasta", path)

write.fasta(non_manhattan_fasta, names = names(non_manhattan_fasta), file.out = file)

#
#file = sprintf("%s/msa_1123/data/project.fasta", path)
#project_fasta = read.fasta(file = file, as.string = TRUE, strip.desc = TRUE)
