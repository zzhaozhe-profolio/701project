# set up: ---------------------------------------------------------------------
library(seqinr)
library(stringr)
library(lubridate)
library(data.table)


path = '~/Desktop/Math_Courses/Umich/701/701project'

# read in metadata: -----------------------------------------------------------
file = sprintf('%s/msa_1123/metadata.tsv', path)
msa = fread(file, sep = '\t', header = TRUE)

manhattan = msa[location == 'Manhattan']

# summary statistics
summary(as_date(manhattan$date_submitted))
summary(as.numeric(manhattan$age))
manhattan[, .N, sex]

# save metadata for manhattan
file = sprintf('%s/msa_1123/manhattan_meta.csv', path)
fwrite(manhattan, file=file)
rm(msa)

# read in fasta data: ---------------------------------------------------------
file = sprintf("%s/msa_1123/msa_1123.fasta", path)

msa_fasta = read.fasta(file = file, as.string = TRUE, strip.desc = TRUE)
manhattan_fasta = msa_fasta[sapply(msa_fasta, function(x) 
                             str_replace_all(str_extract(attr(x, "name"), "\\|\\w*\\|" ), '\\|', '' ) %in% 
                               manhattan$gisaid_epi_isl
                             )]

rm(msa_fasta)

# save fasta file
file = sprintf("%s/msa_1123/manhattan.fasta", path)

write.fasta(manhattan_fasta, names = names(manhattan_fasta), file.out = file)
