library(tidyverse)
library(here)

args <- commandArgs(trailingOnly = TRUE)

results_dir <- args[1]
project <- args[2]
html_file <- args[3]

quality_rmd <- here("RNA_seq/src/scripts/QC_only.Rmd")

custom_params <- list(
  genome = "GRCm38",
  DE_alpha = 0.05,
  DE_lfc = 1,
  counts = file.path(results_dir, paste0(project, "_countTable_cutadapt_trim.txt")),
  fastqc_one = file.path(results_dir, "fastqc_pre_trim_summary_untrimmed.tsv"),
  fastqc_two = file.path(results_dir, "fastqc_cutadapt_summary_trimmed.tsv"),
  star_stats = file.path(results_dir, "star_summary_cutadapt_trim.tsv"),
  output_dir = file.path(results_dir, "R_analysis_check"),
  sample_info = here("RNA_seq", "files_gao", "sample_info.csv"),
  fastq_screen = file.path(results_dir, "fastq_screen", "fastq_screen_info.csv"),
  sample_column = "genotype",
  snakemake = TRUE
)

#For troubleshooting
#--------------------------------------------------------------
# Diagnose input file paths
input_names <- c(
  "counts",
  "fastqc_one",
  "fastqc_two",
  "star_stats",
  "sample_info",
  "fastq_screen"
)

for (name in input_names) {
  path <- custom_params[[name]]

  cat("\n", name, "\n")
  cat("Path:", path, "\n")
  cat("Exists:", file.exists(path), "\n")
  cat("Readable:", file.access(path, 4) == 0, "\n")
}
#----------------------------------------------------

rmarkdown::render(quality_rmd, output_file = html_file, params = custom_params,
                  envir = new.env())
