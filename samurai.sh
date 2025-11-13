#!/bin/bash
#===============================================================================
# samurai.sh - SAM File Alignment Analysis Tool
#
# Description:
#   Analyzes one or more SAM (Sequence Alignment/Map) files and generates
#   a comprehensive alignment report. The script processes SAM files to count
#   total reads, aligned reads, and maps aligned sequences to chromosomes
#   using an assembly report.
#
# Usage:
#   ./samurai.sh <file1.sam> <file2.sam> ... <assembly_report>
#
# Arguments:
#   SAM files       - One or more SAM format alignment files (all but last parameter)
#   assembly_report - Reference genome assembly report (must be last parameter)
#
# Output:
#   Creates output.txt containing:
#   - Total reads processed across all SAM files
#   - Total aligned reads
#   - Per-chromosome alignment statistics
#   - Script execution time
#
# Requirements:
#   - Standard Unix tools: awk, grep, sort, uniq, join
#   - SAM files must follow standard SAM format specifications
#   - Assembly report must contain accession-to-chromosome mappings
#===============================================================================

# Initialize timing variable to track script execution duration
SECONDS=0

#===============================================================================
# INPUT PARAMETERS
#===============================================================================

# Parse command-line arguments
# All parameters except the last are treated as SAM files
SAM_FILES=("${@:1:$#-1}")

# The final parameter is treated as the assembly report
ASSEMBLY_REPORT=("${@: -1}")

#===============================================================================
# INPUT VALIDATION FUNCTION
#===============================================================================

check_input() {
  # Verify minimum number of parameters (at least 1 SAM file + 1 assembly report)
  if [ "$#" -lt 2 ]; then
    echo 
    echo " - Hey, I need at least One Sam file and Exactly One Assembly report as the LAST parameter!"
    echo " - Run it like this: $0 <file1.sam> <file2.sam> ... <assembly_report>" 
    echo 
    exit 1
  fi 
  
  # Verify that the last parameter is NOT a SAM file (case-insensitive check)
  if [[ "$(echo "$ASSEMBLY_REPORT" | tr '[:upper:]' '[:lower:]')" == *.sam ]]; then
    echo
    echo " - The last parameter MUST be an Assembly report!"
    echo " - Run it like this: $0 <file1.sam> <file2.sam> ... <assembly_report>"
    echo
    exit 1
  fi
  
  # Verify that all parameters except the last have .sam extension
  for f in "${SAM_FILES[@]}"; do
    file_name=$(echo "$f" | tr '[:upper:]' '[:lower:]')
    if [[ "$file_name" != *.sam ]]; then     
      echo 
      echo " - All parameters except the last MUST be SAM files!" 
      echo
      exit 1
    fi
  done 
}

# Execute input validation
check_input "$@"

#===============================================================================
# OUTPUT CONFIGURATION
#===============================================================================

# Define main output file for analysis results
OUTPUT_FILE="output.txt"
 
# Clear/initialize output files at the start of execution
> "$OUTPUT_FILE"                # Main output file
> acc_tf                        # Temporary file for accession numbers
  
#===============================================================================
# ASSEMBLY REPORT PROCESSING
#===============================================================================

# Create accession-to-chromosome mapping from assembly report
# Excludes comment lines (starting with #), extracts columns 5 (accession) and 1 (chromosome)
# Sorts the output for efficient joining later
awk '!/^#/ {print $5 "\t" $1}' "$ASSEMBLY_REPORT" | sort > acc_to_chr_tf

#===============================================================================
# SAM FILE ANALYSIS
#===============================================================================

# Initialize counters for cumulative statistics across all SAM files
total_reads=0
total_aligned_reads=0

# Process each SAM file individually
for sam_file in "${SAM_FILES[@]}"; do
    # Count total number of reads (exclude header lines starting with @)
    reads=$(grep -vc "^@" "$sam_file")    
   
    # Count aligned reads (non-header lines where RNAME field ≠ "*")
    # In SAM format, RNAME="*" indicates an unmapped read
    aligned_reads=$(awk '!/^@/ && $3 != "*"' "$sam_file" | wc -l) 
    
    # Accumulate totals across all SAM files
    (( total_reads += reads ))
    (( total_aligned_reads += aligned_reads ))
    
    # Extract accession numbers from aligned reads (column 3 = RNAME)
    # Append to temporary file for later aggregation
    awk '!/^@/ && $3 != "*" {print $3}' "$sam_file" >> acc_tf 
done

#===============================================================================
# AGGREGATE ALIGNMENT STATISTICS
#===============================================================================

# Count aligned reads per unique accession across all SAM files
# Sort accessions, count occurrences, reformat as "accession<tab>count"
sort acc_tf | uniq -c | awk '{print $2 "\t" $1}' > total_acc_count_tf

#===============================================================================
# GENERATE FORMATTED OUTPUT REPORT
#===============================================================================

{ 
  echo
  printf "%-3s %-3s %s\n" "===" "SAM FILES ALIGNMENT ANALYSIS" "==="
  echo
  echo 
  
  # Display overall statistics
  printf "%-20s %s\n" "Total reads processed:" "$total_reads"
  printf "%-21s %s\n" "Aligned reads:" " $total_aligned_reads"
  echo
  echo  
  
  # Display per-chromosome alignment statistics
  printf "%-21s %-15s %s\n" "Accession" "Chromosome" "Aligned Reads"
  printf "%-21s %-15s %s\n" "---------------------" "---------------" "---------------" 
  
  # Join accession-to-chromosome mapping with read counts
  # Format output in aligned columns for readability
  join -t $'\t' acc_to_chr_tf total_acc_count_tf | awk '{printf "%-21s %-15s %s\n", $1, $2, $3}'
  echo 
  echo
} >> "$OUTPUT_FILE" 2>&1

#===============================================================================
# EXECUTION SUMMARY
#===============================================================================

# Append total script execution time to output file
printf "%-20s %s\n" "Total execution time:" "$SECONDS s" >> "$OUTPUT_FILE" 2>&1

#===============================================================================
# CLEANUP
#===============================================================================

# Remove all temporary files created during execution
rm -f acc_to_chr_tf acc_tf total_acc_count_tf

#===============================================================================
# USER NOTIFICATION
#===============================================================================

# Display success message and instructions to user
echo
echo " - Script executed successfully ✅" 
echo " - To check the output, run: cat output.txt" 
echo